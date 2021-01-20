//
//  VModalModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Modal Model
/// Model that describes UI
public struct VModalModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    static let defaultHeaderFont: Font = .system(size: 17, weight: .bold, design: .default)
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundedCorners
        model.layout.cornerRadius = layout.cornerRadius
        
        model.color = colors.background
        
        return model
    }
    
    var closeButtonModel: VCloseButtonModel {
        var model: VCloseButtonModel = .init()
        
        model.layout.dimension = layout.closeButtonDimension
        model.layout.iconDimension = layout.closeButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = colors.closeButtonBackground
        model.colors.content = colors.closeButtonIcon
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VModalModel {
    public struct Layout {
        public static let closeButtonLayout: VCloseButtonModel.Layout = .init()
        public static let sheetLayout: VSheetModel.Layout = .init()
        
        public var size: CGSize = .init(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.height * 0.6
        )
        
        public var roundedCorners: VSheetModel.Layout.RoundedCorners = sheetLayout.roundedCorners
        public var cornerRadius: CGFloat = sheetLayout.cornerRadius
        public var margin: CGFloat = sheetLayout.contentMargin

        public var closeButtonPosition: VModalCloseButtonPosition = .default
        public var closeButtonDimension: CGFloat = closeButtonLayout.dimension
        public var closeButtonIconDimension: CGFloat = closeButtonLayout.iconDimension
        
        public var dividerHeight: CGFloat = 0
        var hasDivider: Bool { dividerHeight > 0 }
        
        public var headerSpacing: CGFloat = 10
        public var spacing: CGFloat = 10
        
        public init() {}
    }
}

extension VModalModel.Layout {
    public enum VModalCloseButtonPosition: Int, CaseIterable {
        case none
        case leading
        case trailing
        case backTap
        
        public static let `default`: Self = .trailing
        
        var exists: Bool {
            switch self {
            case .none: return false
            case .leading: return true
            case .trailing: return true
            case .backTap: return false
            }
        }
    }
}

// MARK:- Colors
extension VModalModel {
    public struct Colors {
        public static let sheetColor: Color = VSheetModel().color
        public static let closeButtonColors: VCloseButtonModel.Colors = .init()
        
        static let defaultHeader: Color = ColorBook.primary
        
        public var background: Color = sheetColor
        
        public var closeButtonBackground: StateColors = closeButtonColors.background
        public var closeButtonIcon: StateColorsAndOpacity = closeButtonColors.content
        
        public var divider: Color = .clear
        
        public var blinding: Color = .init(componentAsset: "Modal.Blinding")
        
        public init() {}
    }
}

extension VModalModel.Colors {
    public typealias StateColors = VCloseButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VCloseButtonModel.Colors.StateColorsAndOpacity
}
