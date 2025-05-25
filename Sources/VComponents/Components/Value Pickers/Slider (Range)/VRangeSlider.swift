//
//  VRangeSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import OSLog
import VCore

// MARK: - V Range Slider
/// Value picker component that selects values from a bounded linear range of values to represent a range.
///
///     @State private var value: ClosedRange<Double> = 0.3...0.8
///
///     var body: some View {
///         VRangeSlider(
///             difference: 0.1,
///             value: $value
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRangeSlider: View, Sendable {
    // MARK: Properties - UI Model
    private let uiModel: VRangeSliderUIModel
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat
    
    @State private var sliderSize: CGSize = .zero

    // MARK: State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VRangeSliderInternalState {
        .init(
            isEnabled: isEnabled
        )
    }

    // MARK: Properties - Value Range
    private let range: ClosedRange<Double>
    private let difference: Double
    private let step: Double?

    // MARK: Properties - Values
    @Binding private var value: ClosedRange<Double>

    // MARK: Properties - Handlers
    private let changeHandler: ((Bool) -> Void)?
    
    // MARK: Initializers
    /// Initializes `VRangeSlider` with difference, and low and high values.
    public init<V>(
        uiModel: VRangeSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        difference: V,
        step: V? = nil,
        value: Binding<ClosedRange<V>>,
        onChange changeHandler: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        Self.validate(
            value: value.wrappedValue,
            difference: difference,
            step: step
        )
        
        self.uiModel = uiModel

        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.difference = Double(difference)
        self.step = step.map { .init($0) }

        self._value = Binding( // Like native `Slider`, clamps initial value, but not subsequent ones
            get: {
                ClosedRange(
                    lower: Double(value.wrappedValue.lowerBound.clamped(to: range, step: step)),
                    upper: Double(value.wrappedValue.upperBound.clamped(to: range, step: step))
                )
            },
            set: {
                value.wrappedValue = V($0.lowerBound)...V($0.upperBound)
            }
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
            
            thumbView(.low)
            thumbView(.high)
        })
        .getSize({ sliderSize = $0 })
        .applyIf(uiModel.appliesProgressAnimation, transform: {
            $0.animation(uiModel.progressAnimation, value: value)
        })
    }
    
    private var trackView: some View {
        Rectangle()
            .foregroundStyle( uiModel.trackColors.value(for: internalState))
    }
    
    private var progressView: some View {
        Rectangle()
            .padding(uiModel.direction.toEdgeSet, progressWidth(.low))
            .padding(uiModel.direction.reversed().toEdgeSet, progressWidth(.high))
            .foregroundStyle(uiModel.progressColors.value(for: internalState))
    }
    
    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }
    
    @ViewBuilder
    private func thumbView(
        _ thumb: VRangeSliderThumb
    ) -> some View {
        if
            uiModel.thumbSize.width > 0 && 
            uiModel.thumbSize.height > 0
        {
            Group(content: { // `Group` is used for giving multiple frames
                ZStack(content: {
                    thumbBackgroundView
                    thumbBorderView
                })
                .frame(size: uiModel.thumbSize)
                .offset(
                    x: uiModel.direction.isHorizontal ? thumbOffset(thumb).withOppositeSign(uiModel.direction.isReversed) : 0,
                    y: uiModel.direction.isHorizontal ? 0 : thumbOffset(thumb).withOppositeSign(uiModel.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.direction.toAlignment
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ dragChanged(dragValue: $0, thumb: thumb) })
                    .onEnded({ dragEnded(dragValue: $0) })
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

    @ViewBuilder
    private var thumbBorderView: some View {
        let borderWidth: CGFloat = uiModel.thumbBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
                .strokeBorder(uiModel.thumbBorderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value, thumb: VRangeSliderThumb) {
        let dragValue: Double = dragValue.location.coordinate(isX: uiModel.direction.isHorizontal)
        let boundRange: Double = range.boundRange
        guard let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal).nonZero else { return }

        let rawValue: Double = (range.lowerBound + (dragValue / width) * boundRange)
            .invertedFromMax(
                range.upperBound,
                if: layoutDirection.isRightToLeft || uiModel.direction.isReversed
            )

        let valueFixed: Double = {
            switch thumb {
            case .low:
                return rawValue.clamped(
                    min: range.lowerBound,
                    max: Swift.min((value.upperBound - difference).roundedDownWithStep(step), range.upperBound),
                    step: step
                )
                
            case .high:
                return rawValue.clamped(
                    min: Swift.max((value.lowerBound + difference).roundedUpWithStep(step), range.lowerBound),
                    max: range.upperBound,
                    step: step
                )
            }
        }()
        
        switch thumb {
        case .low: setValueLow(to: valueFixed)
        case .high: setValueHigh(to: valueFixed)
        }
        
        changeHandler?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        changeHandler?(false)
    }
    
    // MARK: Actions
    private func setValueLow(to value: Double) {
        self.value = value...self.value.upperBound
    }
    
    private func setValueHigh(to value: Double) {
        self.value = self.value.lowerBound...value
    }
    
    // MARK: Progress Width
    private func progressWidth(_ thumb: VRangeSliderThumb) -> CGFloat {
        let value: CGFloat = {
            switch thumb {
            case .low: self.value.lowerBound - self.range.lowerBound
            case .high: self.value.upperBound - self.range.lowerBound
            }
        }()
        guard let boundRange: Double = range.boundRange.nonZero else { return 0 }
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        switch thumb {
        case .low: return (value / boundRange) * width
        case .high: return ((boundRange - value) / boundRange) * width
        }
    }
    
    // MARK: Thumb Offset
    private func thumbOffset(_ thumb: VRangeSliderThumb) -> CGFloat {
        let progressWidth: CGFloat = progressWidth(thumb)
        guard let thumbWidth: CGFloat = uiModel.thumbSize.dimension(isWidth: uiModel.direction.isHorizontal).nonZero else { return 0 }
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        switch thumb {
        case .low: return progressWidth - thumbWidth / 2
        case .high: return width - progressWidth - thumbWidth / 2
        }
    }
    
    // MARK: Validation
    private static func validate<V>(
        value: ClosedRange<V>,
        difference: V,
        step: V?
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        guard value.boundRange >= difference - .ulpOfOne else {
            Logger.rangeSlider.critical("Difference between 'value.upperBound' and 'value.lowerBound' must be greater than or equal to 'difference' in 'VRangeSlider'")
            fatalError()
        }

        guard step != 0 else {
            Logger.rangeSlider.critical("'step' cannot be '0'")
            fatalError()
        }
    }
}

// MARK: - Helpers
extension Double {
    fileprivate func roundedUpWithStep(
        _ step: Double?
    ) -> Double {
        guard let step else { return self }
        return ceil(self / step) * step
    }
    
    fileprivate func roundedDownWithStep(
        _ step: Double?
    ) -> Double {
        guard let step else { return self }
        return floor(self / step) * step
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    @Previewable @State var value: ClosedRange<Double> = 0.1...0.8

    PreviewContainer(content: {
        VRangeSlider(
            difference: 0.1,
            value: $value
        )
        .padding(.horizontal)
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VRangeSlider(
                difference: 0.1,
                value: .constant(0.1...0.8)
            )
            .padding(.horizontal)
        })

        PreviewRow("Disabled", content: {
            VRangeSlider(
                difference: 0.1,
                value: .constant(0.1...0.8)
            )
            .disabled(true)
            .padding(.horizontal)
        })
    })
})

#Preview("Layout Directions", body: {
    @Previewable @State var value: ClosedRange<Double> = 0.1...0.8 // '@Previewable' items must be at the beginning of the preview block
    
    let difference: Double = 0.1
    
    let length: CGFloat = {
#if os(iOS)
        250
#elseif os(macOS)
        200
#else
        fatalError() // Not supported
#endif
    }()

    PreviewContainer(
        content: {
            PreviewRow("Left-to-Right", content: {
                VRangeSlider(
                    uiModel: {
                        var uiModel: VRangeSliderUIModel = .init()
                        uiModel.direction = .leftToRight
                        return uiModel
                    }(),
                    difference: difference,
                    value: $value
                )
                .frame(width: length)
            })

            PreviewRow("Right-to-Left", content: {
                VRangeSlider(
                    uiModel: {
                        var uiModel: VRangeSliderUIModel = .init()
                        uiModel.direction = .rightToLeft
                        return uiModel
                    }(),
                    difference: difference,
                    value: $value
                )
                .frame(width: length)
            })

            HStack(spacing: 20, content: {
                PreviewRow("Top-to-Bottom", content: {
                    VRangeSlider(
                        uiModel: {
                            var uiModel: VRangeSliderUIModel = .init()
                            uiModel.direction = .topToBottom
                            return uiModel
                        }(),
                        difference: difference,
                        value: $value
                    )
                    .frame(height: length)
                })

                PreviewRow("Bottom-to-Top", content: {
                    VRangeSlider(
                        uiModel: {
                            var uiModel: VRangeSliderUIModel = .init()
                            uiModel.direction = .bottomToTop
                            return uiModel
                        }(),
                        difference: difference,
                        value: $value
                    )
                    .frame(height: length)
                })
            })
        }
    )
})

#Preview("Step", body: {
    @Previewable @State var value: ClosedRange<Double> = 0.1...0.8

    PreviewContainer(content: {
        VRangeSlider(
            difference: 0.1,
            step: 0.1,
            value: $value
        )
        .padding(.horizontal)
    })
})

#endif

#endif
