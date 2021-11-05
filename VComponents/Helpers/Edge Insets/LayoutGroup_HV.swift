//
//  LayoutGroup_HV.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - Layout Group (Horiontal, Vertical)
/// Group of layout values containing `horizotal` and `vertical` values.
public struct LayoutGroup_HV: Equatable {
    // MARK: Properties
    /// Horizontal value.
    public var horizontal: CGFloat
    
    /// Vertical value.
    public var vertical: CGFloat
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        horizontal: CGFloat,
        vertical: CGFloat
    ) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// Initializes group with zero values.
    public init() {
        self.horizontal = 0
        self.vertical = 0
    }
    
    /// Initializes group with zero values.
    public static var zero: Self { .init()  }
}
