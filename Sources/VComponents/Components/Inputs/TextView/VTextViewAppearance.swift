//
//  VTextViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextViewAppearance: Equatable, Sendable {
    // MARK: Properties - Global
    /// Minimum height.
    public var minimumHeight: CGFloat = 50
    
    /// Content margins.
    public var contentMargins: EdgeInsets = .init(15)
    
    // MARK: Properties - TextView
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
    
    /// Submit button type.
    public var submitButton: SubmitLabel = .return

    // MARK: Properties - Corners
    /// Textview orner radius.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.platformDynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.platformDynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors

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

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound colors.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
}

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
        borderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        borderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }

    /// Applies yellow color scheme to `VTextViewAppearance`.
    mutating public func applyWarningColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        borderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }

    /// Applies red color scheme to `VTextViewAppearance`.
    mutating public func applyErrorColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        borderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
}
