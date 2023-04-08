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

// MARK: - V Alert Size
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertUIModel.Layout.AlertSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VAlertUIModel.Layout.AlertSize
    ) -> VAlertUIModel.Layout.AlertSize {
        .init(
            width: MultiplatformConstants.screenSize.width * measurement.width
        )
    }
}

// MARK: - V Bottom Sheet Size
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel.Layout.BottomSheetSize: ScreenRelativeSizeMeasurement {
    public static func relativeMeasurementToPoints(
        _ measurement: VBottomSheetUIModel.Layout.BottomSheetSize
    ) -> VBottomSheetUIModel.Layout.BottomSheetSize {
        .init(
            width: MultiplatformConstants.screenSize.width * measurement.width,
            heights: VBottomSheetUIModel.Layout.BottomSheetHeights(
                min: MultiplatformConstants.screenSize.height * measurement.heights.min,
                ideal: MultiplatformConstants.screenSize.height * measurement.heights.ideal,
                max: MultiplatformConstants.screenSize.height * measurement.heights.max
            )
        )
    }
}
