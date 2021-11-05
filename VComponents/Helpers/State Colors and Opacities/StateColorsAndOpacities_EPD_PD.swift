//
//  StateColorsAndOpacities_EPD_PD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors and Opaciites (Enabled, Pressed, Disabled + Pressed, Disabled)
/// Color and opacity level group containing `enabled`, `pressed`, and `disabled` values.
public struct StateColorsAndOpacities_EPD_PD: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    /// Pressed opacity level.
    public var pressedOpacity: Double
    
    /// Disabled opacity level.
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color,
        pressedOpacity: Double,
        disabledOpacity: Double
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
    
    /// Initializes group with clear values.
    public init() {
        self.enabled = .clear
        self.pressed = .clear
        self.disabled = .clear
        self.pressedOpacity = 0
        self.disabledOpacity = 0
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
