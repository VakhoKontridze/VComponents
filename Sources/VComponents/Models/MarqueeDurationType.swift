//
//  MarqueeDurationType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.02.24.
//

import CoreGraphics

// MARK: Marquee Duration Type
/// Enumeration that represents animation duration, such as `duration` or `velocity`.
public enum MarqueeDurationType {
    // MARK: Cases
    /// Duration.
    case duration(Double)

    /// Velocity, that calculates duration based on the width of the content.
    case velocity(CGFloat)

    // MARK: Properties
    func toDuration(width: CGFloat) -> Double {
        switch self {
        case .velocity(let velocity): width / velocity
        case .duration(let duration): duration
        }
    }

    // MARK: Initializers
    /// Default value. Set to `velocity` of `20`.
    public static var `default`: Self { .velocity(20) }
}
