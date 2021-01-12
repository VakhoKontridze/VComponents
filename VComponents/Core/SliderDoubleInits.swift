//
//  SliderDoubleInits.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK:- Normalization of Double in Range
extension Double {
    func fixedInRange(min: Double, max: Double, step: Double?) -> Double {
        switch (self, step) {
        case (...min, _): return min
        case (max..., _): return max
        case (_, nil): return self
        case (_, let step?): return self.roundWithPrecision(min: min, max: max, step: step)
        }
    }

    private func roundWithPrecision(min: Double, max: Double, step: Double) -> Double {
        let rawValue: Double = (self/step).rounded() * step

        switch rawValue {
        case ...min: return min
        case max...: return max
        case _: return rawValue
        }
    }
}

// MARK:- Normalization Binding Double in Range
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
                let step: Double? = {
                    switch step {
                    case nil: return nil
                    case let step?: return .init(step)
                    }
                }()

                return value.fixedInRange(min: min, max: max, step: step)
            },
            set: {
                value.wrappedValue = .init($0)
            }
        )
    }
}
