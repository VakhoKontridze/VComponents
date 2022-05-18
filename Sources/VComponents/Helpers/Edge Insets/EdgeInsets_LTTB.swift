//
//  EdgeInsetss.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/9/21.
//

import SwiftUI

// MARK: - Edge Insets (Leading, Trailing, Top, Bottom)
/// Edge insets containing `leading`, `trailing`, `top` and `bottom` values.
public struct EdgeInsets_LTTB: Equatable {
    // MARK: Properties
    /// Leading inset value.
    public var leading: CGFloat
    
    /// Trailing inset value.
    public var trailing: CGFloat
    
    /// Top inset value.
    public var top: CGFloat
    
    /// Bottom inset value.
    public var bottom: CGFloat
    
    /// Horizontal inset value, that's a sum of `leading` and `trailing` values.
    public var horizontal: CGFloat { leading + trailing }
    
    /// Vertical inset value, that's a sum of `top` and `bottom` values.
    public var vertical: CGFloat { top + bottom }
    
    // MARK: Initializers
    /// Initializes insets with values.
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
    
    /// Initializes insets with value.
    public init(
        _ value: CGFloat
    ) {
        self.leading = value
        self.trailing = value
        self.top = value
        self.bottom = value
    }
    
    /// Initializes insets with horizontal and vertical values.
    public init(
        horizontal: CGFloat,
        vertical: CGFloat
    ) {
        self.leading = horizontal
        self.trailing = horizontal
        self.top = vertical
        self.bottom = vertical
    }
    
    /// Initializes insets with zero values.
    public init() {
        self.leading = 0
        self.trailing = 0
        self.top = 0
        self.bottom = 0
    }
    
    /// Initializes insets with zero values.
    public static var zero: Self { .init() }
    
    // MARK: Inseting
    /// Insets `EdgeInsets` by a given value.
    public func insetBy(inset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading + inset,
            trailing: trailing + inset,
            top: top + inset,
            bottom: bottom + inset
        )
    }
    
    /// Insets `EdgeInsets` by a given horizontal and vertical values.
    public func insetBy(horizontal horizontalInset: CGFloat, vertical verticalInset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading + horizontalInset,
            trailing: trailing + horizontalInset,
            top: top + verticalInset,
            bottom: bottom + verticalInset
        )
    }
    
    /// Insets `EdgeInsets` by a given leading value.
    public func insetBy(leading leadingInset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading + leadingInset,
            trailing: trailing,
            top: top,
            bottom: bottom
        )
    }
    
    /// Insets `EdgeInsets` by a given trailing value.
    public func insetBy(trailing trailingInset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading,
            trailing: trailing + trailingInset,
            top: top,
            bottom: bottom
        )
    }
    
    /// Insets `EdgeInsets` by a given top value.
    public func insetBy(top topInset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading,
            trailing: trailing,
            top: top + topInset,
            bottom: bottom
        )
    }
    
    /// Insets `EdgeInsets` by a given bottom value.
    public func insetBy(bottom bottomInset: CGFloat) -> EdgeInsets_LTTB {
        .init(
            leading: leading,
            trailing: trailing,
            top: top,
            bottom: bottom + bottomInset
        )
    }
    
    // MARK: Operators
    /// Adds two `EdgeInsets` by adding up individual edge insets.
    public static func + (lhs: EdgeInsets_LTTB, rhs: EdgeInsets_LTTB) -> EdgeInsets_LTTB {
        .init(
            leading: lhs.leading + rhs.leading,
            trailing: lhs.trailing + rhs.trailing,
            top: lhs.top + rhs.top,
            bottom: lhs.bottom + rhs.bottom
        )
    }
    
    /// Adds right `EdgeInsets` to the left one by adding individual edge insets.
    public static func += (lhs: inout EdgeInsets_LTTB, rhs: EdgeInsets_LTTB) {
        lhs.leading += rhs.leading
        lhs.trailing += rhs.trailing
        lhs.top += rhs.top
        lhs.bottom += rhs.bottom
    }
    
    /// Subtracts two `EdgeInsets` by subtracting up individual edge insets.
    public static func - (lhs: EdgeInsets_LTTB, rhs: EdgeInsets_LTTB) -> EdgeInsets_LTTB {
        .init(
            leading: lhs.leading - rhs.leading,
            trailing: lhs.trailing - rhs.trailing,
            top: lhs.top - rhs.top,
            bottom: lhs.bottom - rhs.bottom
        )
    }
    
    /// Subtracts right `EdgeInsets` to the left one by subtracting individual edge insets.
    public static func -= (lhs: inout EdgeInsets_LTTB, rhs: EdgeInsets_LTTB) {
        lhs.leading -= rhs.leading
        lhs.trailing -= rhs.trailing
        lhs.top -= rhs.top
        lhs.bottom -= rhs.bottom
    }
}
