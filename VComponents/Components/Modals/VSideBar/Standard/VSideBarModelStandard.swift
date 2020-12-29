//
//  VSideBarModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar Model Standard
public struct VSideBarModelStandard {
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
extension VSideBarModelStandard {
    public struct Layout {
        public let width: Width
        let _width: CGFloat
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
            self._width = {
                switch width {
                case .relative(let ratio): return UIScreen.main.bounds.width * ratio
                case .fixed(let width): return width
                }
            }()
            self.roundCorners = roundCorners
            self.cornerRadius = cornerRadius
            self.contentMargin = contentMargin
        }
    }
}

extension VSideBarModelStandard.Layout {
    public enum Width {
        case relative(_ screenRatio: CGFloat = 2/3)
        case fixed(_ width: CGFloat = 300)
    }
}

extension VSideBarModelStandard.Layout {
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
extension VSideBarModelStandard {
    public struct Colors {
        public let background: Color
        public let blinding: Color
        
        public init(
            background: Color = ColorBook.SideBarStandard.background,
            blinding: Color = ColorBook.SideBarStandard.blinding
        ) {
            self.background = background
            self.blinding = blinding
        }
    }
}
