//
//  VDashedSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Dashed Spinner UI Model
/// Model that describes UI.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct VDashedSpinnerUIModel {
    // MARK: Properties
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
        ///
        /// Has no effect on `macOS`.
        public var spinner: Color = ColorBook.accentBlue
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
