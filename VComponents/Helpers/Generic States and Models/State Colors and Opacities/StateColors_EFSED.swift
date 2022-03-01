//
//  StateColors_EFSED.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Focused, Success, Error, Disabled)
/// Color group containing `enabled`, `focused`, `success`, `error`, and `disabled` values.
public struct StateColors_EFSED: Equatable { // FIXME: Remove
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Focused color.
    public var focused: Color
    
    /// Success color.
    public var success: Color
    
    /// Error color.
    public var error: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        focused: Color,
        success: Color,
        error: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.focused = focused
        self.success = success
        self.error = error
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.focused = .clear
        self.success = .clear
        self.error = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
