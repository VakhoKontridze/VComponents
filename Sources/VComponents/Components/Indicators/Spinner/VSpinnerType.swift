//
//  VSpinnerType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK: - V Spinner Type
/// Enum that describes `VSpinner` type, such as `continous` or `dashed`
public struct VSpinnerType {
    // MARK: Properties
    let _spinnerType: _VSpinnerType
    
    // MARK: Initializers
    private init(
        spinnerType: _VSpinnerType
    ) {
        self._spinnerType = spinnerType
    }
    
    /// Continos spinner.
    public static func continous(
        uiModel: VSpinnerContinousUIModel = .init()
    ) -> Self {
        .init(spinnerType: .continous(
            uiModel: uiModel
        ))
    }
    
    /// Dashed spinner.
    public static func dashed(
        uiModel: VSpinnerDashedUIModel = .init()
    ) -> Self {
        .init(spinnerType: .dashed(
            uiModel: uiModel
        ))
    }
    
    /// Default value. Set to `continous`.
    public static var `default`: Self { .continous() }
}

// MARK: - _ V Spinner Type
enum _VSpinnerType {
    case continous(uiModel: VSpinnerContinousUIModel)
    case dashed(uiModel: VSpinnerDashedUIModel)
}
