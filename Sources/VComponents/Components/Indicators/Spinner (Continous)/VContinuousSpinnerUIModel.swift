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
        /// Spinner dimension. Set to `25` for `macOS`, `30` for `tvOS`, and `15` for other platforms.
        public var dimension: CGFloat = {
#if os(macOS)
            return 25
#elseif os(tvOS)
            return 30
#else
            return 15
#endif
        }()
        
        /// Length of colored part of spinner. Set to `0.75`.
        public var length: CGFloat = 0.75
        
        /// Thickness. Set to `3` for `macOS`, `4` for `tvOS`, and `2` for other platforms.
        public var thickness: CGFloat = {
#if os(macOS)
            return 3
#elseif os(tvOS)
            return 4
#else
            return 2
#endif
        }()
        
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
