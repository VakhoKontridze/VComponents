//
//  LayoutDirection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.04.23.
//

import Foundation

nonisolated extension CGSize {
    func dimension(
        isWidth: Bool
    ) -> CGFloat {
        if isWidth {
            width
        } else {
            height
        }
    }
}

nonisolated extension CGPoint {
    func coordinate(
        isX: Bool
    ) -> CGFloat {
        if isX {
            x
        } else {
            y
        }
    }
}

nonisolated extension BinaryFloatingPoint {
    func invertedFromMax(
        _ max: Self,
        if condition: Bool
    ) -> Self {
        if condition {
            max - self
        } else {
            self
        }
    }

    mutating func invertFromMax(
        _ max: Self,
        if condition: Bool
    ) {
        self = self.invertedFromMax(max, if: condition)
    }
}
