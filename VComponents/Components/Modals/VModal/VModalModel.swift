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
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VModalModel {
    public struct Layout {
        public var size: CGSize = .init(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.height * 0.6
        )
        
        public var roundedCorners: RoundedCorners = sheetReference.layout.roundedCorners
        public var cornerRadius: CGFloat = sheetReference.layout.cornerRadius
        
        public var dividerHeight: CGFloat = 0
        var hasDivider: Bool { dividerHeight > 0 }

        public var closeButtonDimension: CGFloat = closeButtonReference.layout.dimension
        public var closeButtonIconDimension: CGFloat = closeButtonReference.layout.iconDimension
        
        public var headerMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin,
            bottom: sheetReference.layout.contentMargin/2
        )
    
        public var dividerMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin/2
        )
        
        public var contentMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin
        )
        
        public var headerSpacing: CGFloat = 10
        
        public init() {}
    }
}

extension VModalModel.Layout {
    /// Enum that describes rounded corners, such as all, top, bottom, custom, or none
    public typealias RoundedCorners = VSheetModel.Layout.RoundedCorners
    
    public struct Margins {
        public var leading: CGFloat
        public var trailing: CGFloat
        public var top: CGFloat
        public var bottom: CGFloat
        
        public init(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) {
            self.leading = leading
            self.trailing = trailing
            self.top = top
            self.bottom = bottom
        }
    }
}

// MARK:- Colors
extension VModalModel {
    public struct Colors {
        public var background: Color = sheetReference.colors.background
        
        public var headerText: Color = ColorBook.primary    // Only applicable during init with title
        
        public var closeButtonBackground: StateColors = closeButtonReference.colors.background
        public var closeButtonIcon: StateColorsAndOpacity = closeButtonReference.colors.content
        
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
    public struct Fonts {
        public var header: Font = .system(size: 17, weight: .bold, design: .default)    // Only applicable during init with title
        
        public init() {}
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
        public var keyboardIgnoredSafeAreas: Edge.Set = []
        
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

// MARK:- References
extension VModalModel {
    public static let closeButtonReference: VCloseButtonModel = .init()
    public static let sheetReference: VSheetModel = .init()
}

// MARK:- Sub-Models
extension VModalModel {
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
}
