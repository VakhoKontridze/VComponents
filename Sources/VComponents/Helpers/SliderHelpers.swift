//
//  SliderHelpers.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

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
