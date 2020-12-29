//
//  VTabNavigationViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Model
public struct VTabNavigationViewModel {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VTabNavigationViewModel {
    public struct Colors {
        public let background: Color
        public let item: Color
        public let itemSelected: Color
        
        public init(
            background: Color = ColorBook.canvas,
            item: Color = ColorBook.secondary,
            itemSelected: Color = ColorBook.accent
        ) {
            self.background = background
            self.item = item
            self.itemSelected = itemSelected
        }
    }
}
