//
//  VSpinnerType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK: - V Spinner Type
/// Enum that represents `VSpinner` type, such as `continuous` or `dashed`
public struct VSpinnerType {
    // MARK: Properties
    let _spinnerType: _VSpinnerType
    
    // MARK: Initializers
    private init(
        spinnerType: _VSpinnerType
    ) {
        self._spinnerType = spinnerType
    }
    
    /// Continuos spinner.
    public static func continuous(
        uiModel: VSpinnerContinuousUIModel = .init()
    ) -> Self {
        .init(spinnerType: .continuous(
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
    
    /// Default value. Set to `continuous`.
    public static var `default`: Self { .continuous() }
}

// MARK: - _ V Spinner Type
enum _VSpinnerType {
    case continuous(uiModel: VSpinnerContinuousUIModel)
    case dashed(uiModel: VSpinnerDashedUIModel)
}
