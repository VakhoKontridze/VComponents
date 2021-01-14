//
//  VNavigationViewFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View Model
/// Model that describes UI
public struct VNavigationViewModel {
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Colors
extension VNavigationViewModel {
    public struct Colors {
        public var background: Color = ColorBook.canvas
        public var divider: Color = .clear
        
        public init() {}
    }
}
