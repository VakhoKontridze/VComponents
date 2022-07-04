//
//  VListUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VCore

// MARK: - V Base List UI Model
/// Model that describes UI.
public struct VListUIModel {
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
        /// Row margins. Defaults to `15` horizontal, `9` vertical.
        public var rowMargins: Margins = .init(
            horizontal: 15,
            vertical: 9
        )
        
        /// Row separator height. Defaults to `1` scaled to screen.
        ///
        /// To hide separator, set to `0`.
        public var separatorHeight: CGFloat = 0.9999 / UIScreen.main.scale
        
        /// Separator margins. Defaults to `15`s.
        public var separatorMargins: HorizontalMargins = .init(15)
        
        /// Indicates if the first row has separator before it. Defaults to `true`.
        public var showsFirstSeparator: Bool = true
        
        /// Indicates if the last row has separator after it. Defaults to `true`.
        public var showsLastSeparator: Bool = true
        
        /// Indicates if scroll view has scroll indicator. Defaults to `true`.
        public var showsIndicator: Bool = true
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LTTB
        
        // MARK: Horizontal Margins
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LeadingTrailing
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Row background color.
        public var rowBackground: Color = ColorBook.layer
        
        /// Separator color.
        public var separator: Color = .init(componentAsset: "List.Separator")
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
