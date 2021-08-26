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
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Colors
extension VNavigationViewModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Background color
        public var bar: Color = ColorBook.layer
        
        /// Navigation bar divider color
        public var divider: Color = ColorBook.clear
        
        /// Initializes sub-model with default values
        public init() {}
    }
}
