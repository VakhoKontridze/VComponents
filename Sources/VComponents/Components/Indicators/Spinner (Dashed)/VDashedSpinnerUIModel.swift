//
//  VDashedSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Dashed Spinner UI Model
/// Model that describes UI.
public struct VDashedSpinnerUIModel {
    // MARK: Properties
    fileprivate static let continuousSpinnerReference: VContinuousSpinnerUIModel = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Spinner color.
        public var spinner: Color = continuousSpinnerReference.colors.spinner
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
}
