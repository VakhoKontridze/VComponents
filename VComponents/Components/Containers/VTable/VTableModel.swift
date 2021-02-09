//
//  VTableModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Model
/// Model that describes UI
public struct VTableModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VTableModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Table corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = sectionReference.layout.cornerRadius
        
        /// Content margin. Defaults to `15`.
        public var contentMargin: CGFloat = sectionReference.layout.contentMargin
        
        /// Spacing between sections. Defaults to `20`.
        public var sectionSpacing: CGFloat = 20
        
        /// Spacing between rows. Defaults to `18`.
        public var rowSpacing: CGFloat = sectionReference.layout.rowSpacing
        
        /// Header bottom margin. Defaults to `10`.
        public var headerMarginBottom: CGFloat = 10
        
        /// Footer bottom top. Defaults to `10`.
        public var footerMarginTop: CGFloat = 10
        
        /// Row divider height. Defaults to `1`.
        public var dividerHeight: CGFloat = sectionReference.layout.dividerHeight
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VTableModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Row divider color
        public var divider: Color = sectionReference.colors.divider
        
        /// Background color
        public var background: Color = sectionReference.colors.background
        
        /// Text header color
        ///
        /// Only applicable when using init with title
        public var headerText: Color = ColorBook.secondary
        
        /// Text footer color
        ///
        /// Only applicable when using init with title
        public var footerText: Color = ColorBook.secondary
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Fonts
extension VTableModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Header font
        ///
        /// Only applicable when using init with title
        public var header: Font = .system(size: 13)
        
        /// Footer font
        ///
        /// Only applicable when using init with title
        public var footer: Font = .system(size: 13)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VTableModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VTableModel {
    /// Reference to `VSectionModel`
    public static let sectionReference: VSectionModel = .init()
}

// MARK:- Sub-Models
extension VTableModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.rowSpacing = layout.rowSpacing
        model.layout.dividerHeight = layout.dividerHeight
        
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
