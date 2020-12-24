//
//  VSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Type Aliases
public typealias VSheetRoundAllModel = VSheetModel
public typealias VSheetRoundTopModel = VSheetModel
public typealias VSheetRoundBottomModel = VSheetModel

// MARK:- Sheet View Model
public struct VSheetModel {
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
extension VSheetModel {
    public struct Layout {
        public let radius: CGFloat
        public let contentPadding: CGFloat
        
        public init(
            radius: CGFloat = 15,
            contentPadding: CGFloat = 16
        ) {
            self.radius = radius
            self.contentPadding = contentPadding
        }
    }
}

// MARK:- Colors
extension VSheetModel {
    public struct Colors {
        public let background: Color
        
        public init(
            background: Color = ColorBook.Sheet.background
        ) {
            self.background = background
        }
    }
}
