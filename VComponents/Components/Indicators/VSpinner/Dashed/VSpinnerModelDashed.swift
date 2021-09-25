//
//  VSpinnerModelDashed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Spinner Model Dashed
/// Model that describes UI
public struct VSpinnerModelDashed {
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Colors
extension VSpinnerModelDashed {
    /// Sub-model containing color properties
    public struct Colors {
        /// Spinner color
        public var spinner: Color = spinnerContinousReference.colors.spinner
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - References
extension VSpinnerModelDashed {
    /// Reference to `VSpinnerModelContinous`
    public static let spinnerContinousReference: VSpinnerModelContinous = .init()
}
