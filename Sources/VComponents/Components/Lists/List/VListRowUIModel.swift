//
//  VListUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VCore

// MARK: - V List Row UI Model
/// Model that describes UI.
public struct VListRowUIModel {
    // MARK: Properties
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Margins. Defaults to `15` horizontal, `9` vertical.
        public var margins: Margins = .init(
            horizontal: 15,
            vertical: 9
        )
        
        /// Separator margins. Defaults to `15`s.
        public var separatorMargins: HorizontalMargins = .init(15)
        
        /// Separator height. Defaults to `1` scaled to screen.
        public var separatorHeight: CGFloat = 0.9999 / UIScreen.main.scale
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
        
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LeadingTrailing
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Separator color.
        public var separator: Color = .init(componentAsset: "List.Separator")
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
