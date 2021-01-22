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
    public static let modalModel: VModalModel = .init()
    public static let halfModalModel: VHalfModalModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    var sheetSubModel: VSheetModel {
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
        public var width: CGFloat = UIScreen.main.bounds.width * 0.67
        
        public var cornerRadius: CGFloat = VSideBarModel.modalModel.layout.cornerRadius
        var roundCorners: Bool { cornerRadius > 0 }
        
        public var contentMargin: ContentMargin = .init()
        
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
        public var background: Color = VSideBarModel.modalModel.colors.background
        public var blinding: Color = VSideBarModel.modalModel.colors.blinding
        
        public init() {}
    }
}

// MARK:- Animations
extension VSideBarModel {
    public struct Animations {
        public var appear: BasicAnimation? = VSideBarModel.halfModalModel.animations.appear
        public var disappear: BasicAnimation? = VSideBarModel.halfModalModel.animations.disappear
        
        public init() {}
    }
}
