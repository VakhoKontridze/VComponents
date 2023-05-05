//
//  VGroupBoxUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

// MARK: - V Group Box UI Model
/// Model that describes UI.
public struct VGroupBoxUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Rounded corners. Set to to `allCorners`.
        public var roundedCorners: RectCorner = .allCorners
        
        /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
        public var reversesLeftAndRightCornersForRTLLanguages: Bool = true
        
        /// Corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Content margins. Set to `15`s.
        public var contentMargins: Margins = .init(GlobalUIModel.Common.containerContentMargin)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}

        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
