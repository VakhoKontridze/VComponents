//
//  VListRowSeparatorType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.08.22.
//

import Foundation

// MARK: - V List Row Separator Type
/// Separator type in `VListRow`, such as `top` or `bottom`.
public struct VListRowSeparatorType: OptionSet {
    // MARK: Properties
    public let rawValue: Int
    
    /// Separator at the top of the row.
    public static var top: Self { .init(rawValue: 1 << 0) }
    
    /// Separator at the bottom of the row.
    public static var bottom: Self { .init(rawValue: 1 << 1) }
    
    /// No separators.
    public static var none: Self { [] }
    
    /// Separator at the top and the bottom of the row.
    ///
    /// Shouldn't be used as standard parameter, since in the non-first, non-last rows,
    /// separators would duplicate and stack in height.
    public static var all: Self { [.top, .bottom] }
    
    /// Default value. Set to `bottom`.
    public static var `default`: Self { .bottom }
    
    /// Configuration that displays separators at the bottom of all rows in the list.
    public static func noFirstSeparator() -> Self {
        .bottom
    }
    
    /// Configuration that displays separators at the top of all rows in the list.
    public static func noLastSeparator() -> Self {
        .top
    }
    
    /// Configuration that displays separators in rows at every position in the list, except for the top and bottom.
    public static func noFirstAndLastSeparators(isFirst: Bool) -> Self {
        if isFirst {
            return .none
        } else {
            return .top
        }
    }
    
    /// Configuration that displays separators at the top and bottom of all rows in the list.
    public static func rowEnclosingSeparators(isFirst: Bool) -> Self {
        if isFirst {
            return .all
        } else {
            return .bottom
        }
    }
    
    // MARK: Initializers
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
