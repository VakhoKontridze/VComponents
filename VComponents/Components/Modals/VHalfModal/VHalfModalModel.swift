//
//  VHalfModalModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- V Half Modal Model
/// Model that describes UI
public struct VHalfModalModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VHalfModalModel {
    public struct Layout {
        public var height: HeightType = .default
        
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var resizeIndicatorSize: CGSize = .init(width: 50, height: 4)
        var hasResizeIndicator: Bool { resizeIndicatorSize.height > 0 }
        public var resizeIndicatorCornerRadius: CGFloat = 2
        
        public var dividerHeight: CGFloat = 1
        var hasDivider: Bool { dividerHeight > 0 }
        
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        public var resizeIndicatorMargin: VerticalMargins = .init(
            top: sheetReference.layout.contentMargin,
            bottom: sheetReference.layout.contentMargin/2
        )
        
        public var headerMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin/2
        )
    
        public var dividerMargin: Margins = modalReference.layout.dividerMargin
        
        public var contentMargin: Margins = modalReference.layout.contentMargin
        
        public var hasSafeAreaMarginBottom: Bool = true
        var edgesToIgnore: Edge.Set {
            switch hasSafeAreaMarginBottom {
            case false: return .bottom
            case true: return []
            }
        }

        public var headerSpacing: CGFloat = modalReference.layout.headerSpacing
        
        public var translationBelowMinHeightToDismiss: CGFloat = 100
        
        static let navigationViewCloseButtonMarginTop: CGFloat = (UIView.navigationBarHeight - VCloseButtonModel.Layout().dimension) / 2
        static let navigationViewHalfModalCloseButtonMarginTrailing: CGFloat = VCloseButtonModel.Layout().dimension + Self().headerSpacing
        
        public init() {}
    }
}

extension VHalfModalModel.Layout {
    /// Enum that describes height type, such as fixed or dynamic
    public enum HeightType {
        case fixed(_ value: CGFloat)
        case dynamic(min: CGFloat, ideal: CGFloat, max: CGFloat)
        
        public static let `default`: Self = .dynamic(
            min: UIScreen.main.bounds.height * 0.3,
            ideal: UIScreen.main.bounds.height * 0.67,
            max: UIScreen.main.bounds.height * 0.9
        )
        
        var min: CGFloat {
            switch self {
            case .fixed(let value): return value
            case .dynamic(let min, _, _): return min
            }
        }
        
        var ideal: CGFloat {
            switch self {
            case .fixed(let value): return value
            case .dynamic(_, let ideal, _): return ideal
            }
        }
        
        var max: CGFloat {
            switch self {
            case .fixed(let value): return value
            case .dynamic(_, _, let max): return max
            }
        }
        
        var isResizable: Bool {
            switch self {
            case .fixed: return false
            case .dynamic(let min, let ideal, let max): return min != ideal || ideal != max
            }
        }
    }
    
    public typealias Margins = VModalModel.Layout.Margins
    
    public struct VerticalMargins {
        public var top: CGFloat
        public var bottom: CGFloat
        
        public init(top: CGFloat, bottom: CGFloat) {
            self.top = top
            self.bottom = bottom
        }
    }
}

// MARK:- Colors
extension VHalfModalModel {
    public struct Colors {
        public var background: Color = modalReference.colors.background
        
        public var resizeIndicator: Color = closeButtonReference.colors.background.enabled
        
        public var headerText: Color = modalReference.colors.headerText
        
        public var closeButtonBackground: StateColors = modalReference.colors.closeButtonBackground
        public var closeButtonIcon: StateColorsAndOpacities = modalReference.colors.closeButtonIcon
        
        public var divider: Color = accordionReference.colors.headerDivider
        
        public var blinding: Color = modalReference.colors.blinding
        
        public init() {}
    }
}

extension VHalfModalModel.Colors {
    public typealias StateColors = StateColorsEPD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- Fonts
extension VHalfModalModel {
    public struct Fonts {
        public var header: Font = modalReference.fonts.header    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VHalfModalModel {
    public struct Animations {
        public var appear: BasicAnimation? = .init(curve: .linear, duration: 0.2)
        public var disappear: BasicAnimation? = .init(curve: .linear, duration: 0.2)
        
        public var heightSnap: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)
        
        static let dragDisappear: BasicAnimation = .init(curve: .easeIn, duration: 0.1)
        
        public init() {}
    }
}

// MARK:- Misc
extension VHalfModalModel {
    public struct Misc {
        public var dismissType: Set<DismissType> = .default
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        public init() {}
    }
}

extension VHalfModalModel.Misc {
    /// Enum that decribes dismiss type, such as leading button, trailing button, backtap, or pull down
    public enum DismissType: Int, CaseIterable {
        case leading
        case trailing
        case backTap
        case pullDown
        case navigationViewCloseButton
    }
}

extension Set where Element == VHalfModalModel.Misc.DismissType {
    public static let `default`: Self = [.trailing, .pullDown]
    
    var hasButton: Bool {
        contains(where: { [.leading, .trailing].contains($0) })
    }
}

// MARK:- References
extension VHalfModalModel {
    public static let sheetReference: VSheetModel = .init()
    public static let modalReference: VModalModel = .init()
    public static let accordionReference: VAccordionModel = .init()
    public static let closeButtonReference: VCloseButtonModel = .init()
}

// MARK:- Sub-Models
extension VHalfModalModel {
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topLeft, .topRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
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
