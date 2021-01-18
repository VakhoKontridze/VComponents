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
        
        public static let `default`: WidthType = .relative()
        
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
        public var leading: CGFloat = 16
        public var trailing: CGFloat = 16
        public var top: CGFloat = 16
        public var bottom: CGFloat = 16
        
        public init() {}
    }
}

// MARK:- Colors
extension VSideBarModel {
    public struct Colors {
        public static let sheetColor: Color = VSheetModel().color
        public static let modalColors: VModalModel.Colors = .init()
        
        public var background: Color = sheetColor
        public var blinding: Color = modalColors.blinding
        
        public init() {}
    }
}
