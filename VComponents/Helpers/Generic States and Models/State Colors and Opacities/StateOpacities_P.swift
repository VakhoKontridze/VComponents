//
//  StateOpacities_P.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - State Opacities (Pressed)
/// Opacity level group containing `pressed` values.
public struct StateOpacities_P: Equatable { // FIXME: Remove
    // MARK: Properties
    /// Pressed opacity level.
    public var pressedOpacity: Double

    // MARK: Initializers
    /// Initializes group with values.
    public init(
        pressedOpacity: Double
    ) {
        self.pressedOpacity = pressedOpacity
    }
    
    /// Initializes group with clear values.
    public init() {
        self.pressedOpacity = 0
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
    
    /// Initializes group with solid values.
    public static var solid: Self {
        .init(
            pressedOpacity: 1
        )
    }
}
