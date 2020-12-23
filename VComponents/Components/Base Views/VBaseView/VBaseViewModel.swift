//
//  VBaseViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base View Model
public struct VBaseViewModel {
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
extension VBaseViewModel {
    public struct Layout {
        public let titleAlignment: TitleAlignment
        public let margin: CGFloat
        public let spacing: CGFloat
        var width: CGFloat { UIScreen.main.bounds.width - 2 * margin }
        
        public init(
            titleAlignment: TitleAlignment = .leading,
            margin: CGFloat = 16,
            spacing: CGFloat = 10
        ) {
            self.titleAlignment = titleAlignment
            self.margin = margin
            self.spacing = spacing
        }
    }
}

extension VBaseViewModel.Layout {
    public enum TitleAlignment {
        case leading
        case center
    }
}

// MARK:- Fonts
extension VBaseViewModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.navigationBarTitle
        ) {
            self.title = title
        }
    }
}
