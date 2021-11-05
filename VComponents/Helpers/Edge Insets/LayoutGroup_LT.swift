//
//  LayoutGroup_LT.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - Layout Group (Leading, Trailing)
/// Group of layout values containing `leading` and `trailing` values.
public struct LayoutGroup_LT: Equatable {
    // MARK: Properties
    /// Top value.
    public var leading: CGFloat
    
    /// Bottom value.
    public var trailing: CGFloat
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        leading: CGFloat,
        trailing: CGFloat
    ) {
        self.leading = leading
        self.trailing = trailing
    }
    
    /// Initializes group with zero values.
    public init() {
        self.leading = 0
        self.trailing = 0
    }
    
    /// Initializes group with zero values.
    public static var zero: Self { .init() }
}
