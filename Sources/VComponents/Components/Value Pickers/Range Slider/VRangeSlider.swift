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
/// UI Model, range, step, and onChange callbacks can be passed as parameters.
///
///     @State private var valueLow: Double = 0.3
///     @State private var valueHigh: Double = 0.8
///
///     var body: some View {
///         VRangeSlider(
///             difference: 0.1,
///             valueLow: $valueLow,
///             valueHigh: $valueHigh
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRangeSlider: View {
    // MARK: Properties
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    private let uiModel: VRangeSliderUIModel
    
    private let min, max: Double
    private var range: ClosedRange<Double> { min...max }
    private let difference: Double
    private let step: Double?
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VRangeSliderInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var valueLow: Double
    @Binding private var valueHigh: Double
    
    private let actionLow: ((Bool) -> Void)?
    private let actionHigh: ((Bool) -> Void)?
    
    @State private var sliderSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VRangeSlider` with difference, and low and high values.
    public init<V>(
        uiModel: VRangeSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        difference: V,
        step: V? = nil,
        valueLow: Binding<V>,
        valueHigh: Binding<V>,
        onChangeLow actionLow: ((Bool) -> Void)? = nil,
        onChangeHigh actionHigh: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        Self.assertValues(
            valueLow: valueLow.wrappedValue,
            valueHigh: valueHigh.wrappedValue,
            difference: difference
        )
        
        self.uiModel = uiModel
        self.min = Double(range.lowerBound)
        self.max = Double(range.upperBound)
        self.difference = Double(difference)
        self.step = step.map { .init($0) }
        self._valueLow = Binding(
            get: { Double(valueLow.wrappedValue.clamped(to: range, step: step)) },
            set: { valueLow.wrappedValue = V($0) }
        )
        self._valueHigh = Binding(
            get: { Double(valueHigh.wrappedValue.clamped(to: range, step: step)) },
            set: { valueHigh.wrappedValue = V($0) }
        )
        self.actionLow = actionLow
        self.actionHigh = actionHigh
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: uiModel.layout.direction.alignment, content: {
            ZStack(alignment: uiModel.layout.direction.alignment, content: {
                track
                progress
                border
            })
            .mask(RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius))
            .frame(
                width: uiModel.layout.direction.isHorizontal ? nil : uiModel.layout.height,
                height: uiModel.layout.direction.isHorizontal ? uiModel.layout.height : nil
            )
            
            thumb(.low)
            thumb(.high)
        })
        .onSizeChange(perform: { sliderSize = $0 })
        .padding(
            uiModel.layout.direction.isHorizontal ? .horizontal : .vertical,
            uiModel.layout.thumbDimension / 2
        )
        .applyIf(uiModel.animations.appliesProgressAnimation, transform: {
            $0
                .animation(uiModel.animations.progress, value: valueLow)
                .animation(uiModel.animations.progress, value: valueHigh)
        })
    }
    
    private var track: some View {
        Rectangle()
            .foregroundColor( uiModel.colors.track.value(for: internalState))
    }
    
    private var progress: some View {
        Rectangle()
            .padding(uiModel.layout.direction.edgeSet, progressWidth(.low))
            .padding(uiModel.layout.direction.reversed().edgeSet, progressWidth(.high))
            .foregroundColor(uiModel.colors.progress.value(for: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        }
    }
    
    @ViewBuilder private func thumb(_ thumb: Thumb) -> some View {
        if uiModel.layout.thumbDimension > 0 {
            Group(content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .foregroundColor(uiModel.colors.thumb.value(for: internalState))
                        .shadow(
                            color: uiModel.colors.thumbShadow.value(for: internalState),
                            radius: uiModel.colors.thumbShadowRadius,
                            offset: uiModel.colors.thumbShadowOffset // No need to reverse coordinates on shadow
                        )
                    
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .strokeBorder(uiModel.colors.thumbBorder.value(for: internalState), lineWidth: uiModel.layout.thumbBorderWidth)
                })
                .frame(dimension: uiModel.layout.thumbDimension)
                .offset(
                    x: uiModel.layout.direction.isHorizontal ? thumbOffset(thumb).withOppositeSign(if: uiModel.layout.direction.isReversed) : 0,
                    y: uiModel.layout.direction.isHorizontal ? 0 : thumbOffset(thumb).withOppositeSign(if: uiModel.layout.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.layout.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.layout.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.layout.direction.alignment
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ dragChanged(dragValue: $0, thumb: thumb) })
                    .onEnded({ dragEnded(dragValue: $0, thumb: thumb) })
            )
        }
    }
    
    // MARK: Thumb
    private enum Thumb {
        case low
        case high
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value, thumb: Thumb) {
        let rawValue: Double = {
            let value: Double = dragValue.location.coordinate(isX: uiModel.layout.direction.isHorizontal)
            let range: Double = max - min
            let width: Double = sliderSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)
            
            return (min + (value / width) * range)
                .invertedFromMax(
                    max,
                    if: layoutDirection == .rightToLeft || uiModel.layout.direction.isReversed
                )
        }()
        
        let valueFixed: Double = {
            switch thumb {
            case .low:
                return rawValue.clamped(
                    min: min,
                    max: Swift.min((valueHigh - difference).roundedDownWithStep(step), max),
                    step: step
                )
                
            case .high:
                return rawValue.clamped(
                    min: Swift.max((valueLow + difference).roundedUpWithStep(step), min),
                    max: max,
                    step: step
                )
            }
        }()
        
        switch thumb {
        case .low: setValueLow(to: valueFixed)
        case .high: setValueHigh(to: valueFixed)
        }
        
        switch thumb {
        case .low: actionLow?(true)
        case .high: actionHigh?(true)
        }
    }
    
    private func dragEnded(dragValue: DragGesture.Value, thumb: Thumb) {
        switch thumb {
        case .low: actionLow?(false)
        case .high: actionHigh?(false)
        }
    }
    
    // MARK: Actions
    private func setValueLow(to value: Double) {
        self.valueLow = value
    }
    
    private func setValueHigh(to value: Double) {
        self.valueHigh = value
    }
    
    // MARK: Progress Width
    private func progressWidth(_ thumb: Thumb) -> CGFloat {
        let value: CGFloat = {
            switch thumb {
            case .low: return valueLow - min
            case .high: return valueHigh - min
            }
        }()
        let range: CGFloat = max - min
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)
        
        switch thumb {
        case .low: return (value / range) * width
        case .high: return ((range - value) / range) * width
        }
    }
    
    // MARK: Thumb Offset
    private func thumbOffset(_ thumb: Thumb) -> CGFloat {
        let progressWidth: CGFloat = progressWidth(thumb)
        let thumbWidth: CGFloat = uiModel.layout.thumbDimension
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)
        
        switch thumb {
        case .low: return progressWidth - thumbWidth / 2
        case .high: return width - progressWidth - thumbWidth / 2
        }
    }
    
    // MARK: Assertion
    private static func assertValues<V>(
        valueLow: V,
        valueHigh: V,
        difference: V
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        assert(
            valueHigh - valueLow >= difference - .ulpOfOne,
            "Difference between `VRangeSlider`'s `valueLow` and `valueHeight` must be greater than or equal to `difference`"
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
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var difference: Double { 0.1 }
    private static var valueLow: Double { 0.1 }
    private static var valueHigh: Double { 0.8 }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var valueLow: Double = VRangeSlider_Previews.valueLow
        @State private var valueHigh: Double = VRangeSlider_Previews.valueHigh
        
        var body: some View {
            PreviewContainer(content: {
                VRangeSlider(
                    difference: difference,
                    valueLow: $valueLow,
                    valueHigh: $valueHigh
                )
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
                            valueLow: .constant(valueLow),
                            valueHigh: .constant(valueHigh)
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VRangeSlider(
                            difference: difference,
                            valueLow: .constant(valueLow),
                            valueHigh: .constant(valueHigh)
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
        
        @State private var valueLow: Double = VRangeSlider_Previews.valueLow
        @State private var valueHigh: Double = VRangeSlider_Previews.valueHigh
        
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
                                    uiModel.layout.direction = .leftToRight
                                    return uiModel
                                }(),
                                difference: difference,
                                valueLow: $valueLow,
                                valueHigh: $valueHigh
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
                                    uiModel.layout.direction = .rightToLeft
                                    return uiModel
                                }(),
                                difference: difference,
                                valueLow: $valueLow,
                                valueHigh: $valueHigh
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
                                        uiModel.layout.direction = .topToBottom
                                        return uiModel
                                    }(),
                                    difference: difference,
                                    valueLow: $valueLow,
                                    valueHigh: $valueHigh
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
                                        uiModel.layout.direction = .bottomToTop
                                        return uiModel
                                    }(),
                                    difference: difference,
                                    valueLow: $valueLow,
                                    valueHigh: $valueHigh
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
