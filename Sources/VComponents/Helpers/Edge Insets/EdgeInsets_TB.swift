//
//  EdgeInsets_TB.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 11/5/21.
//

import SwiftUI

// MARK: - Edge Insets (Leading, Trailing)
/// Edge insets containing `leading` and `trailing` values.
public struct EdgeInsets_LT: Equatable {
    // MARK: Properties
    /// Leading inset value.
    public var leading: CGFloat
    
    /// Trailing inset value.
    public var trailing: CGFloat
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(leading: CGFloat, trailing: CGFloat) {
        self.leading = leading
        self.trailing = trailing
    }
    
    /// Initializes insets with value.
    public init(
        _ value: CGFloat
    ) {
        self.leading = value
        self.trailing = value
    }
    
    /// Initializes insets with zero values.
    public init() {
        self.leading = 0
        self.trailing = 0
    }
    
    /// Initializes insets with zero values.
    public static var zero: Self { .init() }
    
    // MARK: Inseting
    /// Insets `EdgeInsets` by a given value.
    public func insetBy(inset: CGFloat) -> EdgeInsets_LT {
        .init(
            leading: leading + inset,
            trailing: trailing + inset
        )
    }
    
    /// Insets `EdgeInsets` by a given leading and trailing values.
    public func insetBy(leading leadingInset: CGFloat, trailing trailingInset: CGFloat) -> EdgeInsets_LT {
        .init(
            leading: leading + leadingInset,
            trailing: trailing + leadingInset
        )
    }
    
    /// Insets `EdgeInsets` by a given leading value.
    public func insetBy(leading leadingInset: CGFloat) -> EdgeInsets_LT {
        .init(
            leading: leading + leadingInset,
            trailing: trailing
        )
    }
    
    /// Insets `EdgeInsets` by a given trailing value.
    public func insetBy(trailing trailingInset: CGFloat) -> EdgeInsets_LT {
        .init(
            leading: leading,
            trailing: trailing + trailingInset
        )
    }
    
    // MARK: Operators
    /// Adds two `EdgeInsets` by adding up individual edge insets.
    public static func + (lhs: EdgeInsets_LT, rhs: EdgeInsets_LT) -> EdgeInsets_LT {
        .init(
            leading: lhs.leading + rhs.leading,
            trailing: lhs.trailing + rhs.trailing
        )
    }
    
    /// Adds right `EdgeInsets` to the left one by adding individual edge insets.
    public static func += (lhs: inout EdgeInsets_LT, rhs: EdgeInsets_LT) {
        lhs.leading += rhs.leading
        lhs.trailing += rhs.trailing
    }
    
    /// Subtracts two `EdgeInsets` by subtracting up individual edge insets.
    public static func - (lhs: EdgeInsets_LT, rhs: EdgeInsets_LT) -> EdgeInsets_LT {
        .init(
            leading: lhs.leading - rhs.leading,
            trailing: lhs.trailing - rhs.trailing
        )
    }
    
    /// Subtracts right `EdgeInsets` to the left one by subtracting individual edge insets.
    public static func -= (lhs: inout EdgeInsets_LT, rhs: EdgeInsets_LT) {
        lhs.leading -= rhs.leading
        lhs.trailing -= rhs.trailing
    }
}
