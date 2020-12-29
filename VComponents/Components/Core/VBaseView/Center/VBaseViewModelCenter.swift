//
//  VBaseViewModelCenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base View Model Center
public struct VBaseViewModelCenter {
    public let layout: Layout
    public let font: Font
    
    public init(
        layout: Layout = .init(),
        font: Font = .system(size: 17, weight: .semibold, design: .default)
    ) {
        self.layout = layout
        self.font = font
    }
}

// MARK:- Layout
extension VBaseViewModelCenter {
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
