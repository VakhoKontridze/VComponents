//
//  VContinuousSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Continuous Spinner UI Model
/// Model that describes UI.
public struct VContinuousSpinnerUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Spinner dimension. Set to `15`.
        public var dimension: CGFloat = 15
        
        /// Length of colored part of spinner. Set to `0.75`.
        public var length: CGFloat = 0.75
        
        /// Thickness. Set to `2`.
        public var thickness: CGFloat = 2
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Spinner color.
        public var spinner: Color = ColorBook.accentBlue
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Spinner animation. Set to `linear` with duration `0.75`.
        public var spinning: Animation = .linear(duration: 0.75)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
