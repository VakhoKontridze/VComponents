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

        /// Row title text minimum scale factor. Set to `0.75`.
        public var rowTitleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Header title text line type. Set to `singleLine`.
        public var headerTitleTextLineType: TextLineType = GlobalUIModel.Common.headerTitleTextLineType
        
        /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTitleTextLineType: TextLineType = GlobalUIModel.Common.footerTitleTextLineType
        
        /// Spacing between header, picker, and footer. Set to `3`.
        public var headerPickerAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerAndFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal
        
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
        
        /// Row title content colors.
        public var rowTitleText: StateColors = .init(
            enabled: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Header title text colors.
        public var headerTitleText: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        /// Footer title text colors.
        public var footerTitleText: StateColors = .init(
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
        /// Row title text font. Set to `body` (`17`).
        public var rowTitleText: Font = .body
        
        /// Header title text font. Set to `footnote` (`13`).
        public var headerTitleText: Font = GlobalUIModel.Common.headerTitleTextFont
        
        /// Footer title text font. Set to `footnote` (`13`).
        public var footerTitleText: Font = GlobalUIModel.Common.footerTitleTextFont
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
