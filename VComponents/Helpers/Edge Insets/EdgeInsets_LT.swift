//
//  EdgeInsets_LT.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - Edge Insets (Top, Bottom)
/// Edge insets containing `top` and `bottom` values.
public struct EdgeInsets_TB: Equatable {
    // MARK: Properties
    /// Top inset value.
    public var top: CGFloat
    
    /// Bottom inset  value.
    public var bottom: CGFloat
    
    // MARK: Initializers
    /// Initializes insets with values.
    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
    
    /// Initializes insets with value.
    public init(
        _ value: CGFloat
    ) {
        self.top = value
        self.bottom = value
    }
    
    /// Initializes insets with zero values.
    public init() {
        self.top = 0
        self.bottom = 0
    }
    
    /// Initializes insets with zero values.
    public static var zero: Self { .init() }
    
    // MARK: Inseting
    /// Insets `EdgeInsets` by a given value.
    public func insetBy(inset: CGFloat) -> EdgeInsets_TB {
        .init(
            top: top + inset,
            bottom: bottom + inset
        )
    }
    
    /// Insets `EdgeInsets` by a given top and bottom values.
    public func insetBy(top topInset: CGFloat, bottom bottomInset: CGFloat) -> EdgeInsets_TB {
        .init(
            top: top + topInset,
            bottom: bottom + topInset
        )
    }
    
    /// Insets `EdgeInsets` by a given top value.
    public func insetBy(top topInset: CGFloat) -> EdgeInsets_TB {
        .init(
            top: top + topInset,
            bottom: bottom
        )
    }
    
    /// Insets `EdgeInsets` by a given bottom value.
    public func insetBy(bottom bottomInset: CGFloat) -> EdgeInsets_TB {
        .init(
            top: top,
            bottom: bottom + bottomInset
        )
    }
    
    // MARK: Operators
    /// Adds two `EdgeInsets` by adding up individual edge insets.
    public static func + (lhs: EdgeInsets_TB, rhs: EdgeInsets_TB) -> EdgeInsets_TB {
        .init(
            top: lhs.top + rhs.top,
            bottom: lhs.bottom + rhs.bottom
        )
    }
    
    /// Adds right `EdgeInsets` to the left one by adding individual edge insets.
    public static func += (lhs: inout EdgeInsets_TB, rhs: EdgeInsets_TB) {
        lhs.top += rhs.top
        lhs.bottom += rhs.bottom
    }
    
    /// Subtracts two `EdgeInsets` by subtracting up individual edge insets.
    public static func - (lhs: EdgeInsets_TB, rhs: EdgeInsets_TB) -> EdgeInsets_TB {
        .init(
            top: lhs.top - rhs.top,
            bottom: lhs.bottom - rhs.bottom
        )
    }
    
    /// Subtracts right `EdgeInsets` to the left one by subtracting individual edge insets.
    public static func -= (lhs: inout EdgeInsets_TB, rhs: EdgeInsets_TB) {
        lhs.top -= rhs.top
        lhs.bottom -= rhs.bottom
    }
}
