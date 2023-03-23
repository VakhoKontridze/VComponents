//
//  VTextViewUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI
import VCore

// MARK: - V Text View UI Model
/// Model that describes UI.
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VTextViewUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains misc properties.
    public var misc: Misc = .init()
    
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Textfield min height. Set to `50`.
        public var minHeight: CGFloat = GlobalUIModel.Inputs.height
        
        /// Textfield corner radius. Set to `12`.
        public var cornerRadius: CGFloat = GlobalUIModel.Inputs.cornerRadius

        /// Text line type. Set to `multiline` with `leading` alignment and no limit on lines.
        public var textLineType: TextLineType = .multiLine(alignment: .leading, lineLimit: nil)

        /// Border width. Set to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0

        /// Content margin. Set to `15`s.
        public var contentMargin: Margins = .init(GlobalUIModel.Common.containerContentMargin)

        /// Header text line type. Set to `singleLine`.
        public var headerTextLineType: TextLineType = GlobalUIModel.Common.headerTextLineType
        
        /// Footer text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTextLineType: TextLineType = GlobalUIModel.Common.footerTextLineType
        
        /// Spacing between header, textview, and footer. Set to `3`.
        public var headerTextViewFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerFooterMarginHorizontal
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.layerGray,
            focused: GlobalUIModel.Inputs.backgroundColorFocused,
            disabled: ColorBook.layerGrayDisabled
        )

        /// Border colors.
        public var border: StateColors = .clearColors

        /// Text colors.
        public var text: StateColors = .init(
            enabled: ColorBook.primary,
            focused: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Placeholder colors.
        public var placeholder: StateColors = .init(ColorBook.primaryPressedDisabled)

        /// Header colors.
        public var header: StateColors = .init(
            enabled: ColorBook.secondary,
            focused: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )

        /// Footer colors.
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            focused: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public typealias Fonts = VTextFieldUIModel.Fonts

    // MARK: Misc
    /// Model that contains misc properties.
    public typealias Misc = VTextFieldUIModel.Misc
}

// MARK: - Factory
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel {
    /// `VTextViewUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        uiModel.colors = .success
        
        return uiModel
    }

    /// `VTextViewUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        
        uiModel.colors = .warning
        
        return uiModel
    }

    /// `VTextViewUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        
        uiModel.colors = .error
        
        return uiModel
    }
}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel.Colors {
    /// `VTextViewUIModel.Colors` that applies green color scheme.
    public static var success: Self {
        .createHighlightedColors(
            background: ColorBook.layerGreen,
            foreground: ColorBook.borderGreen
        )
    }

    /// `VTextViewUIModel.Colors` that applies yellow color scheme.
    public static var warning: Self {
        .createHighlightedColors(
            background: ColorBook.layerYellow,
            foreground: ColorBook.borderYellow
        )
    }

    /// `VTextViewUIModel.Colors` that applies error color scheme.
    public static var error: Self {
        .createHighlightedColors(
            background: ColorBook.layerRed,
            foreground: ColorBook.borderRed
        )
    }
    
    private static func createHighlightedColors(
        background: Color,
        foreground: Color
    ) -> Self {
        var colors: Self = .init()
        
        colors.background.enabled = background
        colors.background.focused = background
        
        colors.border.enabled = foreground
        colors.border.focused = foreground
        
        colors.header.enabled = foreground
        colors.header.focused = foreground
        
        colors.footer.enabled = foreground
        colors.footer.focused = foreground
        
        return colors
    }
}
