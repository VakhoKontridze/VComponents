//
//  VCodeEntryViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.09.23.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VCodeEntryViewAppearance {
    // MARK: Properties - Global
    /// Code length.
    public var length: Int = 6

    /// Spacing type.
    public var spacingType: SpacingType = .default
    
    // MARK: Properties - Code Entry
#if !(os(macOS) || os(watchOS))
    /// Keyboard type.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type.
    public var textContentType: UITextContentType? = .oneTimeCode
#endif

    /// Indicates if auto correction is enabled.
    public var isAutocorrectionEnabled: Bool? = false

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type.
    public var autocapitalization: TextInputAutocapitalization? = .never
#endif
    
    /// Submit button type.
    public var submitButton: SubmitLabel = .return

    /// Indicates if first responder is resigned when the last character is entered.
    public var submitsWhenLastCharacterIsEntered: Bool = true

    // MARK: Properties - Background
    /// Character background rectangle size.
    public var characterBackgroundSize: CGSize = .init(dimension: 40)

    /// Character background colors.
    public var characterBackgroundColors: StateColors = .init(
        enabled: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.dynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.dynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Corners
    /// Character background corner radius.
    public var characterBackgroundCornerRadius: CGFloat = 5

    // MARK: Properties - Border
    /// Character background border width.
    ///
    /// To hide border, set to `0`.
    public var characterBackgroundBorderWidth: PointPixelMeasurement = .points(0)

    /// Character background border colors.
    public var characterBackgroundBorderColors: StateColors = .clearColors

    // MARK: Properties - Text
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
    public var textDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Placeholder Text
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(Color.secondary)

    /// Placeholder text font.
    public var placeholderTextFont: Font = .body

    /// Placeholder text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var placeholderTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound colors.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    /// Spacing type.
    nonisolated public enum SpacingType: Equatable, Sendable {
        // MARK: Cases
        /// Fixed spacing.
        case fixed(spacing: CGFloat)

        /// Stretched spacing.
        case stretched

        // MARK: Properties
        var hasFlexibleSpace: Bool {
            switch self {
            case .fixed: false
            case .stretched: true
            }
        }

        // MARK: Initializers
        /// Default value.
        public static var `default`: Self { .fixed(spacing: 7) }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VCodeEntryViewAppearance {
    /// `VCodeEntryViewAppearance` that applies green color scheme.
    public static var success: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()

        return appearance
    }

    /// `VCodeEntryViewAppearance` that applies yellow color scheme.
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()

        return appearance
    }

    /// `VCodeEntryViewAppearance` that applies error color scheme.
    public static var error: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyErrorColorScheme()

        return appearance
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VCodeEntryViewAppearance {
    /// Applies green color scheme to `VCodeEntryViewAppearance`.
    mutating public func applySuccessColorScheme() {
        characterBackgroundBorderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        characterBackgroundBorderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }

    /// Applies yellow color scheme to `VCodeEntryViewAppearance`.
    mutating public func applyWarningColorScheme() {
        characterBackgroundBorderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        characterBackgroundBorderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }

    /// Applies red color scheme to `VCodeEntryViewAppearance`.
    mutating public func applyErrorColorScheme() {
        characterBackgroundBorderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        characterBackgroundBorderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
}
