//
//  MarqueeDurationType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.02.24.
//

import SwiftUI

/// Marquee duration type.
nonisolated public enum MarqueeDurationType: Equatable, Sendable {
    // MARK: Cases
    /// Duration.
    case duration(Double)

    /// Velocity, that calculates duration based on the width of the content.
    case velocity(CGFloat)

    // MARK: Properties
    func toDuration(width: CGFloat) -> Double {
        switch self {
        case .velocity(let velocity):
            if velocity == 0 {
                0
            } else {
                width / velocity
            }
        
        case .duration(let duration):
            duration
        }
    }

    // MARK: Initializers
    /// Default value.
    public static var `default`: Self { .velocity(20) }
}
