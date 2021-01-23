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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSideBarModel {
    public struct Layout {
        public var width: CGFloat = UIScreen.main.bounds.width * 0.67
        
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var contentMargin: ContentMargin = .init()
        public var hasSafeAreaMarginTop: Bool = true
        public var hasSafeAreaMarginBottom: Bool = true
        var edgesToIgnore: Edge.Set {
            switch (hasSafeAreaMarginTop, hasSafeAreaMarginBottom) {
            case (false, false): return [.top, .bottom]
            case (false, true): return .top
            case (true, false): return .bottom
            case (true, true): return []
            }
        }
        
        public var translationToDismiss: CGFloat = 100
        
        public init() {}
    }
}

extension VSideBarModel.Layout {
    public typealias ContentMargin = VHalfModalModel.Layout.ContentMargin
}

// MARK:- Colors
extension VSideBarModel {
    public struct Colors {
        public var background: Color = modalReference.colors.background
        public var blinding: Color = modalReference.colors.blinding
        
        public init() {}
    }
}

// MARK:- Animations
extension VSideBarModel {
    public struct Animations {
        public var appear: BasicAnimation? = halfModalReference.animations.appear
        public var disappear: BasicAnimation? = halfModalReference.animations.disappear
        
        public init() {}
    }
}

// MARK:- References
extension VSideBarModel {
    public static let modalReference: VModalModel = .init()
    public static let halfModalReference: VHalfModalModel = .init()
}

// MARK:- Sub-Models
extension VSideBarModel {
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topRight, .bottomRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
}
