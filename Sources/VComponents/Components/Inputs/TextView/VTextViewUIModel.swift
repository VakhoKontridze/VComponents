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
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VTextViewUIModel {
    // MARK: Properties - Global Layout
    /// Textview minimum height. Set to `50`.
    public var minHeight: CGFloat = GlobalUIModel.Inputs.height

    /// Spacing between header, textview, and footer. Set to `3`.
    public var headerTextViewAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing

#if os(iOS)
    /// Keyboard type. Set to `default`.
    public var keyboardType: UIKeyboardType = .default
#endif

#if os(iOS)
    /// Text content type. Set to `nil`.
    public var textContentType: UITextContentType? = nil
#endif

    /// Auto correct type. Set to `nil`.
    public var autocorrection: Bool? = nil

#if os(iOS)
    /// Auto capitalization type. Set to `nil`.
    public var autocapitalization: TextInputAutocapitalization? = nil
#endif

    // MARK: Properties - Corners
    /// Textview orner radius. Set to `12`.
    public var cornerRadius: CGFloat = GlobalUIModel.Inputs.cornerRadius

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: ColorBook.layerGray,
        focused: GlobalUIModel.Inputs.layerGrayColorFocused,
        disabled: ColorBook.layerGrayDisabled
    )

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Header
    /// Header title text line type. Set to `singleLine`.
    public var headerTitleTextLineType: TextLineType = GlobalUIModel.Common.headerTitleTextLineType

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: ColorBook.secondary,
        focused: ColorBook.secondary,
        disabled: ColorBook.secondaryPressedDisabled
    )

    /// Header title text font. Set to `footnote` (`13`).
    public var headerTitleTextFont: Font = GlobalUIModel.Common.headerTitleTextFont

    /// Header footer horizontal margin. Set to `10`.
    public var headerMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal

    // MARK: Properties - Footer
    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    public var footerTitleTextLineType: TextLineType = GlobalUIModel.Common.footerTitleTextLineType

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: ColorBook.secondary,
        focused: ColorBook.secondary,
        disabled: ColorBook.secondaryPressedDisabled
    )

    /// Footer title text font. Set to `footnote` (`13`).
    public var footerTitleTextFont: Font = GlobalUIModel.Common.footerTitleTextFont

    /// Footer horizontal margin. Set to `10`.
    public var footerMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal

    // MARK: Properties - TextView Content
    /// Content margins. Set to `15`s.
    public var contentMargins: Margins = .init(GlobalUIModel.Common.containerContentMargin)

    // MARK: Properties - Text
    /// Text line type. Set to `multiline` with `leading` alignment and no limit on lines.
    public var textLineType: TextLineType = .multiLine(alignment: .leading, lineLimit: nil)

    /// Text colors.
    public var textColors: StateColors = .init(
        enabled: ColorBook.primary,
        focused: ColorBook.primary,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Text font. Set to `body` (`17`).
    public var textFont: Font = .body

    // MARK: Properties - Placeholder
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(ColorBook.primaryPressedDisabled)

    /// Placeholder text font. Set to `body` (`17`).
    public var placeholderTextFont: Font = .body

    // MARK: Properties - Submit Button
    /// Submit button type. Set to `return`.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top` and `bottom` and margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
}

// MARK: - Factory
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel {
    /// `VTextViewUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = 1.5
        uiModel.applySuccessColorScheme()

        return uiModel
    }

    /// `VTextViewUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = 1.5
        uiModel.applyWarningColorScheme()

        return uiModel
    }

    /// `VTextViewUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = 1.5
        uiModel.applyErrorColorScheme()

        return uiModel
    }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel {
    /// Applies green color scheme to `VTextViewUIModel`.
    public mutating func applySuccessColorScheme() {
        applyHighlightedColors(
            border: ColorBook.borderGreen,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextGreenColor
        )
    }

    /// Applies yellow color scheme to `VTextViewUIModel`.
    public mutating func applyWarningColorScheme() {
        applyHighlightedColors(
            border: ColorBook.borderYellow,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextYellowColor
        )
    }

    /// Applies red color scheme to `VTextViewUIModel`.
    public mutating func applyErrorColorScheme() {
        applyHighlightedColors(
            border: ColorBook.borderRed,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextRedColor
        )
    }

    private mutating func applyHighlightedColors(
        border: Color,
        headerTitleTextAndFooterTitleText: Color
    ) {
        borderColors.enabled = border
        borderColors.focused = border

        headerTitleTextColors.enabled = headerTitleTextAndFooterTitleText
        headerTitleTextColors.focused = headerTitleTextAndFooterTitleText

        footerTitleTextColors.enabled = headerTitleTextAndFooterTitleText
        footerTitleTextColors.focused = headerTitleTextAndFooterTitleText
    }
}
