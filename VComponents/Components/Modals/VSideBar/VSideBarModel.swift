//
//  VSideBarModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar Model
public struct VSideBarModel {
    public let layout: Layout
    public let colors: Colors
    let sheetModel: VSheetModel
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.layout = layout
        self.colors = colors
        self.sheetModel = .init(
            layout: .init(
                roundedCorners: layout.roundCorners ? .custom([.topRight, .bottomRight]) : .none,
                cornerRadius: layout.cornerRadius,
                contentPadding: 0
            ),
            color: colors.background
        )
    }
}

// MARK:- Layout
extension VSideBarModel {
    public struct Layout {
        public let width: Width
        public let roundCorners: Bool
        public let cornerRadius: CGFloat
        public let contentMargin: ContentMargin
        
        public init(
            width: Width = .relative(),
            roundCorners: Bool = true,
            cornerRadius: CGFloat = 20,
            contentMargin: ContentMargin = .init()
        ) {
            self.width = width
            self.roundCorners = roundCorners
            self.cornerRadius = cornerRadius
            self.contentMargin = contentMargin
        }
    }
}

extension VSideBarModel.Layout {
    public enum Width {
        case relative(_ screenRatio: CGFloat = 2/3)
        case fixed(_ width: CGFloat = 300)
        
        var value: CGFloat {
            switch self {
            case .relative(let ratio): return UIScreen.main.bounds.width * ratio
            case .fixed(let width): return width
            }
        }
    }
}

extension VSideBarModel.Layout {
    public struct ContentMargin {
        public let leading: CGFloat
        public let trailing: CGFloat
        public let top: CGFloat
        public let bottom: CGFloat
        
        public init(
            leading: CGFloat = 20,
            trailing: CGFloat = 20,
            top: CGFloat = 20,
            bottom: CGFloat = 20
        ) {
            self.leading = leading
            self.trailing = trailing
            self.top = top
            self.bottom = bottom
        }
    }
}

// MARK:- Colors
extension VSideBarModel {
    public struct Colors {
        public static let sheetColor: Color = VSheetModel().color
        
        public let background: Color
        public let blinding: Color
        
        public init(
            background: Color = sheetColor,
            blinding: Color = .init(componentAsset: "SideBar.Blinding")
        ) {
            self.background = background
            self.blinding = blinding
        }
    }
}
