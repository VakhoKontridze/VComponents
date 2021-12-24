//
//  StateColors_OOD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Off, On, Disabled)
/// Color group containing `off`, `on`, and `disabled` values.
public struct StateColors_OOD: Equatable {
    // MARK: Properties
    /// Off color.
    public var off: Color
    
    /// On color.
    public var on: Color
    
    /// Off pressed color.
    public var pressedOff: Color
    
    /// On pressed color.
    public var pressedOn: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Color,
        on: Color,
        pressedOff: Color,
        pressedOn: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.pressedOff = pressedOff
        self.pressedOn = pressedOn
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.off = .clear
        self.on = .clear
        self.pressedOff = .clear
        self.pressedOn = .clear
        self.disabled = .clear
    }
}
