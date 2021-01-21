//
//  VSideBarModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar Model
/// Model that describes UI
public struct VSideBarModel {
    public static let sheetModel: VSheetModel = .init()
    public static let modalModel: VModalModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topRight, .bottomRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.color = colors.background
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VSideBarModel {
    public struct Layout {
        public var widthType: WidthType = .default
        
        public var cornerRadius: CGFloat = 20
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var contentMargin: ContentMargin = .init()
        
        public init() {}
    }
}

extension VSideBarModel.Layout {
    public enum WidthType {
        case relative(_ screenRatio: CGFloat = 2/3)
        case fixed(_ width: CGFloat = 300)
        
        public static let `default`: Self = .relative()
        
        var width: CGFloat {
            switch self {
            case .relative(let ratio): return UIScreen.main.bounds.width * ratio
            case .fixed(let width): return width
            }
        }
    }
}

extension VSideBarModel.Layout {
    public struct ContentMargin {
        public var leading: CGFloat = 15
        public var trailing: CGFloat = 15
        public var top: CGFloat = 15
        public var bottom: CGFloat = 15
        
        public init() {}
    }
}

// MARK:- Colors
extension VSideBarModel {
    public struct Colors {
        public var background: Color = VSideBarModel.sheetModel.color
        public var blinding: Color = VSideBarModel.modalModel.colors.blinding
        
        public init() {}
    }
}

// MARK:- Animations
extension VSideBarModel {
    public struct Animations {
        public var curve: UIView.AnimationCurve = .linear
        public var duration: TimeInterval = 0.25
        
        public init() {}
    }
}
