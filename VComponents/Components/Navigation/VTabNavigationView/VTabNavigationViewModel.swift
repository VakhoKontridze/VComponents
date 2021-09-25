//
//  VTabNavigationViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Tab Navigation View Model
/// Model that describes UI
public struct VTabNavigationViewModel {
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Colors
extension VTabNavigationViewModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Background color
        public var background: Color = ColorBook.canvas
        
        /// Tab item color
        public var item: Color = .init(componentAsset: "TabNavigationView.Item")
        
        /// Selected tab item color
        public var selectedItem: Color = ColorBook.accent
        
        /// Initializes sub-model with default values
        public init() {}
    }
}
