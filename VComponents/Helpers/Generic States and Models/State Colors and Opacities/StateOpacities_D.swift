//
//  StateOpacities_D.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - State Opacities (Disabled)
/// Opacity level group containing `disabled` values.
public struct StateOpacities_D: Equatable { // FIXME: Remove
    // MARK: Properties
    /// Disabled opacity level.
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        disabledOpacity: Double
    ) {
        self.disabledOpacity = disabledOpacity
    }
    
    /// Initializes group with clear values.
    public init() {
        self.disabledOpacity = 0
    }
    
    /// Initializes group with clear values.
    public static var clear: Self { .init() }
    
    /// Initializes group with solid values.
    public static var solid: Self {
        .init(
            disabledOpacity: 1
        )
    }
}
