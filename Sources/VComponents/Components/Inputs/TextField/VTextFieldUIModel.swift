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
public struct VTextFieldUIModel {
    // MARK: Properties - Global Layout
    /// Textfield height. Set to `50`.
    public var height: CGFloat = GlobalUIModel.Inputs.height

    /// Spacing between header, textfield, and footer. Set to `3`.
    public var headerTextFieldAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing

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
    /// Textfield corner radius. Set to `12`.
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
    /// Header title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
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

    // MARK: Properties - TextField Content
    /// Content type. Set to `default`.
    public var contentType: ContentType = .default

    /// Content horizontal margin. Set to `15`.
    public var contentMarginHorizontal: CGFloat = GlobalUIModel.Common.containerContentMargin

    /// Spacing between text and buttons. Set to `10`.
    public var textAndButtonSpacing: CGFloat = 10

    // MARK: Properties - Text
    /// Text alignment. Set to `leading`.
    public var textAlignment: TextAlignment = .leading

    /// Text colors.
    public var textColors: StateColors = .init(
        enabled: ColorBook.primary,
        focused: ColorBook.primary,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Text font. Set to `body` (`17`).
    public var textFont: Font = .body

    // MARK: Properties - Placeholder Text
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(ColorBook.primaryPressedDisabled)

    /// Placeholder text font. Set to `body` (`17`).
    public var placeholderTextFont: Font = .body

    // MARK: Properties - Clear Button
    /// Indicates if textfield has clear button. Set to `true`.
    public var hasClearButton: Bool = true

    /// Clear button icon.
    public var clearButtonIcon: Image = ImageBook.xMark

    /// Model for customizing clear button.
    /// `size` is set to `22x22`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `8x8`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var clearButtonSubUIModel: VRectangularButtonUIModel = {
        var uiModel: VRectangularButtonUIModel = .init()

        uiModel.size = CGSize(dimension: 22)

        uiModel.backgroundColors = VRectangularButtonUIModel.StateColors(
            enabled: GlobalUIModel.Inputs.clearButtonLayerEnabled,
            pressed: GlobalUIModel.Inputs.clearButtonLayerPressed,
            disabled: GlobalUIModel.Inputs.clearButtonLayerDisabled
        )

        uiModel.iconSize = CGSize(dimension: 8)
        uiModel.iconColors = VRectangularButtonUIModel.StateColors(GlobalUIModel.Inputs.clearButtonIcon)

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    /// Clear button appear and disappear animation. Set to `nil`.
    public var clearButtonAppearDisappearAnimation: Animation? = nil

    // MARK: Properties - Secure
    /// Visibility button icon (off).
    public var visibilityOffButtonIcon: Image = ImageBook.visibilityOff

    /// Visibility button icon (on).
    public var visibilityOnButtonIcon: Image = ImageBook.visibilityOn

    /// Model for customizing visibility button.
    /// `iconSize` is set to `20x20`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var visibilityButtonSubUIModel: VPlainButtonUIModel = {
        var uiModel: VPlainButtonUIModel = .init()

        uiModel.iconSize = CGSize(dimension: 20)
        uiModel.iconColors = VPlainButtonUIModel.StateColors(
            enabled: GlobalUIModel.Inputs.visibilityButtonEnabled,
            pressed: GlobalUIModel.Inputs.visibilityButtonPressedDisabled,
            disabled: GlobalUIModel.Inputs.visibilityButtonPressedDisabled
        )

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    // MARK: Properties - Search
    /// Search button icon.
    public var searchButtonIcon: Image = ImageBook.magnifyGlass

    /// Search icon dimension. Set to `15`.
    public var searchIconDimension: CGFloat = 15

    /// Search icon colors.
    public var searchIconColors: StateColors = .init(
        enabled: GlobalUIModel.Inputs.searchIconEnabledFocused,
        focused: GlobalUIModel.Inputs.searchIconEnabledFocused,
        disabled: GlobalUIModel.Inputs.searchIconDisabled
    )

    // MARK: Properties - Submit Button
    /// Submit button type. Set to `return`.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Content Type
    /// Enumeration that represents content type, such as `standard`, `secure`, or `search`.
    public enum ContentType: Int, CaseIterable { // TODO: Remove properties when `CaseDetection` is added
        // MARK: Cases
        /// Standard type.
        case standard

        /// Secure type.
        ///
        /// Visibility icon is present, and securities, such as copying is enabled.
        case secure

        /// Search type.
        ///
        /// Magnification icon is present.
        case search

        // MARK: Properties
        var isStandard: Bool {
            switch self {
            case .standard: true
            case .secure: false
            case .search: false
            }
        }

        var isSecure: Bool {
            switch self {
            case .standard: false
            case .secure: true
            case .search: false
            }
        }

        var isSearch: Bool {
            switch self {
            case .standard: false
            case .secure: false
            case .search: true
            }
        }

        // MARK: Initializers
        /// Default value. Set to `standard`.
        public static var `default`: Self { .standard }
    }

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
}

// MARK: - Factory (Content Types)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applySuccessColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applyWarningColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applyErrorColorScheme()
        
        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextFieldUIModel {
    /// Applies green color scheme to `VTextFieldUIModel`.
    public mutating func applySuccessColorScheme() {
        applyHighlightedColors(
            border: ColorBook.borderGreen,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextGreenColor
        )
    }

    /// Applies yellow color scheme to `VTextFieldUIModel`.
    public mutating func applyWarningColorScheme() {
        applyHighlightedColors(
            border: ColorBook.borderYellow,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextYellowColor
        )
    }

    /// Applies red color scheme to `VTextFieldUIModel`.
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
