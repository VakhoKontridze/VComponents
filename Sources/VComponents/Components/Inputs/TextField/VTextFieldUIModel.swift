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
@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
public struct VTextFieldUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    /// Model that contains misc properties.
    public var misc: Misc = .init()
    
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Textfield height. Set to `50`.
        public var height: CGFloat = GlobalUIModel.Inputs.height
        
        /// Textfield corner radius. Set to `12`.
        public var cornerRadius: CGFloat = GlobalUIModel.Inputs.cornerRadius
        
        /// Textfield text alignment. Set to `leading`.
        public var textAlignment: TextAlignment = .leading
        
        /// Border width. Set to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Content type. Set to `default`.
        public var contentType: ContentType = .default
        
        /// Content horizontal margin. Set to `15`.
        public var contentMarginHorizontal: CGFloat = GlobalUIModel.Common.containerContentMargin
        
        /// Spacing between text and buttons. Set to `10`.
        public var textAndButtonSpacing: CGFloat = 10
        
        /// Search icon dimension. Set to `15`.
        public var searchIconDimension: CGFloat = 15
        
        /// Header title text line type. Set to `singleLine`.
        public var headerTitleTextLineType: TextLineType = GlobalUIModel.Common.headerTitleTextLineType
        
        /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTitleTextLineType: TextLineType = GlobalUIModel.Common.footerTitleTextLineType
        
        /// Spacing between header, textfield, and footer. Set to `3`.
        public var headerTextFieldAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerAndFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Content Type
        /// Enum that represents content type, such as `standard`, `secure`, or `search`.
        public enum ContentType: Int, CaseIterable {
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
                case .standard: return true
                case .secure: return false
                case .search: return false
                }
            }
            
            var isSecure: Bool {
                switch self {
                case .standard: return false
                case .secure: return true
                case .search: return false
                }
            }
            
            var isSearch: Bool {
                switch self {
                case .standard: return false
                case .secure: return false
                case .search: return true
                }
            }
            
            // MARK: Initializers
            /// Default value. Set to `standard`.
            public static var `default`: Self { .standard }
        }
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.layerGray,
            focused: GlobalUIModel.Inputs.layerGrayColorFocused,
            disabled: ColorBook.layerGrayDisabled
        )
        
        /// Border colors.
        public var border: StateColors = .clearColors
        
        /// Text colors.
        public var text: StateColors = .init(
            enabled: ColorBook.primary,
            focused: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Placeholder text colors.
        public var placeholderText: StateColors = .init(ColorBook.primaryPressedDisabled)
        
        /// Header title text colors.
        public var headerTitleText: StateColors = .init(
            enabled: ColorBook.secondary,
            focused: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        /// Footer title text colors.
        public var footerTitleText: StateColors = .init(
            enabled: ColorBook.secondary,
            focused: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        /// Search icon colors.
        public var searchIcon: StateColors = .init(
            enabled: GlobalUIModel.Inputs.searchIconEnabledFocused,
            focused: GlobalUIModel.Inputs.searchIconEnabledFocused,
            disabled: GlobalUIModel.Inputs.searchIconDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
    }
    
    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Text font. Set to `body` (`17`).
        public var text: Font = .body
        
        /// Placeholder text font. Set to `body` (`17`).
        public var placeholderText: Font = .body
        
        /// Header title text font. Set to `footnote` (`13`).
        public var headerTitleText: Font = GlobalUIModel.Common.headerTitleTextFont
        
        /// Footer title text font. Set to `footnote` (`13`).
        public var footerTitleText: Font = GlobalUIModel.Common.footerTitleTextFont
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Clear button appear and disappear animation. Set to `nil`.
        public var clearButton: Animation? = nil

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
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
        
        /// Submit button type. Set to `return`.
        public var submitButton: SubmitLabel = .return
        
        /// Indicates if textfield has clear button. Set to `true`.
        public var hasClearButton: Bool = true
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Sub UI Models
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

    /// Model for customizing clear button.
    /// `size` is set to `22x22`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `8x8`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var clearButtonSubUIModel: VRoundedButtonUIModel = {
        var uiModel: VRoundedButtonUIModel = .init()

        uiModel.size = CGSize(dimension: 22)

        uiModel.backgroundColors = VRoundedButtonUIModel.StateColors(
            enabled: GlobalUIModel.Inputs.clearButtonLayerEnabled,
            pressed: GlobalUIModel.Inputs.clearButtonLayerPressed,
            disabled: GlobalUIModel.Inputs.clearButtonLayerDisabled
        )

        uiModel.iconSize = CGSize(dimension: 8)
        uiModel.iconColors = VRoundedButtonUIModel.StateColors(GlobalUIModel.Inputs.clearButtonIcon)

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()
}

// MARK: - Factory (Content Types)
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` with secure content type.
    public static var secure: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentType = .secure
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` with search content type.
    public static var search: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentType = .search
        
        return uiModel
    }
}

// MARK: - Factory (Highlights)
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1.5
        
        uiModel.colors = .success
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1.5
        
        uiModel.colors = .warning
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1.5
        
        uiModel.colors = .error
        
        return uiModel
    }
}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextFieldUIModel.Colors {
    /// `VTextFieldUIModel.Colors` that applies green color scheme.
    public static var success: Self {
        .createHighlightedColors(
            border: ColorBook.borderGreen,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextGreenColor
        )
    }
    
    /// `VTextFieldUIModel.Colors` that applies yellow color scheme.
    public static var warning: Self {
        .createHighlightedColors(
            border: ColorBook.borderYellow,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextYellowColor
        )
    }
    
    /// `VTextFieldUIModel.Colors` that applies error color scheme.
    public static var error: Self {
        .createHighlightedColors(
            border: ColorBook.borderRed,
            headerTitleTextAndFooterTitleText: GlobalUIModel.Inputs.headerTitleTextAndFooterTitleTextRedColor
        )
    }
    
    private static func createHighlightedColors(
        border: Color,
        headerTitleTextAndFooterTitleText: Color
    ) -> Self {
        var colors: Self = .init()
        
        colors.border.enabled = border
        colors.border.focused = border
        
        colors.headerTitleText.enabled = headerTitleTextAndFooterTitleText
        colors.headerTitleText.focused = headerTitleTextAndFooterTitleText
        
        colors.footerTitleText.enabled = headerTitleTextAndFooterTitleText
        colors.footerTitleText.focused = headerTitleTextAndFooterTitleText
        
        return colors
    }
}
