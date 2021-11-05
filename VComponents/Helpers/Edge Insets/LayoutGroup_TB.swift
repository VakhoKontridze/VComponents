//
//  LayoutGroup_TB.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - Layout Group (Top, Bottom)
/// Group of layout values containing `top` and `bottom` values.
public struct LayoutGroup_TB: Equatable {
    // MARK: Properties
    /// Top value.
    public var top: CGFloat
    
    /// Bottom value.
    public var bottom: CGFloat
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        top: CGFloat,
        bottom: CGFloat
    ) {
        self.top = top
        self.bottom = bottom
    }
    
    /// Initializes group with zero values.
    public init() {
        self.top = 0
        self.bottom = 0
    }
    
    /// Initializes group with zero values.
    public static var zero: Self { .init() }
}
