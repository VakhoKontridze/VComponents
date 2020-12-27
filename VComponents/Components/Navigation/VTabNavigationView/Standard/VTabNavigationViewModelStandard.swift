//
//  VTabNavigationViewModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Model Standard
public struct VTabNavigationViewModelStandard {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VTabNavigationViewModelStandard {
    public struct Colors {
        public let background: Color
        public let item: Color
        public let itemSelected: Color
        
        public init(
            background: Color = ColorBook.TabNavigationViewStandard.background,
            item: Color = ColorBook.TabNavigationViewStandard.item,
            itemSelected: Color = ColorBook.TabNavigationViewStandard.itemSelected
        ) {
            self.background = background
            self.item = item
            self.itemSelected = itemSelected
        }
    }
}
