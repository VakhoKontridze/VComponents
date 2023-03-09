//
//  VListUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VCore

// MARK: - V List Row UI Model
/// Model that describes UI.
public struct VListRowUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Margins. Set to `15` horizontal and `9` vertical.
        public var margins: Margins = .init(
            horizontal: GlobalUIModel.Common.containerContentMargin,
            vertical: 9
        )
        
        /// Separator type. Set to `default`.
        public var separatorType: SeparatorType = .default
        
        /// Separator margins. Set to `15`s.
        public var separatorMargins: HorizontalMargins = .init(GlobalUIModel.Common.containerContentMargin)
        
        /// Separator height. Set to `1` scaled to screen.
        public var separatorHeight: CGFloat = GlobalUIModel.Common.separatorHeight
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
        
        // MARK: Horizontal Margins
        /// Model that contains `leading` and `trailing` margins.
        public typealias HorizontalMargins = EdgeInsets_LeadingTrailing
        
        // MARK: Separator Type
        /// Enum that represents separator type, such as `top` or `bottom`.
        public struct SeparatorType: OptionSet {
            // MARK: Options
            /// Separator at the top of the row.
            public static var top: Self { .init(rawValue: 1 << 0) }
            
            /// Separator at the bottom of the row.
            public static var bottom: Self { .init(rawValue: 1 << 1) }
            
            // MARK: Options Initializers
            /// Default value. Set to `bottom`.
            public static var `default`: Self { .bottom }
            
            /// No separators.
            public static var none: Self { [] }
            
            /// Separator at the top and the bottom of the row.
            ///
            /// Shouldn't be used as standard parameter, since in the non-first, non-last rows,
            /// separators would duplicate and stack in height.
            public static var all: Self { [.top, .bottom] }
            
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
                isFirst ? .none : .top
            }
            
            /// Configuration that displays separators at the top and bottom of all rows in the list.
            public static func rowEnclosingSeparators(isFirst: Bool) -> Self {
                isFirst ? .all : .bottom
            }
            
            // MARK: Properties
            public let rawValue: Int
            
            // MARK: Initializers
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }
        }
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Separator color.
        public var separator: Color = GlobalUIModel.Common.separatorColor
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}

// MARK: - Factory
extension VListRowUIModel {
    /// `VListRowUIModel` that displays separators at the bottom of all rows in the list.
    public static func noFirstSeparator() -> Self {
        var uiModel: Self = .init()
        
        uiModel.layout.separatorType = .noFirstSeparator()
        
        return uiModel
    }
    
    /// `VListRowUIModel` that displays separators at the top of all rows in the list.
    public static func noLastSeparator() -> Self {
        var uiModel: Self = .init()
        
        uiModel.layout.separatorType = .noLastSeparator()
        
        return uiModel
    }
    
    /// `VListRowUIModel` that displays separators in rows at every position in the list, except for the top and bottom.
    public static func noFirstAndLastSeparators(isFirst: Bool) -> Self {
        var uiModel: Self = .init()
        
        uiModel.layout.separatorType = .noFirstAndLastSeparators(isFirst: isFirst)
        
        return uiModel
    }
    
    /// `VListRowUIModel` that displays separators at the top and bottom of all rows in the list.
    public static func rowEnclosingSeparators(isFirst: Bool) -> Self {
        var uiModel: Self = .init()
        
        uiModel.layout.separatorType = .noFirstAndLastSeparators(isFirst: isFirst)
        
        return uiModel
    }
}
