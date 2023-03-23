//
//  VWheelPickerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Wheel Picker UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VWheelPickerUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Picker corner radius. Set to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Header text line type. Set to `singleLine`.
        public var headerTextLineType: TextLineType = GlobalUIModel.Common.headerTextLineType
        
        /// Footer text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTextLineType: TextLineType = GlobalUIModel.Common.footerTextLineType
        
        /// Spacing between header, picker, and footer. Set to `3`.
        public var headerPickerFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerFooterMarginHorizontal
        
        /// Title minimum scale factor. Set to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(ColorBook.layer)
        
        /// Title content colors.
        ///
        /// Only applicable when using `init` with title.
        public var title: StateColors = .init(
            enabled: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom content opacities. Set to `1` enabled and `0.3` disabled.
        ///
        /// Applicable only when `init` with content is used.
        /// When using a custom content, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customContentOpacities: StateOpacities = .init(
            enabled: 1,
            disabled: GlobalUIModel.ItemPickers.customContentOpacityDisabled
        )
        
        /// Header colors.
        public var header: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        /// Footer colors.
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font. Set to`system` `14`.
        public var header: Font = GlobalUIModel.Common.headerFont
        
        /// Footer font. Set to`system` `13`.
        public var footer: Font = GlobalUIModel.Common.footerFont
        
        /// Row font. Set to`system` `medium`-`14`.
        ///
        /// Only applicable when using `init` with title.
        public var rows: Font = .system(size: 14, weight: .medium)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
