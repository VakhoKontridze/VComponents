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
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextViewUIModel {
    // MARK: Properties - Global
    /// Spacing between header, textview, and footer. Set to `3`.
    public var headerTextViewAndFooterSpacing: CGFloat = 3

    /// Minimum textview height. Set to `50`.
    public var minimumHeight: CGFloat = 50

#if !(os(macOS) || os(watchOS))
    /// Keyboard type. Set to `default`.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type. Set to `nil`.
    public var textContentType: UITextContentType? = nil
#endif

    /// Indicates if auto correction is enabled. Set to `nil`.
    public var isAutocorrectionEnabled: Bool? = nil

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type. Set to `nil`.
    public var autocapitalization: TextInputAutocapitalization? = nil
#endif

    // MARK: Properties - Corners
    /// Textview orner radius. Set to `12`.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.makeDynamic((235, 235, 235, 1), (60, 60, 60, 1)),
        focused: Color.makeDynamic((220, 220, 220, 1), (80, 80, 80, 1)),
        disabled: Color.makeDynamic((245, 245, 245, 1), (50, 50, 50, 1))
    )

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Header
    /// Header title text frame alignment. Set to `leading`.
    public var headerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Header title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    public var headerTitleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .leading, lineLimit: 1...2)
        } else {
            .multiLine(alignment: .leading, lineLimit: 2)
        }
    }()

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Header title text font. Set to `footnote`.
    public var headerTitleTextFont: Font = .footnote

    /// Header footer horizontal margin. Set to `10`.
    public var headerMarginHorizontal: CGFloat = 10

    // MARK: Properties - Footer
    /// Footer title text frame alignment. Set to `leading`.
    public var footerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    public var footerTitleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .leading, lineLimit: 1...5)
        } else {
            .multiLine(alignment: .leading, lineLimit: 5)
        }
    }()

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Footer title text font. Set to `footnote`.
    public var footerTitleTextFont: Font = .footnote

    /// Footer horizontal margin. Set to `10`.
    public var footerMarginHorizontal: CGFloat = 10

    // MARK: Properties - TextView Content
    /// Content margins. Set to `15`s.
    public var contentMargins: Margins = .init(15)

    // MARK: Properties - Text
    /// Text line type. Set to `multiline` with `leading` alignment and no limit on lines.
    public var textLineType: TextLineType = .multiLine(alignment: .leading, lineLimit: nil)

    /// Text colors.
    public var textColors: StateColors = .init(
        enabled: Color.primary,
        focused: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Text font. Set to `body`.
    public var textFont: Font = .body

    // MARK: Properties - Placeholder Text
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(Color.secondary)

    /// Placeholder text font. Set to `body`.
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

// MARK: - Factory (Highlights)
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
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
@available(visionOS, unavailable)
extension VTextViewUIModel {
    /// Applies green color scheme to `VTextViewUIModel`.
    public mutating func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((85, 195, 135, 1), (45, 150, 75, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((85, 175, 135, 1), (85, 195, 135, 1))
        )
    }

    /// Applies yellow color scheme to `VTextViewUIModel`.
    public mutating func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((255, 190, 35, 1), (240, 150, 20, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((235, 170, 35, 1), (255, 190, 35, 1))
        )
    }

    /// Applies red color scheme to `VTextViewUIModel`.
    public mutating func applyErrorColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((235, 110, 105, 1), (215, 60, 55, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((215, 110, 105, 1), (235, 110, 105, 1))
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
