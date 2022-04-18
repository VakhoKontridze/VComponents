//
//  VSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Sheet Model
/// Model that describes UI.
public struct VSheetModel {
    // MARK: Properties
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Rounded corners. Defaults to to `allCorners`.
        public var roundedCorners: UIRectCorner = .allCorners
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Content margin. Defaults to `10`.
        public var contentMargin: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
