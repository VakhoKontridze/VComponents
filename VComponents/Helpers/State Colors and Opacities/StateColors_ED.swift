//
//  StateColors_ED.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - State Colors (Enabled, Disabled)
/// Color group containing `enabled` and `disabled` values.
public struct StateColors_ED: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
