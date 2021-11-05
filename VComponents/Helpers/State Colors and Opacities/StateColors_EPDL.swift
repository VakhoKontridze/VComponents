//
//  StateColors_EPDL.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Pressed, Disabled, Loading)
/// Color group containing enabled, pressed, disabled, and loading values.
public struct StateColors_EPDL: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    /// Loading color.
    public var loading: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color,
        loading: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.loading = loading
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.pressed = .clear
        self.disabled = .clear
        self.loading = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
