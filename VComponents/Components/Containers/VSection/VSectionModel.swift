//
//  VSectionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section Model
/// Model that describes UI
public struct VSectionModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VSectionModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Section corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = sheetReference.layout.cornerRadius
        
        /// Content margin. Defaults to `15`.
        public var contentMargin: CGFloat = sheetReference.layout.contentMargin
        
        /// Spacing between rows. Defaults to `18`.
        public var rowSpacing: CGFloat = baseListReference.layout.rowSpacing
        
        /// Row divider height. Defaults to `1`.
        public var dividerHeight: CGFloat = baseListReference.layout.dividerHeight
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VSectionModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Row divider color
        public var divider: Color = baseListReference.colors.divider
        
        /// Background color
        public var background: Color = sheetReference.colors.background
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VSectionModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VSectionModel {
    /// Reference to VBaseListModel
    public static let baseListReference: VBaseListModel = .init()
    
    /// Reference to VSheetModel
    public static let sheetReference: VSheetModel = .init()
}

// MARK:- Sub-Models
extension VSectionModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.marginTrailing = layout.contentMargin
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
