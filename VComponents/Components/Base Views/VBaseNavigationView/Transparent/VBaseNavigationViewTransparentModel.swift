//
//  VBaseNavigationViewTransparentModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base Navigation View Transparent Model
public struct VBaseNavigationViewTransparentModel {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VBaseNavigationViewTransparentModel {
    public struct Colors {
        public let divider: Color
        
        public init(
            divider: Color = .clear
        ) {
            self.divider = divider
        }
    }
}
