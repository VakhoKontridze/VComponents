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
            width
        } else {
            height
        }
    }
}

extension CGPoint {
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

extension BinaryFloatingPoint {
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
