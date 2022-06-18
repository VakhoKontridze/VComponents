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
            width: UIScreen.main.bounds.size.width * measurement.width,
            height: UIScreen.main.bounds.size.height * measurement.height
        )
    }
}

// MARK: - V Alert Size
extension VAlertUIModel.Layout.AlertSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VAlertUIModel.Layout.AlertSize
    ) -> VAlertUIModel.Layout.AlertSize {
        .init(
            width: UIScreen.main.bounds.size.width * measurement.width
        )
    }
}

// MARK: - V Bottom Sheet Size
extension VBottomSheetUIModel.Layout.BottomSheetSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VBottomSheetUIModel.Layout.BottomSheetSize
    ) -> VBottomSheetUIModel.Layout.BottomSheetSize {
        .init(
            width: UIScreen.main.bounds.size.width * measurement.width,
            heights: .init(
                min: UIScreen.main.bounds.size.height * measurement.heights.min,
                ideal: UIScreen.main.bounds.size.height * measurement.heights.ideal,
                max: UIScreen.main.bounds.size.height * measurement.heights.max
            )
        )
    }
}
