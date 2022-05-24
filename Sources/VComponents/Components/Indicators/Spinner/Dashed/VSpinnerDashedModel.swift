//
//  VSpinnerDashedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Spinner Dashed Model
/// Model that describes UI.
public struct VSpinnerDashedModel {
    // MARK: Properties
    fileprivate static let spinnerContinousReference: VSpinnerContinousModel = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Spinner color.
        public var spinner: Color = spinnerContinousReference.colors.spinner
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
