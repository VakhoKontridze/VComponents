//
//  VSheetCustomModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- Sheet View Rounded Model
public struct VSheetRoundCustomModel {
    public let layout: Layout
    public let colors: Colors
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.layout = layout
        self.colors = colors
    }
}

// MARK:- Layout
extension VSheetRoundCustomModel {
    public struct Layout {
        public let corners: UIRectCorner
        public let radius: CGFloat
        public let contentPadding: CGFloat
        
        public init(
            corners: UIRectCorner = .allCorners,
            radius: CGFloat = 15,
            contentPadding: CGFloat = 16
        ) {
            self.corners = corners
            self.radius = radius
            self.contentPadding = contentPadding
        }
    }
}

// MARK:- Colors
extension VSheetRoundCustomModel {
    public struct Colors {
        public let background: Color
        
        public init(
            background: Color = ColorBook.SheetCustom.background
        ) {
            self.background = background
        }
    }
}
