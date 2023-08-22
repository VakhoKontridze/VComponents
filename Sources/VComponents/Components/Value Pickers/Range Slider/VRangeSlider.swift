//
//  VRangeSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRangeSlider: View {
    // MARK: Properties - UI Model
    private let uiModel: VRangeSliderUIModel
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VRangeSliderInternalState {
        .init(isEnabled: isEnabled)
    }

    // MARK: Properties - Value Range
    private let range: ClosedRange<Double>
    private let difference: Double
    private let step: Double?

    // MARK: Properties - Values
    @Binding private var value: ClosedRange<Double>

    // MARK: Properties - Action
    private let action: ((Bool) -> Void)?

    // MARK: Properties - Sizes
    @State private var sliderSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VRangeSlider` with difference, and low and high values.
    public init<V>(
        uiModel: VRangeSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        difference: V,
        step: V? = nil,
        value: Binding<ClosedRange<V>>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        Self.assertValues(
            value: value.wrappedValue,
            difference: difference
        )
        
        self.uiModel = uiModel

        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.difference = Double(difference)
        self.step = step.map { .init($0) }

        self._value = Binding(
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
            .cornerRadius(uiModel.cornerRadius)
            .frame(
                width: uiModel.direction.isHorizontal ? nil : uiModel.height,
                height: uiModel.direction.isHorizontal ? uiModel.height : nil
            )
            
            thumb(.low)
            thumb(.high)
        })
        .getSize({ sliderSize = $0 })
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
            .foregroundColor( uiModel.trackColors.value(for: internalState))
    }
    
    private var progress: some View {
        Rectangle()
            .padding(uiModel.direction.edgeSet, progressWidth(.low))
            .padding(uiModel.direction.reversed().edgeSet, progressWidth(.high))
            .foregroundColor(uiModel.progressColors.value(for: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }
    
    @ViewBuilder private func thumb(_ thumb: Thumb) -> some View {
        if uiModel.thumbDimension > 0 {
            Group(content: { // `Group` is used for giving multiple frames
                ZStack(content: {
                    thumbBackground
                    thumbBorder
                })
                .frame(dimension: uiModel.thumbDimension)
                .offset(
                    x: uiModel.direction.isHorizontal ? thumbOffset(thumb).withOppositeSign(if: uiModel.direction.isReversed) : 0,
                    y: uiModel.direction.isHorizontal ? 0 : thumbOffset(thumb).withOppositeSign(if: uiModel.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.direction.alignment
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ dragChanged(dragValue: $0, thumb: thumb) })
                    .onEnded({ dragEnded(dragValue: $0) })
            )
        }
    }

    private var thumbBackground: some View {
        RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
            .foregroundColor(uiModel.thumbColors.value(for: internalState))
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
    
    // MARK: Thumb
    private enum Thumb {
        case low
        case high
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value, thumb: Thumb) {
        let rawValue: Double = {
            let value: Double = dragValue.location.coordinate(isX: uiModel.direction.isHorizontal)
            let range: Double = range.boundRange
            let width: Double = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
            
            return (self.range.lowerBound + (value / width) * range)
                .invertedFromMax(
                    self.range.upperBound,
                    if: layoutDirection == .rightToLeft || uiModel.direction.isReversed
                )
        }()
        
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
        
        action?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        action?(false)
    }
    
    // MARK: Actions
    private func setValueLow(to value: Double) {
        self.value = value...self.value.upperBound
    }
    
    private func setValueHigh(to value: Double) {
        self.value = self.value.lowerBound...value
    }
    
    // MARK: Progress Width
    private func progressWidth(_ thumb: Thumb) -> CGFloat {
        let value: CGFloat = {
            switch thumb {
            case .low: return self.value.lowerBound - self.range.lowerBound
            case .high: return self.value.upperBound - self.range.lowerBound
            }
        }()
        let range: CGFloat = range.upperBound - range.lowerBound
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        switch thumb {
        case .low: return (value / range) * width
        case .high: return ((range - value) / range) * width
        }
    }
    
    // MARK: Thumb Offset
    private func thumbOffset(_ thumb: Thumb) -> CGFloat {
        let progressWidth: CGFloat = progressWidth(thumb)
        let thumbWidth: CGFloat = uiModel.thumbDimension
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        switch thumb {
        case .low: return progressWidth - thumbWidth / 2
        case .high: return width - progressWidth - thumbWidth / 2
        }
    }
    
    // MARK: Assertion
    private static func assertValues<V>(
        value: ClosedRange<V>,
        difference: V
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        assert(
            value.boundRange >= difference - .ulpOfOne,
            "Difference between `VRangeSlider`'s `value.upperBound` and `value.lowerBound` must be greater than or equal to `difference`"
        )
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRangeSlider_Previews: PreviewProvider {
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
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }

    // Data
    private static var difference: Double { 0.1 }
    private static var value: ClosedRange<Double> { 0.1...0.8 }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var value: ClosedRange = VRangeSlider_Previews.value

        var body: some View {
            PreviewContainer(content: {
                VRangeSlider(
                    difference: difference,
                    value: $value
                )
                .padding(.horizontal)
            })
        }
    }

    private struct BorderPreview: View {
        @State private var value: ClosedRange = VRangeSlider_Previews.value

        var body: some View {
            PreviewContainer(content: {
                VRangeSlider(
                    uiModel: {
                        var uiModel: VRangeSliderUIModel = .init()
                        uiModel.borderWidth = 1
                        uiModel.borderColors = VRangeSliderUIModel.StateColors(
                            enabled: uiModel.trackColors.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    difference: difference,
                    value: $value
                )
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
                        VRangeSlider(
                            difference: difference,
                            value: .constant(value)
                        )
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VRangeSlider(
                            difference: difference,
                            value: .constant(value)
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct LayoutDirectionsPreview: View {
        private let dimension: CGFloat = {
#if os(iOS)
            return 250
#elseif os(macOS)
            return 300
#else
            fatalError() // Not supported
#endif
        }()

        @State private var value: ClosedRange = VRangeSlider_Previews.value

        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.macOS],
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Left-to-Right",
                        content: {
                            VRangeSlider(
                                uiModel: {
                                    var uiModel: VRangeSliderUIModel = .init()
                                    uiModel.direction = .leftToRight
                                    return uiModel
                                }(),
                                difference: difference,
                                value: $value
                            )
                            .frame(width: dimension)
                        }
                    )

                    PreviewRow(
                        axis: .vertical,
                        title: "Right-to-Left",
                        content: {
                            VRangeSlider(
                                uiModel: {
                                    var uiModel: VRangeSliderUIModel = .init()
                                    uiModel.direction = .rightToLeft
                                    return uiModel
                                }(),
                                difference: difference,
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
                                VRangeSlider(
                                    uiModel: {
                                        var uiModel: VRangeSliderUIModel = .init()
                                        uiModel.direction = .topToBottom
                                        return uiModel
                                    }(),
                                    difference: difference,
                                    value: $value
                                )
                                .frame(height: dimension)
                            }
                        )

                        PreviewRow(
                            axis: .vertical,
                            title: "Bottom-to-Top",
                            content: {
                                VRangeSlider(
                                    uiModel: {
                                        var uiModel: VRangeSliderUIModel = .init()
                                        uiModel.direction = .bottomToTop
                                        return uiModel
                                    }(),
                                    difference: difference,
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
