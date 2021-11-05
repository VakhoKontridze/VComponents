//
//  LayoutGroups.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/9/21.
//

import SwiftUI

// MARK: - Layout Group (Leading, Trailing, Top, Bottom)
/// Group of layout values containing `leading`, `trailing`, `top` and `bottom` values.
public struct LayoutGroup_LTTB: Equatable {
    // MARK: Properties
    /// Leading value.
    public var leading: CGFloat
    
    /// Trailing value.
    public var trailing: CGFloat
    
    /// Top value.
    public var top: CGFloat
    
    /// Bottom value.
    public var bottom: CGFloat
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        leading: CGFloat,
        trailing: CGFloat,
        top: CGFloat,
        bottom: CGFloat
    ) {
        self.leading = leading
        self.trailing = trailing
        self.top = top
        self.bottom = bottom
    }
    
    /// Initializes group with zero values.
    public init() {
        self.leading = 0
        self.trailing = 0
        self.top = 0
        self.bottom = 0
    }
    
    /// Initializes group with zero values.
    public static var zero: Self { self.init() }
}
