//
//  VBottomSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- V BottomSheet Model
/// Model that describes UI
public struct VBottomSheetModel {
    public static let sideBarModel: VSideBarModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topLeft, .topRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.color = colors.background
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VBottomSheetModel {
    public struct Layout {
        public var heightType: HeightClass = .default
        
        public var cornerRadius: CGFloat = VBottomSheetModel.sideBarModel.layout.cornerRadius
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var contentMargin: ContentMargin = .init()
        public var hasSafeAreaMargin: Bool = true
        
        public var closeButton: Set<CloseButtonType> = [.default]
        
        public init() {}
    }
}

extension VBottomSheetModel.Layout {
    /// Enum that describes height class, such as fixed or resizable
    public enum HeightClass {
        case fixed(_ value: HeightType)
        case resizable(min: HeightType, max: HeightType)
        
        public static let `default`: Self = .fixed(.default)
        
        var isFixed: Bool {
            switch self {
            case .fixed: return true
            case .resizable: return false
            }
        }
        
        var height: CGFloat {
            switch self {
            case .fixed(let type):
                return type.height
                
            case .resizable(let min, let max):
                return -1   // FIXME
            }
        }
    }
    
    /// Enum that describes height type, such as relative or constant
    public enum HeightType {
        case relative(_ value: CGFloat = 2/3)
        case constant(_ value: CGFloat = 500)
        
        public static let `default`: Self = .relative()
        
        var height: CGFloat {
            switch self {
            case .relative(let ratio): return UIScreen.main.bounds.height * ratio
            case .constant(let value): return value
            }
        }
    }
    
    public typealias ContentMargin = VSideBarModel.Layout.ContentMargin
    
    /// Enum that decribes close button type, such as trailing, backtap, or pull down
    public enum CloseButtonType: Int, CaseIterable {
        case trailing
        case backTap
        case pullDown
        
        public static let `default`: Self = .trailing
        
        var exists: Bool {
            switch self {
            case .trailing: return true
            case .backTap: return false
            case .pullDown: return false
            }
        }
    }
}

// MARK:- Colors
extension VBottomSheetModel {
    public struct Colors {
        public var background: Color = VBottomSheetModel.sideBarModel.colors.background
        public var blinding: Color = VBottomSheetModel.sideBarModel.colors.blinding
        
        public init() {}
    }
}

// MARK:- Animations
extension VBottomSheetModel {
    public struct Animations {
        public var curve: UIView.AnimationCurve = VBottomSheetModel.sideBarModel.animations.curve
        public var duration: TimeInterval = VBottomSheetModel.sideBarModel.animations.duration
        
        public init() {}
    }
}
