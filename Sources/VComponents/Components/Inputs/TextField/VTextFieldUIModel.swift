//
//  VTextFieldUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Text Field UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextFieldUIModel: Sendable {
    // MARK: Properties - Global
    /// Spacing between header, textfield, and footer. Set to `3`.
    public var headerTextFieldAndFooterSpacing: CGFloat = 3

    /// Textfield height. Set to `50`.
    public var height: CGFloat = 50

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
    /// Textfield corner radius. Set to `12`.
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

    // MARK: Properties - TextField
    /// Content type. Set to `default`.
    public var contentType: ContentType = .default

    /// Textfield content horizontal margin. Set to `15`.
    public var textFieldContentMarginHorizontal: CGFloat = 15

    /// Spacing between text and buttons. Set to `10`.
    public var textAndButtonSpacing: CGFloat = 10

    // MARK: Properties - Text
    /// Text alignment. Set to `leading`.
    public var textAlignment: TextAlignment = .leading

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

    // MARK: Properties - Clear Button
    /// Indicates if textfield has clear button. Set to `true`.
    public var hasClearButton: Bool = true

    /// Clear button icon.
    public var clearButtonIcon: Image = ImageBook.xMark.renderingMode(.template)

    /// Model for customizing clear button.
    /// `size` is set to `(22, 22)`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `(8, 8)`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var clearButtonSubUIModel: VRectangularButtonUIModel = {
        var uiModel: VRectangularButtonUIModel = .init()

        uiModel.size = CGSize(dimension: 22)

        uiModel.backgroundColors = VRectangularButtonUIModel.StateColors(
            enabled: Color.dynamic(Color(170, 170, 170), Color(40, 40, 40)),
            pressed: Color.dynamic(Color(150, 150, 150), Color(20, 20, 20)),
            disabled: Color.dynamic(Color(220, 220, 220), Color(40, 40, 40))
        )

        uiModel.iconSize = CGSize(dimension: 8)
        uiModel.iconColors = VRectangularButtonUIModel.StateColors(
            Color.dynamic(Color(255, 255, 255), Color(230, 230, 230))
        )

        uiModel.hitBox = .zero

#if os(iOS) || os(watchOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    /// Clear button appear and disappear animation. Set to `nil`.
    public var clearButtonAppearDisappearAnimation: Animation?

    // MARK: Properties - Secure
    /// Visibility button icon (off).
    public var visibilityOffButtonIcon: Image = ImageBook.visibilityOff.renderingMode(.template)

    /// Visibility button icon (on).
    public var visibilityOnButtonIcon: Image = ImageBook.visibilityOn.renderingMode(.template)

    /// Model for customizing visibility button.
    /// `iconSize` is set to `(20, 20)`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var visibilityButtonSubUIModel: VPlainButtonUIModel = {
        var uiModel: VPlainButtonUIModel = .init()

        uiModel.iconSize = CGSize(dimension: 20)
        uiModel.iconColors = VPlainButtonUIModel.StateColors(
            enabled: Color.dynamic(Color(70, 70, 70), Color(240, 240, 240)),
            pressed: Color.primary.opacity(0.3),
            disabled: Color.primary.opacity(0.3)
        )

        uiModel.hitBox = .zero

#if os(iOS) || os(watchOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    // MARK: Properties - Search
    /// Search button icon.
    public var searchButtonIcon: Image = ImageBook.magnifyGlass.renderingMode(.template)

    /// Indicates if `resizable(...)` modifier is applied to search icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isSearchIconResizable: Bool = true

    /// Search icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconContentMode: ContentMode? = .fit

    /// Search icon size. Set to `(15, 15)`.
    public var searchIconSize: CGSize? = .init(dimension: 15)

    /// Search icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconColors: StateColors? = .init(
        enabled: Color.dynamic(Color(70, 70, 70), Color(240, 240, 240)),
        focused: Color.dynamic(Color(70, 70, 70), Color(240, 240, 240)),
        disabled: Color.primary.opacity(0.3)
    )

    /// Search icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconOpacities: StateOpacities?

    /// Search icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isSearchIconResizable` should be set to `false`, and `searchIconSize` should be set to `nil`.
    public var searchIconFont: Font?

    /// Search icon `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Submit Button
    /// Submit button type. Set to `return`.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes UI model with default values.
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
        /// Default value. Set to `standard`.
        public static var `default`: Self { .standard }
    }

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains colors for component opacities.
    public typealias StateOpacities = GenericStateModel_EnabledFocusedDisabled<CGFloat>
}

// MARK: - Factory (Content Types)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` with secure content type.
    public static var secure: Self {
        var uiModel: Self = .init()
        
        uiModel.contentType = .secure
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` with search content type.
    public static var search: Self {
        var uiModel: Self = .init()
        
        uiModel.contentType = .search
        
        return uiModel
    }
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = PointPixelMeasurement.points(1.5)
        uiModel.applySuccessColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = PointPixelMeasurement.points(1.5)
        uiModel.applyWarningColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies error color scheme.
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
extension VTextFieldUIModel {
    /// Applies green color scheme to `VTextFieldUIModel`.
    mutating public func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(85, 195, 135), Color(45, 150, 75)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(85, 175, 135), Color(85, 195, 135))
        )
    }

    /// Applies yellow color scheme to `VTextFieldUIModel`.
    mutating public func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.dynamic(Color(255, 190, 35), Color(240, 150, 20)),
            headerTitleTextAndFooterTitleText: Color.dynamic(Color(235, 170, 35), Color(255, 190, 35))
        )
    }

    /// Applies red color scheme to `VTextFieldUIModel`.
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
