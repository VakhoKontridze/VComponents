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
    public static let sheetModel: VSheetModel = .init()
    public static let modalModel: VModalModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    public var dismissType: Set<DismissType> = .default
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topLeft, .topRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.color = colors.background
        
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

extension VHalfModalModel {
    /// Enum that decribes dismiss type, such as leading button, trailing button, backtap, or pull down
    public enum DismissType: Int, CaseIterable {
        case leading
        case trailing
        case backTap
        case pullDown
        case navigationViewCloseButton
    }
}

extension Set where Element == VHalfModalModel.DismissType {
    public static let `default`: Self = [.trailing, .pullDown]
    
    var hasButton: Bool {
        contains(where: { [.leading, .trailing].contains($0) })
    }
}

// MARK:- Layout
extension VHalfModalModel {
    public struct Layout {
        public var height: HeightType = .default
        
        public var cornerRadius: CGFloat = VHalfModalModel.modalModel.layout.cornerRadius
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var contentMargin: ContentMargin = .init()
        public var hasSafeAreaMargin: Bool = true
        
        public var closeButtonDimension: CGFloat = VHalfModalModel.modalModel.layout.closeButtonDimension
        public var closeButtonIconDimension: CGFloat = VHalfModalModel.modalModel.layout.closeButtonIconDimension

        public var dividerHeight: CGFloat = 0
        var hasDivider: Bool { dividerHeight > 0 }

        public var headerSpacing: CGFloat = VHalfModalModel.modalModel.layout.headerSpacing
        public var spacing: CGFloat = VHalfModalModel.modalModel.layout.spacing
        
        public var translationBelowMinHeightToDismiss: CGFloat = 100
        
        static let navigationViewCloseButtonMarginTop: CGFloat = (UIView.navigationBarHeight - VCloseButtonModel.Layout().dimension) / 2
        static let navigationViewHalfModalCloseButtonMarginTrailing: CGFloat = VCloseButtonModel.Layout().dimension + Self().spacing
        
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
    }
    
    public struct ContentMargin {
        public var leading: CGFloat = VHalfModalModel.sheetModel.layout.contentMargin
        public var trailing: CGFloat = VHalfModalModel.sheetModel.layout.contentMargin
        public var top: CGFloat = VHalfModalModel.sheetModel.layout.contentMargin
        public var bottom: CGFloat = VHalfModalModel.sheetModel.layout.contentMargin
        
        public init() {}
    }
}

// MARK:- Colors
extension VHalfModalModel {
    public struct Colors {
        static let defaultHeader: Color = VModalModel.Colors.defaultHeader
        
        public var background: Color = VHalfModalModel.modalModel.colors.background
        
        public var closeButtonBackground: StateColors = VHalfModalModel.modalModel.colors.closeButtonBackground
        public var closeButtonIcon: StateColorsAndOpacity = VHalfModalModel.modalModel.colors.closeButtonIcon
        
        public var divider: Color = VHalfModalModel.modalModel.colors.divider
        
        public var blinding: Color = VHalfModalModel.modalModel.colors.blinding
        
        public init() {}
    }
}

extension VHalfModalModel.Colors {
    public typealias StateColors = VCloseButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VCloseButtonModel.Colors.StateColorsAndOpacity
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
