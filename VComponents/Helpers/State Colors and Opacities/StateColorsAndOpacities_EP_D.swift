//
//  StateColorsAndOpacities_EP_D.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - State Colors and Opaciites (Enabled, Disabled + Disabled)
/// Color and opacity level group containing `enabled` and `disabled` values.
public struct StateColorsAndOpacities_EP_D: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Disabled color.
    public var disabled: Color
    
    /// Disabled opacity level.
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        disabled: Color,
        disabledOpacity: Double
    ) {
        self.enabled = enabled
        self.disabled = disabled
        self.disabledOpacity = disabledOpacity
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.disabled = .clear
        self.disabledOpacity = 0
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
