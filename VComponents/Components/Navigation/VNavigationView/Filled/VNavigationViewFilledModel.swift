//
//  VNavigationViewFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View Standard Model
public struct VNavigationViewFilledModel {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VNavigationViewFilledModel {
    public struct Colors {
        public let background: Color
        public let divider: Color
        
        public init(
            background: Color = ColorBook.NavigationView.background,
            divider: Color = .clear
        ) {
            self.background = background
            self.divider = divider
        }
    }
}
