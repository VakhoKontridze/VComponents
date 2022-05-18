//
//  SliderHelpers.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - Double Bound
extension Double {
    func bound(
        min: Double,
        max: Double,
        step: Double?
    ) -> Double {
        switch (self, step) {
        case (...min, _): return min
        case (max..., _): return max
        case (_, nil): return self
        case (_, let step?): return self.roundedWithStep(min: min, max: max, step: step)
        }
    }
    
    private func roundedWithStep(
        min: Double,
        max: Double,
        step: Double
    ) -> Double {
        min + ((self - min) / step).rounded() * step
    }
}

// MARK: - Normalization of Binding Double in Range
extension Binding where Value == Double {
    init<V>(
        from value: Binding<V>,
        range: ClosedRange<V>,
        step: V?
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.init(
            get: {
                let value: Double = .init(value.wrappedValue)
                let min: Double = .init(range.lowerBound)
                let max: Double = .init(range.upperBound)

                switch value {
                case ...min: return min
                case max...: return max
                case _: return value
                }
            },
            
            set: {
                value.wrappedValue = .init($0)
            }
        )
    }
}
