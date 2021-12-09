//
//  SliderHelpers.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - Number Fixed in Range
extension Double {
    func fixedInRange(
        min: Double,
        max: Double,
        step: Double?
    ) -> Double {
        switch (self, step) {
        case (...min, _): return min
        case (max..., _): return max
        case (_, nil): return self
        case (_, let step?): return self.roundWithStep(min: min, max: max, step: step)
        }
    }
    
    private func roundWithStep(
        min: Double,
        max: Double,
        step: Double
    ) -> Double {
        let rawValue: Double = {
            let low: Double = floor(self / step) * step
            let high: Double = ceil(self / step) * step
            
            let lowDiff: Double = abs(self - low)
            let highDiff: Double = abs(self - high)
            
            return highDiff > lowDiff ? low : high
        }()
        
        switch rawValue {
        case ...min: return min
        case max...: return max
        case _: return rawValue
        }
    }
}

// MARK: - Normalization Binding Double in Range
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
