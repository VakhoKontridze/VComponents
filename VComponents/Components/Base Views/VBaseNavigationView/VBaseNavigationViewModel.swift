//
//  VBaseNavigationViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base Navigation View Model
public struct VBaseNavigationViewModel {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VBaseNavigationViewModel {
    public struct Colors {
        public let background: BackgroundColors
        public let divider: Color
        
        public init(
            background: BackgroundColors = .filled(ColorBook.NavigationView.background),
            divider: Color = .clear
        ) {
            self.background = background
            self.divider = divider
        }
    }
}

extension VBaseNavigationViewModel.Colors {
    public enum BackgroundColors {
        case filled(_ color: Color)
        case transparent
    }
}
