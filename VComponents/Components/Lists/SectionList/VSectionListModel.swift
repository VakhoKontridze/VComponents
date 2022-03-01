//
//  VSectionListModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK: - V Section List Model
/// Model that describes UI.
public struct VSectionListModel {
    // MARK: Properties
    /// Reference to `VListModel`.
    public static let listReference: VListModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Table corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = listReference.layout.cornerRadius
        
        /// Content margin. Defaults to `10`.
        public var contentMargin: CGFloat = listReference.layout.contentMargin
        
        /// Spacing between sections. Defaults to `20`.
        public var sectionSpacing: CGFloat = 20
        
        /// Spacing between rows. Defaults to `18`.
        public var rowSpacing: CGFloat = listReference.layout.rowSpacing
        
        /// Header bottom margin. Defaults to `10`.
        public var headerMarginBottom: CGFloat = 10
        
        /// Footer bottom top. Defaults to `10`.
        public var footerMarginTop: CGFloat = 10
        
        /// Row divider height. Defaults to `1`.
        public var dividerHeight: CGFloat = listReference.layout.dividerHeight
        
        /// Divider margins. Defaults to `0` leading and `0` trailing.
        public var dividerMargins: HorizontalMargins = listReference.layout.dividerMargins
        
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Horizontal Margins
        /// Sub-model containing `leading` and `trailing` margins.
        public typealias HorizontalMargins = VBaseListModel.Layout.HorizontalMargins
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Row divider color.
        public var divider: Color = listReference.colors.divider
        
        /// Background color.
        public var background: Color = listReference.colors.background
        
        /// Text header color.
        ///
        /// Only applicable when using init with title.
        public var headerText: Color = ColorBook.secondary
        
        /// Text footer color.
        ///
        /// Only applicable when using init with title.
        public var footerText: Color = ColorBook.secondary
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font.
        ///
        /// Only applicable when using init with title.
        public var header: Font = .system(size: 13)
        
        /// Footer font.
        ///
        /// Only applicable when using init with title.
        public var footer: Font = .system(size: 13)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Sub-Models
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.layout.showIndicator = layout.showIndicator
        
        model.layout.rowSpacing = layout.rowSpacing
        model.layout.dividerHeight = layout.dividerHeight
        model.layout.dividerMargins = layout.dividerMargins
        
        model.colors.divider = colors.divider
        
        return model
    }
    
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
}
