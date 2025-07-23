//
//  VTextFieldAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Text Field Appearance
/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextFieldAppearance: Sendable {
    // MARK: Properties - Global
    /// Textfield height.
    public var height: CGFloat = 50

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
    /// Textfield corner radius.
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

    // MARK: Properties - TextField
    /// Content type.
    public var contentType: ContentType = .default

    /// Textfield content horizontal margin.
    public var textFieldContentMarginHorizontal: CGFloat = 15

    /// Spacing content horizontal spacing.
    public var textFieldContentSpacingHorizontal: CGFloat = 10

    // MARK: Properties - Text
    /// Text alignment.
    public var textAlignment: TextAlignment = .leading

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

    // MARK: Properties - Clear Button
    /// Indicates if textfield has clear button.
    public var hasClearButton: Bool = true

    /// Clear button icon.
    public var clearButtonIcon: Image = ImageBook.xMark.renderingMode(.template)

    /// Clear button appearance.
    public var clearButtonAppearance: VRectangularButtonAppearance = {
        var appearance: VRectangularButtonAppearance = .init()

        appearance.size = CGSize(dimension: 22)

        appearance.backgroundColors = VRectangularButtonAppearance.StateColors(
            enabled: Color.platformDynamic(Color(170, 170, 170), Color(40, 40, 40)),
            pressed: Color.platformDynamic(Color(150, 150, 150), Color(20, 20, 20)),
            disabled: Color.platformDynamic(Color(220, 220, 220), Color(40, 40, 40))
        )

        appearance.iconSize = CGSize(dimension: 8)
        appearance.iconColors = VRectangularButtonAppearance.StateColors(
            Color.platformDynamic(Color(255, 255, 255), Color(230, 230, 230))
        )

        appearance.hitBox = EdgeInsets()

#if os(iOS) || os(watchOS)
        appearance.haptic = nil
#endif

        return appearance
    }()

    /// Clear button appear and disappear animation.
    public var clearButtonAppearDisappearAnimation: Animation?

    // MARK: Properties - Secure
    /// Visibility button icon (off).
    public var visibilityOffButtonIcon: Image = ImageBook.visibilityOff.renderingMode(.template)

    /// Visibility button icon (on).
    public var visibilityOnButtonIcon: Image = ImageBook.visibilityOn.renderingMode(.template)

    /// Visibility button appearance.
    public var visibilityButtonAppearance: VPlainButtonAppearance = {
        var appearance: VPlainButtonAppearance = .init()

        appearance.iconSize = CGSize(dimension: 20)
        appearance.iconColors = VPlainButtonAppearance.StateColors(
            enabled: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
            pressed: Color.primary.opacity(0.3),
            disabled: Color.primary.opacity(0.3)
        )

        appearance.hitBox = EdgeInsets()

#if os(iOS) || os(watchOS)
        appearance.haptic = nil
#endif

        return appearance
    }()

    // MARK: Properties - Search
    /// Search button icon.
    public var searchButtonIcon: Image = ImageBook.magnifyGlass.renderingMode(.template)

    /// Indicates if `resizable(...)` modifier is applied to search icon.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isSearchIconResizable: Bool = true

    /// Search icon content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconContentMode: ContentMode? = .fit

    /// Search icon size.
    public var searchIconSize: CGSize? = .init(dimension: 15)

    /// Search icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconColors: StateColors? = .init(
        enabled: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
        focused: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
        disabled: Color.primary.opacity(0.3)
    )

    /// Search icon opacities.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconOpacities: StateOpacities?

    /// Search icon font.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isSearchIconResizable` should be set to `false`, and `searchIconSize` should be set to `nil`.
    public var searchIconFont: Font?

    /// Search icon `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Submit Button
    /// Submit button type.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Content Type
    /// Content type.
    public enum ContentType: Int, Sendable, CaseIterable {
        // MARK: Cases
        /// Standard.
        case standard

        /// Secure.
        ///
        /// Visibility icon is present, and securities, such as copying is enabled.
        case secure

        /// Search.
        ///
        /// Magnification icon is present.
        case search

        // MARK: Properties
        var hasSearchIcon: Bool {
            switch self {
            case .standard: false
            case .secure: false
            case .search: true
            }
        }

        var hasClearButton: Bool {
            switch self {
            case .standard: true
            case .secure: false
            case .search: true
            }
        }

        var hasVisibilityButton: Bool {
            switch self {
            case .standard: false
            case .secure: true
            case .search: false
            }
        }

        // MARK: Initializers
        /// Default value.
        public static var `default`: Self { .standard }
    }

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains colors for component opacities.
    public typealias StateOpacities = GenericStateModel_EnabledFocusedDisabled<CGFloat>
}

// MARK: - Factory - Content Types
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldAppearance {
    /// `VTextFieldAppearance` with secure content type.
    public static var secure: Self {
        var appearance: Self = .init()
        
        appearance.contentType = .secure
        
        return appearance
    }
    
    /// `VTextFieldAppearance` with search content type.
    public static var search: Self {
        var appearance: Self = .init()
        
        appearance.contentType = .search
        
        return appearance
    }
}

// MARK: - Factory - Highlights
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldAppearance {
    /// `VTextFieldAppearance` that applies green color scheme.
    public static var success: Self {
        var appearance: Self = .init()
        
        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()
        
        return appearance
    }
    
    /// `VTextFieldAppearance` that applies yellow color scheme.
    public static var warning: Self {
        var appearance: Self = .init()
        
        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()
        
        return appearance
    }
    
    /// `VTextFieldAppearance` that applies error color scheme.
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
extension VTextFieldAppearance {
    /// Applies green color scheme to `VTextFieldAppearance`.
    mutating public func applySuccessColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        borderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }

    /// Applies yellow color scheme to `VTextFieldAppearance`.
    mutating public func applyWarningColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        borderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }

    /// Applies red color scheme to `VTextFieldAppearance`.
    mutating public func applyErrorColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        borderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
}
