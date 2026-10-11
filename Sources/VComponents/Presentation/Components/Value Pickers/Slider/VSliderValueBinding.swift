import SwiftUI
import VCore

// Rendering and drag handling both expect values in the caller's range, not ratios.
enum VSliderValueBinding {
    static func make<V>(
        range: ClosedRange<V>,
        step: V?,
        value: Binding<V>
    ) -> Binding<Double>
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        return Binding(
            get: {
                guard range.lowerBound.isFinite, range.upperBound.isFinite else { return 0 }

                let currentValue: Double = Double(value.wrappedValue)
                guard range.upperBound > range.lowerBound, currentValue.isFinite else {
                    return Double(range.lowerBound)
                }

                return currentValue.clamped(
                    to: Double(range.lowerBound)...Double(range.upperBound),
                    step: step.map { Double($0) }
                )
            },
            set: { value.wrappedValue = V($0) }
        )
    }
}
