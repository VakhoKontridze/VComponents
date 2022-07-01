//
//  VStaticListUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.06.22.
//

import SwiftUI
import VCore

// MARK: - V Static List Model
/// Model that describes UI.
public struct VStaticListUIModel {
    // MARK: Properties
    fileprivate static let listReference: VListUIModel = .init()
    
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
        /// Alignment. Defaults to `center`.
        public var alignment: HorizontalAlignment = .center
        
        /// Row margins. Defaults to `15` horizontal, `9` vertical.
        public var rowMargins: Margins = listReference.layout.rowMargins
        
        /// Row separator height. Defaults to `1` scaled to screen.
        ///
        /// To hide separator, set to `0`.
        public var separatorHeight: CGFloat = 1 / UIScreen.main.scale
        
        /// Separator margins. Defaults to `15`s.
        public var separatorMargins: HorizontalMargins = listReference.layout.separatorMargins
        
        /// Indicates if the first row has separator before it. Defaults to `true`.
        public var showsFirstSeparator: Bool = listReference.layout.showsFirstSeparator
        
        /// Indicates if the last row has separator after it. Defaults to `true`.
        public var showsLastSeparator: Bool = listReference.layout.showsLastSeparator
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Horizontal Margins
        /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LTTB
        
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LT
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VListUIModel.Colors
}
