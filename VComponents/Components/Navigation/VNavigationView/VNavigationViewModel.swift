//
//  VNavigationViewFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View Model
public struct VNavigationViewModel {
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Colors
extension VNavigationViewModel {
    public struct Colors {
        public let background: Color = ColorBook.canvas
        public let divider: Color = .clear
        
        public init() {}
    }
}
