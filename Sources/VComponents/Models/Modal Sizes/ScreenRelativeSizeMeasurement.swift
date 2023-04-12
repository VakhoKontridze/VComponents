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
    static func relativeMeasurementToPoints(_ measurement: Self) -> Self
}

// MARK: - CGSize
extension CGSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: CGSize
    ) -> CGSize {
        .init(
            width: MultiplatformConstants.screenSize.width * measurement.width,
            height: MultiplatformConstants.screenSize.height * measurement.height
        )
    }
}
