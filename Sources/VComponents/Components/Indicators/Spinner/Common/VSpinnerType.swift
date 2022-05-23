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
        model: VSpinnerModelContinous = .init()
    ) -> Self {
        .init(spinnerType: .continous(
            model: model
        ))
    }
    
    /// Dashed spinner.
    public static func dashed(
        model: VSpinnerModelDashed = .init()
    ) -> Self {
        .init(spinnerType: .dashed(
            model: model
        ))
    }
    
    /// Default value. Set to `continous`.
    public static var `default`: Self { .continous() }
}

// MARK: - _ V Spinner Type
enum _VSpinnerType {
    case continous(model: VSpinnerModelContinous)
    case dashed(model: VSpinnerModelDashed)
}
