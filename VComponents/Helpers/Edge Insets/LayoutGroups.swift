//
//  LayoutGroups.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/9/21.
//

import SwiftUI

// MARK: - Leading, Trailing, Top, Bottom
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

// MARK: - Horiontal, Vertical
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

// MARK: - Top, Bottom
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

// MARK: - Leading, Trailing
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
