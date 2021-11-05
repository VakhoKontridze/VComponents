//
//  StateColors_EFD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Focused, Disabled)
/// Color group containing `enabled`, `focused`, and `disabled` values.
public struct StateColors_EFD: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Focused color.
    public var focused: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        focused: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.focused = focused
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.focused = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init()  }
}
