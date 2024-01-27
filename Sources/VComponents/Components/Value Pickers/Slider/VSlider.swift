//
//  VSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Slider
/// Value picker component that selects value from a bounded linear range of values.
///
///     @State private var value: Double = 0.5
///
///     var body: some View {
///         VSlider(value: $value)
///             .padding()
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
public struct VSlider: View {
    // MARK: Properties - UI Model
    private let uiModel: VSliderUIModel
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VSliderInternalState {
        .init(isEnabled: isEnabled)
    }

    // MARK: Properties - Value Range
    private let range: ClosedRange<Double>
    private let step: Double?
    
    // MARK: Properties - Value
    @Binding private var value: Double

    // MARK: Properties - Handlers
    private let changeHandler: ((Bool) -> Void)?

    // MARK: Properties - Frame
    @State private var sliderSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VSlider` with value.
    public init<V>(
        uiModel: VSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        value: Binding<V>,
        onChange changeHandler: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.uiModel = uiModel

        self.range = ClosedRange(
            lower: Double(range.lowerBound),
            upper: Double(range.upperBound)
        )
        self.step = step.map { Double($0) }

        self._value = Binding( // Like native `Slider`, clamps initial value, but not subsequent ones
            get: { Double(value.wrappedValue.clamped(to: range, step: step)) },
            set: { value.wrappedValue = V($0) }
        )

        self.changeHandler = changeHandler
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: uiModel.direction.toAlignment, content: {
            ZStack(alignment: uiModel.direction.toAlignment, content: {
                trackView
                progressView
                borderView
            })
            .clipShape(.rect(cornerRadius: uiModel.cornerRadius))
            .frame(
                width: uiModel.direction.isHorizontal ? nil : uiModel.height,
                height: uiModel.direction.isHorizontal ? uiModel.height : nil
            )
            
            thumbView
        })
        .getSize({ sliderSize = $0 })
        .applyIf(uiModel.bodyIsDraggable, transform: {
            $0
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        })
        .padding(
            uiModel.direction.isHorizontal ? .horizontal : .vertical,
            uiModel.thumbDimension / 2
        )
        .applyIf(uiModel.appliesProgressAnimation, transform: {
            $0.animation(uiModel.progressAnimation, value: value)
        })
    }
    
    private var trackView: some View {
        Rectangle()
            .foregroundStyle(uiModel.trackColors.value(for: internalState))
    }
    
    private var progressView: some View {
        Rectangle()
            .frame(
                width: uiModel.direction.isHorizontal ? progressWidth : nil,
                height: uiModel.direction.isHorizontal ? nil : progressWidth
            )
            .cornerRadius(uiModel.cornerRadius, corners: uiModel.progressViewRoundedCorners)
            .foregroundStyle(uiModel.progressColors.value(for: internalState))
    }
    
    @ViewBuilder private var borderView: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }
    
    @ViewBuilder private var thumbView: some View {
        if uiModel.thumbDimension > 0 {
            Group(content: { // `Group` is used for giving multiple frames
                ZStack(content: {
                    thumbBackgroundView
                    thumbBorderView
                })
                .frame(dimension: uiModel.thumbDimension)
                .offset(
                    x: uiModel.direction.isHorizontal ? thumbOffset.withOppositeSign(uiModel.direction.isReversed) : 0,
                    y: uiModel.direction.isHorizontal ? 0 : thumbOffset.withOppositeSign(uiModel.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.direction.toAlignment
            )
            .applyIf(
                uiModel.bodyIsDraggable,
                ifTransform: { $0.allowsHitTesting(false) },
                elseTransform: {
                    $0
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                }
            )
        }
    }

    private var thumbBackgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
            .foregroundStyle(uiModel.thumbColors.value(for: internalState))
            .shadow(
                color: uiModel.thumbShadowColors.value(for: internalState),
                radius: uiModel.thumbShadowRadius,
                offset: uiModel.thumbShadowOffset // No need to reverse coordinates on shadow
            )

    }

    private var thumbBorderView: some View {
        RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
            .strokeBorder(uiModel.thumbBorderColors.value(for: internalState), lineWidth: uiModel.thumbBorderWidth.toPoints(scale: displayScale))
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value) {
        let rawValue: Double = {
            let value: Double = dragValue.location.coordinate(isX: uiModel.direction.isHorizontal)
            let range: Double = range.boundRange
            let width: Double = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
            
            return ((value / width) * range + self.range.lowerBound)
                .invertedFromMax(
                    self.range.upperBound,
                    if: layoutDirection.isRightToLeft || uiModel.direction.isReversed
                )
        }()
        
        let valueFixed: Double = rawValue.clamped(to: range, step: step)
        
        setValue(to: valueFixed)
        
        changeHandler?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        changeHandler?(false)
    }
    
    // MARK: Actions
    private func setValue(to value: Double) {
        self.value = value
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let value: CGFloat = value - range.lowerBound
        let range: CGFloat = range.boundRange
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        return (value / range) * width
    }
    
    // MARK: Thumb Offset
    private var thumbOffset: CGFloat {
        progressWidth - uiModel.thumbDimension/2
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var value: Double = 0.5

        var body: some View {
            PreviewContainer(content: {
                VSlider(value: $value)
                    .padding(.horizontal)
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VSlider(value: .constant(0.5))
                .padding(.horizontal)
        })

        PreviewRow("Disabled", content: {
            VSlider(value: .constant(0.5))
                .disabled(true)
                .padding(.horizontal)
        })

        PreviewHeader("Native")

        PreviewRow("Enabled", content: {
            Slider(value: .constant(0.5))
                .padding(.horizontal)
        })

        PreviewRow("Disabled", content: {
            Slider(value: .constant(0.5))
                .disabled(true)
                .padding(.horizontal)
        })
    })
})

#Preview("Layout Directions", body: {
    struct ContentView: View {
        private let length: CGFloat = {
#if os(iOS)
            250
#elseif os(macOS)
            300
#else
            fatalError() // Not supported
#endif
        }()

        @State private var value: Double = 0.5

        var body: some View {
            PreviewContainer(
                content: {
                    PreviewRow("Left-to-Right", content: {
                        VSlider(
                            uiModel: {
                                var uiModel: VSliderUIModel = .init()
                                uiModel.direction = .leftToRight
                                return uiModel
                            }(),
                            value: $value
                        )
                        .frame(width: length)
                    })

                    PreviewRow("Right-to-Left", content: {
                        VSlider(
                            uiModel: {
                                var uiModel: VSliderUIModel = .init()
                                uiModel.direction = .rightToLeft
                                return uiModel
                            }(),
                            value: $value
                        )
                        .frame(width: length)
                    })

                    HStack(spacing: 20, content: {
                        PreviewRow("Top-to-Bottom", content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.direction = .topToBottom
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(height: length)
                        })

                        PreviewRow("Bottom-to-Top", content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.direction = .bottomToTop
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(height: length)
                        })
                    })
                }
            )
        }
    }

    return ContentView()
})

#Preview("Draggable Body", body: {
    struct ContentView: View {
        @State private var value: Double = 0.5

        var body: some View {
            PreviewContainer(content: {
                VSlider(
                    uiModel: {
                        var uiModel: VSliderUIModel = .init()
                        uiModel.bodyIsDraggable = true
                        return uiModel
                    }(),
                    value: $value
                )
                .padding(.horizontal)
            })
        }
    }

    return ContentView()
})

#endif

#endif
