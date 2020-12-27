//
//  VNavigationViewFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View Model Standard
public struct VNavigationViewModelFilled {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VNavigationViewModelFilled {
    public struct Colors {
        public let background: Color
        public let divider: Color
        
        public init(
            background: Color = .clear,//ColorBook.NavigationViewFilled.background,
            divider: Color = .clear
        ) {
            self.background = background
            self.divider = divider
        }
    }
}
