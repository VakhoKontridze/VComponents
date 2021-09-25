//
//  VSpinnerModelContinous.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Spinner Model Continous
/// Model that describes UI
public struct VSpinnerModelContinous {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Layout
extension VSpinnerModelContinous {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Spinner dimension. Defaults to `15`.
        public var dimension: CGFloat = 15
        
        /// Length of colored part of spinner. Defaults to `0.75`.
        public var legth: CGFloat = 0.75
        
        /// Spinner thickness. Defaults to `2`.
        public var thickness: CGFloat = 2
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - Colors
extension VSpinnerModelContinous {
    /// Sub-model containing color properties
    public struct Colors {
        /// Spinner color
        public var spinner: Color = ColorBook.accent
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - Animations
extension VSpinnerModelContinous {
    /// Sub-model containing animation properties
    public struct Animations {
        /// Spinner animation. Defaults to `linear` with duration `0.75`.
        public var spinning: Animation = .linear(duration: 0.75)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}
