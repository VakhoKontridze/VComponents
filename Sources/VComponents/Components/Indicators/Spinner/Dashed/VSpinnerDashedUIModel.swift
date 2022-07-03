//
//  VSpinnerDashedUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Spinner Dashed UI Model
/// Model that describes UI.
public struct VSpinnerDashedUIModel {
    // MARK: Properties
    fileprivate static let spinnerContinuousReference: VSpinnerContinuousUIModel = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Spinner color.
        public var spinner: Color = spinnerContinuousReference.colors.spinner
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
