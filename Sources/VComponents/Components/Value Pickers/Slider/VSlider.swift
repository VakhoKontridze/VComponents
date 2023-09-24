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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
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

    // MARK: Properties - Action
    private let action: ((Bool) -> Void)?

    // MARK: Properties - Frame
    @State private var sliderSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VSlider` with value.
    public init<V>(
        uiModel: VSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        value: Binding<V>,
        onChange action: ((Bool) -> Void)? = nil
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

        self._value = Binding(
            get: { Double(value.wrappedValue.clamped(to: range, step: step)) },
            set: { value.wrappedValue = V($0) }
        )

        self.action = action
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: uiModel.direction.alignment, content: {
            ZStack(alignment: uiModel.direction.alignment, content: {
                track
                progress
                border
            })
            .clipShape(RoundedRectangle(cornerRadius: uiModel.cornerRadius))
            .frame(
                width: uiModel.direction.isHorizontal ? nil : uiModel.height,
                height: uiModel.direction.isHorizontal ? uiModel.height : nil
            )
            
            thumb
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
    
    private var track: some View {
        Rectangle()
            .foregroundStyle(uiModel.trackColors.value(for: internalState))
    }
    
    private var progress: some View {
        Rectangle()
            .frame(
                width: uiModel.direction.isHorizontal ? progressWidth : nil,
                height: uiModel.direction.isHorizontal ? nil : progressWidth
            )
            .cornerRadius(uiModel.cornerRadius, corners: uiModel.progressViewRoundedCorners)
            .foregroundStyle(uiModel.progressColors.value(for: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }
    
    @ViewBuilder private var thumb: some View {
        if uiModel.thumbDimension > 0 {
            Group(content: { // `Group` is used for giving multiple frames
                ZStack(content: {
                    thumbBackground
                    thumbBorder
                })
                .frame(dimension: uiModel.thumbDimension)
                .offset(
                    x: uiModel.direction.isHorizontal ? thumbOffset.withOppositeSign(if: uiModel.direction.isReversed) : 0,
                    y: uiModel.direction.isHorizontal ? 0 : thumbOffset.withOppositeSign(if: uiModel.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.direction.alignment
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

    private var thumbBackground: some View {
        RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
            .foregroundStyle(uiModel.thumbColors.value(for: internalState))
            .shadow(
                color: uiModel.thumbShadowColors.value(for: internalState),
                radius: uiModel.thumbShadowRadius,
                offset: uiModel.thumbShadowOffset // No need to reverse coordinates on shadow
            )

    }

    private var thumbBorder: some View {
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
                    if: layoutDirection == .rightToLeft || uiModel.direction.isReversed
                )
        }()
        
        let valueFixed: Double = rawValue.clamped(to: range, step: step)
        
        setValue(to: valueFixed)
        
        action?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        action?(false)
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
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VSlider_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            BorderPreview().previewDisplayName("Border")
            DraggableBodyPreview().previewDisplayName("Draggable Body")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var value: Double { 0.5 }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var value: Double = VSlider_Previews.value
        
        var body: some View {
            PreviewContainer(content: {
                VSlider(value: $value)
                    .padding(.horizontal)
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VSlider(value: .constant(value))
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VSlider(value: .constant(value))
                            .disabled(true)
                    }
                )
                
                PreviewSectionHeader("Native")
                
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        Slider(value: .constant(value))
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        Slider(value: .constant(value))
                            .disabled(true)
                    }
                )
            })
        }
    }

    private struct BorderPreview: View {
        @State private var value: Double = VSlider_Previews.value

        var body: some View {
            PreviewContainer(content: {
                VSlider(
                    uiModel: {
                        var uiModel: VSliderUIModel = .init()
                        uiModel.borderWidth = 1
                        uiModel.borderColors = VSliderUIModel.StateColors(
                            enabled: uiModel.trackColors.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    value: $value
                )
                .padding(.horizontal)
            })
        }
    }

    private struct DraggableBodyPreview: View {
        @State private var value: Double = VSlider_Previews.value

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
    
    private struct LayoutDirectionsPreview: View {
        private let dimension: CGFloat = {
#if os(iOS)
            250
#elseif os(macOS)
            300
#else
            fatalError() // Not supported
#endif
        }()
        
        @State private var value: Double = VSlider_Previews.value
        
        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.macOS],
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Left-to-Right",
                        content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.direction = .leftToRight
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(width: dimension)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Right-to-Left",
                        content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.direction = .rightToLeft
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(width: dimension)
                        }
                    )
                    
                    HStack(content: {
                        PreviewRow(
                            axis: .vertical,
                            title: "Top-to-Bottom",
                            content: {
                                VSlider(
                                    uiModel: {
                                        var uiModel: VSliderUIModel = .init()
                                        uiModel.direction = .topToBottom
                                        return uiModel
                                    }(),
                                    value: $value
                                )
                                .frame(height: dimension)
                            }
                        )
                        
                        PreviewRow(
                            axis: .vertical,
                            title: "Bottom-to-Top",
                            content: {
                                VSlider(
                                    uiModel: {
                                        var uiModel: VSliderUIModel = .init()
                                        uiModel.direction = .bottomToTop
                                        return uiModel
                                    }(),
                                    value: $value
                                )
                                .frame(height: dimension)
                            }
                        )
                    })
                }
            )
        }
    }
}
