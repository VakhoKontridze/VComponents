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
/// UI Model, range, step, state, and onChange callbacks can be passed as parameters.
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
    
    @State private var sliderWidth: CGFloat = 0

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
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.difference = .init(difference)
        self.step = step.map { .init($0) }
        self._valueLow = .init(
            get: { .init(valueLow.wrappedValue.clamped(to: range, step: step)) },
            set: { valueLow.wrappedValue = .init($0) }
        )
        self._valueHigh = .init(
            get: { .init(valueHigh.wrappedValue.clamped(to: range, step: step)) },
            set: { valueHigh.wrappedValue = .init($0) }
        )
        self.actionLow = actionLow
        self.actionHigh = actionHigh
    }

    // MARK: Body
    public var body: some View {
        ZStack(alignment: .leading, content: {
            ZStack(alignment: .leading, content: {
                track
                progress
            })
                .mask(RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius))
                .frame(height: uiModel.layout.height)
            
            thumb(.low)
            thumb(.high)
        })
            .onSizeChange(perform: { sliderWidth = $0.width })
            .padding(.horizontal, uiModel.layout.thumbDimension / 2)
            .disabled(!internalState.isEnabled)
            .animation(uiModel.animations.progress, value: valueLow)
            .animation(uiModel.animations.progress, value: valueHigh)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor( uiModel.colors.track.value(for: internalState))
    }

    private var progress: some View {
        Rectangle()
            .padding(.leading, progressWidth(.low))
            .padding(.trailing, progressWidth(.high))
            .foregroundColor(uiModel.colors.progress.value(for: internalState))
    }

    private func thumb(_ thumb: Thumb) -> some View {
        Group(content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                    .foregroundColor(uiModel.colors.thumb.value(for: internalState))
                    .shadow(
                        color: uiModel.colors.thumbShadow.value(for: internalState),
                        radius: uiModel.layout.thumbShadowRadius,
                        x: uiModel.layout.thumbShadowOffset.width,
                        y: uiModel.layout.thumbShadowOffset.height
                    )

                RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                    .strokeBorder(uiModel.colors.thumbBorder.value(for: internalState), lineWidth: uiModel.layout.thumbBorderWidth)
            })
                .frame(dimension: uiModel.layout.thumbDimension)
                .offset(x: thumbOffset(thumb))
        })
            .frame(maxWidth: .infinity, alignment: .leading)    // Must be put into group, as content already has frame

            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ dragChanged(dragValue: $0, thumb: thumb) })
                    .onEnded({ dragEnded(dragValue: $0, thumb: thumb) })
            )
    }
    
    // MARK: Thumb
    private enum Thumb {
        case low
        case high
    }

    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value, thumb: Thumb) {
        let rawValue: Double = {
            let value: Double = .init(dragValue.location.x)
            let range: Double = max - min
            let width: Double = .init(sliderWidth)

            return min + (value / width) * range
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
            case .low: return .init(valueLow - min)
            case .high: return .init(valueHigh - min)
            }
        }()
        let range: CGFloat = .init(max - min)
        let width: CGFloat = sliderWidth

        switch thumb {
        case .low: return (value / range) * width
        case .high: return ((range - value) / range) * width
        }
    }

    // MARK: Thumb Offset
    private func thumbOffset(_ thumb: Thumb) -> CGFloat {
        let progressW: CGFloat = progressWidth(thumb)
        let thumbW: CGFloat = uiModel.layout.thumbDimension
        let width: CGFloat = sliderWidth

        switch thumb {
        case .low: return progressW - thumbW / 2
        case .high: return width - progressW - thumbW / 2
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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRangeSlider_Previews: PreviewProvider {
    // Configuration
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
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
}
