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
    
    /// Disabled color.
    public var disabled: Color

    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Color,
        on: Color,
        indeterminate: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.indeterminate = indeterminate
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public init() {
        self.off = .clear
        self.on = .clear
        self.indeterminate = .clear
        self.disabled = .clear
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
}
