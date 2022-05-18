//
//  StateColors_EPLD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Pressed, Loading, Disabled)
/// Color group containing enabled, pressed, loading, and disabled values.
public struct StateColors_EPLD: Equatable { // FIXME: Remove
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Loading color.
    public var loading: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        loading: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.loading = loading
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.pressed = .clear
        self.loading = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
