//
//  StateColors_EPD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Pressed, Disabled)
/// Color group containing `enabled`, `pressed`, and `disabled` values.
public struct StateColors_EPD: Equatable { // FIXME: Remove
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
    }
    
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.pressed = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
