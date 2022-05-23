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

// MARK: - V Dialog Size
extension VDialogModel.Layout.DialogSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VDialogModel.Layout.DialogSize
    ) -> VDialogModel.Layout.DialogSize {
        .init(
            width: UIScreen.main.bounds.size.width * measurement.width
        )
    }
}

// MARK: - V Bottom Sheet Size
extension VBottomSheetModel.Layout.BottomSheetSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VBottomSheetModel.Layout.BottomSheetSize
    ) -> VBottomSheetModel.Layout.BottomSheetSize {
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
