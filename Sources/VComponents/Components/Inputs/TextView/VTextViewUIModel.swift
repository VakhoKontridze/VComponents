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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public var textContentType: UITextContentType?
#endif

    /// Indicates if auto correction is enabled. Set to `nil`.
    public var isAutocorrectionEnabled: Bool?

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type. Set to `nil`.
    public var autocapitalization: TextInputAutocapitalization?
#endif

    // MARK: Properties - Corners
    /// Textview orner radius. Set to `12`.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.dynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.dynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Border
    /// Border width. Set to `0` points.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Header
    /// Header title text frame alignment. Set to `leading`.
    public var headerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Header title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var headerTitleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Header title text font. Set to `footnote`.
    public var headerTitleTextFont: Font = .footnote

    /// Header title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var headerTitleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    /// Header footer horizontal margin. Set to `10`.
    public var headerMarginHorizontal: CGFloat = 10

    // MARK: Properties - Footer
    /// Footer title text frame alignment. Set to `leading`.
    public var footerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var footerTitleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...5
    )

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Footer title text font. Set to `footnote`.
    public var footerTitleTextFont: Font = .footnote

    /// Footer title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var footerTitleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    /// Footer horizontal margin. Set to `10`.
    public var footerMarginHorizontal: CGFloat = 10

    // MARK: Properties - TextView
    /// Textview content margins. Set to `(15, 15, 15, 15)`.
    public var textViewContentMargins: Margins = .init(15)

    // MARK: Properties - Text
    /// Text line type. Set to `multiline` with `leading` alignment and no limit on lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var textLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: nil
    )

    /// Text colors.
    public var textColors: StateColors = .init(
        enabled: Color.primary,
        focused: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Text font. Set to `body`.
    public var textFont: Font = .body

    /// Text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var textDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextViewUIModel {
    /// `VTextViewUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = PointPixelMeasurement.points(1.5)
        uiModel.applySuccessColorScheme()

        return uiModel
    }

    /// `VTextViewUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = PointPixelMeasurement.points(1.5)
        uiModel.applyWarningColorScheme()

        return uiModel
    }

    /// `VTextViewUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()

        uiModel.borderWidth = PointPixelMeasurement.points(1.5)
        uiModel.applyErrorColorScheme()

        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextViewUIModel {
    /// Applies green color scheme to `VTextViewUIModel`.
    mutating public func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(85, 195, 135), Color(45, 150, 75)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(85, 175, 135), Color(85, 195, 135))
        )
    }

    /// Applies yellow color scheme to `VTextViewUIModel`.
    mutating public func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(255, 190, 35), Color(240, 150, 20)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(235, 170, 35), Color(255, 190, 35))
        )
    }

    /// Applies red color scheme to `VTextViewUIModel`.
    mutating public func applyErrorColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(235, 110, 105), Color(215, 60, 55)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(215, 110, 105), Color(235, 110, 105))
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
