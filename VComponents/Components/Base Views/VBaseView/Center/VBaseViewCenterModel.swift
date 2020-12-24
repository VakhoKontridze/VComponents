//
//  VBaseViewCenterModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base View Center Model
public struct VBaseViewCenterModel {
    public let layout: Layout
    public let fonts: Fonts
    
    public init(
        layout: Layout = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.fonts = fonts
    }
}

// MARK:- Layout
extension VBaseViewCenterModel {
    public struct Layout {
        public let margin: CGFloat
        public let spacing: CGFloat
        var width: CGFloat { UIScreen.main.bounds.width - 2 * margin }
        
        public init(
            margin: CGFloat = 20,
            spacing: CGFloat = 10
        ) {
            self.margin = margin
            self.spacing = spacing
        }
    }
}

// MARK:- Fonts
extension VBaseViewCenterModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.navigationBarTitle
        ) {
            self.title = title
        }
    }
}
