//
//  VTextViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI
import VCore

// MARK: - V Text View Appearance
/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextViewAppearance: Sendable {
    // MARK: Properties - Global
    /// Spacing between header, textview, and footer.
    public var headerAndTextViewAndFooterSpacing: CGFloat = 3

    /// Minimum textview height.
    public var minimumHeight: CGFloat = 50

#if !(os(macOS) || os(watchOS))
    /// Keyboard type.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type.
    public var textContentType: UITextContentType?
#endif

    /// Indicates if auto correction is enabled.
    public var isAutocorrectionEnabled: Bool?

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type.
    public var autocapitalization: TextInputAutocapitalization?
#endif

    // MARK: Properties - Corners
    /// Textview orner radius.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.dynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.dynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Header
    /// Header title text frame alignment.
    public var headerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Header title text line type...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var headerTitleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )
    
    /// Header title text minimum scale factor.
    public var headerTitleTextMinimumScaleFactor: CGFloat = 1

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Header title text font.
    public var headerTitleTextFont: Font = .footnote

    /// Header title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var headerTitleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    /// Header footer horizontal margin.
    public var headerMarginHorizontal: CGFloat = 10

    // MARK: Properties - Footer
    /// Footer title text frame alignment.
    public var footerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Footer title text line type...5` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var footerTitleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...5
    )
    
    /// Footer title text minimum scale factor.
    public var footerTitleTextMinimumScaleFactor: CGFloat = 1

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Footer title text font.
    public var footerTitleTextFont: Font = .footnote

    /// Footer title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var footerTitleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    /// Footer horizontal margin.
    public var footerMarginHorizontal: CGFloat = 10

    // MARK: Properties - TextView
    /// Textview content margins.
    public var textViewContentMargins: EdgeInsets = .init(15)

    // MARK: Properties - Text
    /// Text line type.
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

    /// Text font.
    public var textFont: Font = .body

    /// Text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var textDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Placeholder Text
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(Color.secondary)

    /// Placeholder text font.
    public var placeholderTextFont: Font = .body

    // MARK: Properties - Submit Button
    /// Submit button type.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextViewAppearance {
    /// `VTextViewAppearance` that applies green color scheme.
    public static var success: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()

        return appearance
    }

    /// `VTextViewAppearance` that applies yellow color scheme.
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()

        return appearance
    }

    /// `VTextViewAppearance` that applies error color scheme.
    public static var error: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyErrorColorScheme()

        return appearance
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextViewAppearance {
    /// Applies green color scheme to `VTextViewAppearance`.
    mutating public func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(85, 195, 135), Color(45, 150, 75)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(85, 175, 135), Color(85, 195, 135))
        )
    }

    /// Applies yellow color scheme to `VTextViewAppearance`.
    mutating public func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(255, 190, 35), Color(240, 150, 20)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(235, 170, 35), Color(255, 190, 35))
        )
    }

    /// Applies red color scheme to `VTextViewAppearance`.
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
