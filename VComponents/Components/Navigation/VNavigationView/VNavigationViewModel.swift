//
//  VNavigationViewFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Navigation View Model
/// Model that describes UI.
public struct VNavigationViewModel {
    // MARK: Properties
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var bar: Color = ColorBook.canvas
        
        /// Navigation bar divider color.
        public var divider: Color = .init(componentAsset: "NavigationView.Divider")
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
