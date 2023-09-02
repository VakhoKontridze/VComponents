//
//  LayoutDirectionHelpers.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.04.23.
//

import Foundation

// MARK: - Layout Directions Helpers
extension CGSize {
    func dimension(
        isWidth: Bool
    ) -> CGFloat {
        if isWidth {
            return width
        } else {
            return height
        }
    }
}

extension CGPoint {
    func coordinate(
        isX: Bool
    ) -> CGFloat {
        if isX {
            return x
        } else {
            return y
        }
    }
}

extension BinaryFloatingPoint {
    func invertedFromMax(
        _ max: Self,
        if condition: Bool
    ) -> Self {
        if condition {
            return max - self
        } else {
            return self
        }
    }

    mutating func invertFromMax(
        _ max: Self,
        if condition: Bool
    ) {
        self = self.invertedFromMax(max, if: condition)
    }
}
