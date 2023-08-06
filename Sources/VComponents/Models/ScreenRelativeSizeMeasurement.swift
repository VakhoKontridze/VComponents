//
//  ScreenRelativeSizeMeasurement.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import SwiftUI

// MARK: - Screen Relative Size Measurement
/// Measurement that allows screen relative sizes to be converted to points.
public protocol ScreenRelativeSizeMeasurement {
    /// Converts screen relative measurement to points.
    static func relativeMeasurementToPoints(
        _ measurement: Self,
        in screenSize: CGSize
    ) -> Self
}

// MARK: - CGSize
extension CGSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: CGSize,
        in screenSize: CGSize
    ) -> CGSize {
        .init(
            width: screenSize.width * measurement.width,
            height: screenSize.height * measurement.height
        )
    }
}
