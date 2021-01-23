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
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundedCorners
        model.layout.cornerRadius = layout.cornerRadius
        
        model.colors.background = colors.background
        
        return model
    }
    
    var closeButtonSubModel: VCloseButtonModel {
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
    /// Enum that describes rounded corners, such as all, top, bottom, custom, or none
    public typealias RoundedCorners = VSheetModel.Layout.RoundedCorners
}

// MARK:- Colors
extension VModalModel {
    public struct Colors {
        static let defaultHeader: Color = ColorBook.primary
        
        public var background: Color = VModalModel.sheetModel.colors.background
        
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

// MARK:- Fonts
extension VModalModel {
    struct Fonts {
        static let header: Font = .system(size: 17, weight: .bold, design: .default)
    }
}

// MARK:- Animations
extension VModalModel {
    public struct Animations {
        public var appear: BasicAnimation? = .init(curve: .linear, duration: 0.05)
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)
        
        public var scaleEffect: CGFloat = 1.01
        public var opacity: Double = 0.5
        public var blur: CGFloat = 3
        
        public init() {}
    }
}

// MARK:- Misc
extension VModalModel {
    public struct Misc {
        public var dismissType: Set<DismissType> = .default
        
        public init() {}
    }
}

extension VModalModel.Misc {
    /// Enum that decribes dismiss type, such as leading button, trailing button, or backtap
    public enum DismissType: Int, CaseIterable {
        case leading
        case trailing
        case backTap
    }
}

extension Set where Element == VModalModel.Misc.DismissType {
    public static let `default`: Self = [.trailing]
    
    var hasButton: Bool {
        contains(where: { [.leading, .trailing].contains($0) })
    }
}
