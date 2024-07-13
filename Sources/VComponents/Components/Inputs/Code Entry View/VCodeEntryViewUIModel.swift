//
//  VCodeEntryViewUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.09.23.
//

import SwiftUI
import VCore

// MARK: - V Code Entry View
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VCodeEntryViewUIModel {
    // MARK: Properties - Global
    /// Code length. Set to `6`.
    public var length: Int = 6

    /// Spacing type. Set to `default.`
    public var spacingType: SpacingType = .default

#if !(os(macOS) || os(watchOS))
    /// Keyboard type. Set to `default`.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type. Set to `oneTimeCode`.
    public var textContentType: UITextContentType? = .oneTimeCode
#endif

    /// Indicates if auto correction is enabled. Set to `false`.
    public var isAutocorrectionEnabled: Bool? = false

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type. Set to `never`.
    public var autocapitalization: TextInputAutocapitalization? = .never
#endif

    // MARK: Properties - Background
    /// Character background rectangle size. Set to `(40, 40)`.
    public var characterBackgroundSize: CGSize = .init(dimension: 40)

    /// Character background colors.
    public var characterBackgroundColors: StateColors = .init(
        enabled: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.dynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.dynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Corners
    /// Character background corner radius. Set to `5`.
    public var characterBackgroundCornerRadius: CGFloat = 5

    // MARK: Properties - Border
    /// Character background border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var characterBackgroundBorderWidth: CGFloat = 0

    /// Character background border colors.
    public var characterBackgroundBorderColors: StateColors = .clearColors

    // MARK: Properties - Text
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

    /// Placeholder text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var placeholderTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Submit Button
    /// Submit button type. Set to `return`.
    public var submitButton: SubmitLabel = .return

    /// Indicates if first responder is resigned when the last character is entered. Set to `true`.
    public var submitsWhenLastCharacterIsEntered: Bool = true

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    // MARK: Spacing Type
    /// Enumeration that represents spacing type between the characters.
    @CaseDetection(accessLevelModifier: .internal)
    public enum SpacingType {
        // MARK: Cases
        /// Fixed spacing.
        case fixed(spacing: CGFloat)

        /// Stretched spacing.
        case stretched

        // MARK: Initializers
        /// Default value. Set to `fixed` with spacing of `7`.
        public static var `default`: Self { .fixed(spacing: 7) }
    }
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VCodeEntryViewUIModel {
    /// `VCodeEntryViewUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()

        uiModel.characterBackgroundBorderWidth = 1.5
        uiModel.applySuccessColorScheme()

        return uiModel
    }

    /// `VCodeEntryViewUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()

        uiModel.characterBackgroundBorderWidth = 1.5
        uiModel.applyWarningColorScheme()

        return uiModel
    }

    /// `VCodeEntryViewUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()

        uiModel.characterBackgroundBorderWidth = 1.5
        uiModel.applyErrorColorScheme()

        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VCodeEntryViewUIModel {
    /// Applies green color scheme to `VCodeEntryViewUIModel`.
    mutating public func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(85, 195, 135), Color(45, 150, 75))
        )
    }

    /// Applies yellow color scheme to `VCodeEntryViewUIModel`.
    mutating public func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(255, 190, 35), Color(240, 150, 20))
        )
    }

    /// Applies red color scheme to `VCodeEntryViewUIModel`.
    mutating public func applyErrorColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(235, 110, 105), Color(215, 60, 55))
        )
    }

    private mutating func applyHighlightedColors(
        border: Color
    ) {
        characterBackgroundBorderColors.enabled = border
        characterBackgroundBorderColors.focused = border
    }
}
