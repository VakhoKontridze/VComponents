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
    public static let closeButtonModel: VCloseButtonModel = .init()
    public static let sheetModel: VSheetModel = .init()
    
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
        public var size: CGSize = .init(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.height * 0.6
        )
        
        public var roundedCorners: RoundedCorners = VModalModel.sheetModel.layout.roundedCorners
        public var cornerRadius: CGFloat = VModalModel.sheetModel.layout.cornerRadius
        public var margin: CGFloat = VModalModel.sheetModel.layout.contentMargin

        public var closeButton: Set<VModalCloseButton> = [.default]
        public var closeButtonDimension: CGFloat = VModalModel.closeButtonModel.layout.dimension
        public var closeButtonIconDimension: CGFloat = VModalModel.closeButtonModel.layout.iconDimension
        
        public var dividerHeight: CGFloat = 0
        var hasDivider: Bool { dividerHeight > 0 }
        
        public var headerSpacing: CGFloat = 10
        public var spacing: CGFloat = 10
        
        public init() {}
    }
}

extension VModalModel.Layout {
    public typealias RoundedCorners = VSheetModel.Layout.RoundedCorners
    
    public enum VModalCloseButton: Int, CaseIterable {
        case leading
        case trailing
        case backTap
        
        public static let `default`: Self = .trailing
        
        var exists: Bool {
            switch self {
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
        static let defaultHeader: Color = ColorBook.primary
        
        public var background: Color = VModalModel.sheetModel.color
        
        public var closeButtonBackground: StateColors = VModalModel.closeButtonModel.colors.background
        public var closeButtonIcon: StateColorsAndOpacity = VModalModel.closeButtonModel.colors.content
        
        public var divider: Color = .clear
        
        public var blinding: Color = .init(componentAsset: "Modal.Blinding")
        
        public init() {}
    }
}

extension VModalModel.Colors {
    public typealias StateColors = VCloseButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VCloseButtonModel.Colors.StateColorsAndOpacity
}
