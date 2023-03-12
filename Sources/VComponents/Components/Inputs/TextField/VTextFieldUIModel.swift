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
        public var contentSpacing: CGFloat = 10
        
        /// Search icon dimension. Set to `15`.
        public var searchIconDimension: CGFloat = 15
        
        /// Model for customizing clear button layout. `dimension` Set to `22`, `iconSize` Set to `8` by `8`, and `hitBox` Set to `zero`.
        public var clearButtonSubUIModel: VRoundedButtonUIModel.Layout = {
            var uiModel: VRoundedButtonUIModel.Layout = .init()
            
            uiModel.dimension = 22
            uiModel.iconSize = .init(dimension: 8)
            uiModel.hitBox = .zero
            
            return uiModel
        }()
        
        /// Model for customizing visibility button layout. `iconSize` Set to `20` by `20` and `hitBox` Set to `zero`.
        public var visibilityButtonSubUIModel: VPlainButtonUIModel.Layout = {
            var uiModel: VPlainButtonUIModel.Layout = .init()
            
            uiModel.iconSize = .init(dimension: 20)
            uiModel.hitBox = .zero
            
            return uiModel
        }()
        
        /// Header text line type. Set to `singleLine`.
        public var headerTextLineType: TextLineType = GlobalUIModel.Common.headerTextLineType
        
        /// Footer text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTextLineType: TextLineType = GlobalUIModel.Common.footerTextLineType
        
        /// Spacing between header, textfield, and footer. Set to `3`.
        public var headerTextFieldFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerFooterMarginHorizontal
        
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
            focused: GlobalUIModel.Inputs.backgroundColorFocused,
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
        
        /// Placeholder colors.
        public var placeholder: StateColors = .init(ColorBook.primaryPressedDisabled)
        
        /// Header colors.
        public var header: StateColors = .init(
            enabled: ColorBook.secondary,
            focused: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )

        /// Footer colors.
        public var footer: StateColors = .init(
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
        
        /// Model for customizing clear button colors.
        public var clearButtonSubUIModel: VRoundedButtonUIModel.Colors = {
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            
            uiModel.background = .init(
                enabled: GlobalUIModel.Inputs.clearButtonBackgroundEnabled,
                pressed: GlobalUIModel.Inputs.clearButtonBackgroundPressed,
                disabled: GlobalUIModel.Inputs.clearButtonBackgroundDisabled
            )
            uiModel.icon = .init(GlobalUIModel.Inputs.clearButtonIcon)
            
            return uiModel
        }()
        
        /// Model for customizing visibility button colors.
        public var visibilityButtonSubUIModel: VPlainButtonUIModel.Colors = {
            var uiModel: VPlainButtonUIModel.Colors = .init()
            
            uiModel.icon = .init(
                enabled: GlobalUIModel.Inputs.visibilityButtonEnabled,
                pressed: GlobalUIModel.Inputs.visibilityButtonPressedDisabled,
                disabled: GlobalUIModel.Inputs.visibilityButtonPressedDisabled
            )
            
            return uiModel
        }()
        
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
        /// Text font. Set to system font of size `16`.
        public var text: Font = .system(size: 16)
        
        /// Placeholder font. Set to system font of size `16`.
        public var placeholder: Font = .system(size: 16)
        
        /// Header font. Set to system font of size `14`.
        public var header: Font = GlobalUIModel.Common.headerFont
        
        /// Footer font. Set to system font of size `13`.
        public var footer: Font = GlobalUIModel.Common.footerFont
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Clear button appear and disappear animation. Set to `easeInOut` with duration `0.2`.
        public var clearButton: Animation? = .easeInOut(duration: 0.2)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Keyboard type. Set to `default`.
        public var keyboardType: UIKeyboardType = .default
        
        /// Text content type. Set to `nil`.
        public var textContentType: UITextContentType? = nil

        /// Auto correct type. Set to `nil`.
        public var autocorrection: Bool? = nil
        
        /// Auto capitalization type. Set to `nil`.
        public var autocapitalization: TextInputAutocapitalization? = nil
         
        /// Submit button type. Set to `return`.
        public var submitButton: SubmitLabel = .return
        
        /// Indicates if textfield has clear button. Set to `true`.
        public var hasClearButton: Bool = true
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Sub UI Models
    var clearButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout = layout.clearButtonSubUIModel
        
        uiModel.colors = colors.clearButtonSubUIModel
        
        return uiModel
    }
    
    var visibilityButtonSubUIModel: VPlainButtonUIModel {
        var uiModel: VPlainButtonUIModel = .init()
        
        uiModel.layout = layout.visibilityButtonSubUIModel
        
        uiModel.colors = colors.visibilityButtonSubUIModel
        
        return uiModel
    }
}

// MARK: - Factory (Content Types)
@available(iOS 15.0, *)
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
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        
        uiModel.colors = .success
        
        return uiModel
    }

    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        
        uiModel.colors = .warning
        
        return uiModel
    }

    /// `VTextFieldUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.borderWidth = 1
        
        uiModel.colors = .error
        
        return uiModel
    }
}

@available(iOS 15.0, *)
extension VTextFieldUIModel.Colors {
    /// `VTextFieldUIModel.Colors` that applies green color scheme.
    public static var success: Self {
        .createHighlightedColors(
            background: ColorBook.layerGreen,
            foreground: ColorBook.borderGreen
        )
    }

    /// `VTextFieldUIModel.Colors` that applies yellow color scheme.
    public static var warning: Self {
        .createHighlightedColors(
            background: ColorBook.layerYellow,
            foreground: ColorBook.borderYellow
        )
    }

    /// `VTextFieldUIModel.Colors` that applies error color scheme.
    public static var error: Self {
        .createHighlightedColors(
            background: ColorBook.layerRed,
            foreground: ColorBook.borderRed
        )
    }
    
    private static func createHighlightedColors(
        background: Color,
        foreground: Color
    ) -> Self {
        var colors: Self = .init()
        
        colors.background.enabled = background
        colors.background.focused = background
        
        colors.border.enabled = foreground
        colors.border.focused = foreground
        
        colors.header.enabled = foreground
        colors.header.focused = foreground
        
        colors.footer.enabled = foreground
        colors.footer.focused = foreground
        
        return colors
    }
}
