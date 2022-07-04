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
        
        /// Spacing between rows. Defaults to `18`.
        public var rowSpacing: CGFloat = listReference.layout.rowSpacing
        
        var rowPaddingVertical: CGFloat { listReference.layout.rowPaddingVertical }
        
        /// Row separator height. Defaults to `1` scaled to screen.
        ///
        /// To hide separator, set to `0`.
        public var separatorHeight: CGFloat = 1 / UIScreen.main.scale
        
        /// Row separator margins. Defaults to `zero`.
        public var separatorMargins: HorizontalMargins = listReference.layout.separatorMargins
        
        /// Indicates if the first row has separator before it. Defaults to `true`.
        public var showsFirstSeparator: Bool = listReference.layout.showsFirstSeparator
        
        /// Indicates if the last row has separator after it. Defaults to `true`.
        public var showsLastSeparator: Bool = listReference.layout.showsLastSeparator
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Horizontal Margins
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LeadingTrailing
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VListUIModel.Colors
}
