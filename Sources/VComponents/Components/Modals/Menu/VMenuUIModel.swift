//
//  VMenuUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 31.03.23.
//

import SwiftUI
import VCore

// MARK: - V Menu UI Model
/// Model that describes UI.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuUIModel {
    // MARK: Properties
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Label color.
        public var label: StateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            disabled: ColorBook.controlLayerBlueDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
    }
}
