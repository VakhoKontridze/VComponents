//
//  LayoutGroups.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/9/21.
//

import SwiftUI

/// Grop of layout values containing `leading`, `trailing`, `top` and `bottom` values
public struct LayoutGroup_LTTB {
    /// Leading value
    public var leading: CGFloat
    
    /// Trailing value
    public var trailing: CGFloat
    
    /// Top value
    public var top: CGFloat
    
    /// Bottom value
    public var bottom: CGFloat
    
    /// Initializes group with value
    public init(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) {
        self.leading = leading
        self.trailing = trailing
        self.top = top
        self.bottom = bottom
    }
    
    /// Instance of group with zero values
    public static var zero: Self {
        .init(
            leading: 0,
            trailing: 0,
            top: 0,
            bottom: 0
        )
    }
}

/// Grop of layout values containing `horizotal` and `vertical` values
public struct LayoutGroup_HV {
    /// Horizontal value
    public var horizontal: CGFloat
    
    /// Vertical value
    public var vertical: CGFloat
    
    /// Initializes group with values
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// Instance of group with zero values
    public static var zero: Self {
        .init(
            horizontal: 0,
            vertical: 0
        )
    }
}

/// Grop of layout values containing `top` and `bottom` values
public struct LayoutGroup_TB {
    /// Top value
    public var top: CGFloat
    
    /// Bottom value
    public var bottom: CGFloat
    
    /// Initializes group with values
    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
    
    /// Instance of group with zero values
    public static var zero: Self {
        .init(
            top: 0,
            bottom: 0
        )
    }
}

/// Grop of layout values containing `leading` and `trailing` values
public struct LayoutGroup_LT {
    /// Top value
    public var leading: CGFloat
    
    /// Bottom value
    public var trailing: CGFloat
    
    /// Initializes group with values
    public init(leading: CGFloat, trailing: CGFloat) {
        self.leading = leading
        self.trailing = trailing
    }
    
    /// Instance of group with zero values
    public static var zero: Self {
        .init(
            leading: 0,
            trailing: 0
        )
    }
}
