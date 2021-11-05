//
//  StateOpacities_PD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Opaities (Pressed, Disabled)
/// Opacity level group containing `pressed` and `disabled` values.
public struct StateOpacities_PD: Equatable {
    // MARK: Properties
    /// Pressed opacity level.
    public var pressedOpacity: Double
    
    /// Disabled opacity level.
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        pressedOpacity: Double,
        disabledOpacity: Double
    ) {
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
    
    /// Initializes group with clear values.
    public init() {
        self.pressedOpacity = 0
        self.disabledOpacity = 0
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
    
    /// Initializes group with solid values.
    public static var solid: Self {
        .init(
            pressedOpacity: 1,
            disabledOpacity: 1
        )
    }
}
