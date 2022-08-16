//
//  VListRowSeparatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.08.22.
//

import SwiftUI
import VCore

// MARK: - V List Row Separator UI Model
/// Model that describes UI.
public struct VListRowSeparatorUIModel {
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
        /// Height. Defaults to `1` scaled to screen.
        public var height: CGFloat = 0.9999 / UIScreen.main.scale
        
        /// Horizontal margins. Defaults to `15`s.
        public var margins: HorizontalMargins = .init(15)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}

        // MARK: Horizontal Margins
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LeadingTrailing
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Color.
        public var separator: Color = .init(componentAsset: "List.Separator")
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
