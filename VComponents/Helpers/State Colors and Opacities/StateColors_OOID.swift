//
//  StateColors_OOID.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Colors (Off, On, Indeterminate, Disabled)
/// Color group containing `off`, `on`, `indeterminate`, and `disabled` values.
public struct StateColors_OOID: Equatable {
    // MARK: Properties
    /// Off color.
    public var off: Color
    
    /// On color.
    public var on: Color
    
    /// Indeterminate color.
    public var indeterminate: Color
    
    /// Off pressed color.
    public var pressedOff: Color
    
    /// On pressed color.
    public var pressedOn: Color
    
    /// Indeterminate pressed color.
    public var pressedIndeterminate: Color
    
    /// Disabled color.
    public var disabled: Color

    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Color,
        on: Color,
        indeterminate: Color,
        pressedOff: Color,
        pressedOn: Color,
        pressedIndeterminate: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.indeterminate = indeterminate
        self.pressedOff = pressedOff
        self.pressedOn = pressedOn
        self.pressedIndeterminate = pressedIndeterminate
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.off = .clear
        self.on = .clear
        self.indeterminate = .clear
        self.pressedOff = .clear
        self.pressedOn = .clear
        self.pressedIndeterminate = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
