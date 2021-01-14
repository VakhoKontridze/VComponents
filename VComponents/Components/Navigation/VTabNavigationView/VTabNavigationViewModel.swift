//
//  VTabNavigationViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Model
/// Model that describes UI
public struct VTabNavigationViewModel {
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Colors
extension VTabNavigationViewModel {
    public struct Colors {
        public var background: Color = ColorBook.canvas
        public var item: Color = .init(componentAsset: "TabNavigationView.Item")
        public var itemSelected: Color = ColorBook.accent
        
        public init() {}
    }
}
