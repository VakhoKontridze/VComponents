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

extension Double {
    func invertedFromMax(
        _ max: Double,
        if condition: Bool
    ) -> Double {
        if condition {
            return max - self
        } else {
            return self
        }
    }
}
