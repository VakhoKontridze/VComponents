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
public struct VTextFieldUIModel {
    // MARK: Properties
    fileprivate static let roundedButtonReference: VRoundedButtonUIModel = .init()
    fileprivate static let segmentedPickerReference: VSegmentedPickerUIModel = .init()
    
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
        /// Textfield height. Defaults to `50`.
        public var height: CGFloat = 50
        
        /// Textfield corner radius. Defaults to `12`.
        public var cornerRadius: CGFloat = 12
        
        /// Textfield text alignment. Defaults to `default`.
        public var textAlignment: TextAlignment = .leading
        
        /// Textfield border width. Defaults to `1`.
        public var borderWidth: CGFloat = 1
        
        /// Content type. Defaults to `default`.
        public var contentType: ContentType = .default
        
        /// Content horizontal margin. Defaults to `15`.
        public var contentMarginHorizontal: CGFloat = 15
        
        /// Spacing between text and buttons. Defaults to `10`.
        public var contentSpacing: CGFloat = 10
        
        /// Search icon dimension. Defaults to `15`.
        public var searchIconDimension: CGFloat = 15
        
        /// Model for customizing clear button layout. `dimension` defaults to `22`, `iconSize` defaults to `8` by `8`, and `hitBox` defaults to `zero`.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var clearButtonSubUIModel: VRoundedButtonUIModel.Layout = {
            var uiModel: VRoundedButtonUIModel.Layout = .init()
            uiModel.dimension = 22
            uiModel.iconSize = .init(dimension: 8)
            uiModel.hitBox = .zero
            return uiModel
        }()
        
        /// Model for customizing visibility button layout. `iconSize` defaults to `20` by `20` and `hitBox` defaults to `zero`.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var visibilityButtonSubUIModel: VPlainButtonUIModel.Layout = {
            var uiModel: VPlainButtonUIModel.Layout = .init()
            uiModel.iconSize = .init(dimension: 20)
            uiModel.hitBox = .zero
            return uiModel
        }()
        
        /// Header title line type. Defaults to `singleline`.
        public var headerTitleLineType: TextLineType = .singleLine
        
        /// Footer title line type. Defaults to `multiline` of `1...5` lines.
        public var footerTitleLineType: TextLineType = .multiLine(alignment: .leading, lineLimit: 1...5)

        /// Spacing between header, textfield, and footer. Defaults to `3`.
        public var headerTextFieldFooterSpacing: CGFloat = segmentedPickerReference.layout.headerPickerFooterSpacing
        
        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerFooterMarginHorizontal: CGFloat = segmentedPickerReference.layout.headerFooterMarginHorizontal
        
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
            enabled: segmentedPickerReference.colors.background.enabled,
            focused: .init(componentAsset: "TextField.Background.focused"),
            disabled: segmentedPickerReference.colors.background.disabled
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
            enabled: segmentedPickerReference.colors.header.enabled,
            focused: segmentedPickerReference.colors.header.enabled,
            disabled: segmentedPickerReference.colors.header.disabled
        )

        /// Footer colors.
        public var footer: StateColors = .init(
            enabled: segmentedPickerReference.colors.footer.enabled,
            focused: segmentedPickerReference.colors.footer.enabled,
            disabled: segmentedPickerReference.colors.footer.disabled
        )

        /// Search icon colors.
        public var searchIcon: StateColors = .init(
            enabled: .init(componentAsset: "TextField.PlainButton.enabled"),
            focused: .init(componentAsset: "TextField.PlainButton.enabled"),
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Model for customizing clear button colors.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var clearButtonSubUIModel: VRoundedButtonUIModel.Colors = {
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            uiModel.background = .init(
                enabled: .init(componentAsset: "TextField.ClearButton.Background.enabled"),
                pressed: .init(componentAsset: "TextField.ClearButton.Background.pressed"),
                disabled: .init(componentAsset: "TextField.ClearButton.Background.disabled")
            )
            uiModel.icon = .init(.init(componentAsset: "TextField.ClearButton.Icon"))
            return uiModel
        }()
        
        /// Model for customizing visibility button colors.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var visibilityButtonSubUIModel: VPlainButtonUIModel.Colors = {
            var uiModel: VPlainButtonUIModel.Colors = .init()
            uiModel.icon = .init(
                enabled: .init(componentAsset: "TextField.PlainButton.enabled"),
                pressed: ColorBook.primaryPressedDisabled,
                disabled: ColorBook.primaryPressedDisabled
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
        /// Text font. Defaults to system font of size `16`.
        public var text: Font = .system(size: 16)
        
        /// Placeholder font. Defaults to system font of size `16`.
        public var placeholder: Font = .system(size: 16)
        
        /// Header font. Defaults to system font of size `14`.
        public var header: Font = segmentedPickerReference.fonts.header
        
        /// Footer font. Defaults to system font of size `13`.
        public var footer: Font = segmentedPickerReference.fonts.footer
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Clear button appear and disappear animation. Defaults to `easeInOut` with duration `0.2`.
        public var clearButton: Animation? = .easeInOut(duration: 0.2)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Keyboard type. Defaults to `default`.
        public var keyboardType: UIKeyboardType = .default
        
        /// Text content type. Defaults to `nil`.
        public var textContentType: UITextContentType? = nil

        /// Auto correct type. Defaults to `nil`.
        public var autocorrection: Bool? = nil
        
        /// Auto capitalization type. Defaults to `nil`.
        public var autocapitalization: TextInputAutocapitalization? = nil
         
        /// Submit button type. Defaults to `return`.
        public var submitButton: SubmitLabel = .return
        
        /// Indicates if textfield has clear button. Defaults to `true`.
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
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .success
        
        return uiModel
    }

    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .warning
        
        return uiModel
    }

    /// `VTextFieldUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .error
        
        return uiModel
    }
}

extension VTextFieldUIModel.Colors {
    /// `VTextFieldUIModel.Colors` that applies green color scheme.
    public static var success: Self {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Success.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Success.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Success.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Success.Foreground.enabled")
        )
    }

    /// `VTextFieldUIModel.Colors` that applies yellow color scheme.
    public static var warning: Self {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Warning.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Warning.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Warning.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Warning.Foreground.enabled")
        )
    }

    /// `VTextFieldUIModel.Colors` that applies error color scheme.
    public static var error: Self {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Error.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Error.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Error.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Error.Foreground.enabled")
        )
    }
    
    private static func createHighlightedColors(
        backgroundEnabled: Color,
        backgroundFocused: Color,
        enabled: Color,
        focused: Color
    ) -> Self {
        var colors: Self = .init()
        
        colors.background.enabled = backgroundEnabled
        colors.background.focused = backgroundFocused
        
        colors.border.enabled = enabled
        colors.border.focused = focused
        
        //colors.text
        
        colors.header.enabled = enabled
        colors.header.focused = focused
        
        colors.footer.enabled = enabled
        colors.footer.focused = focused
        
        //colors.searchIcon
        
        //colors.visibilityButtonIcon
        
        //colors.clearButtonBackground
        //colors.clearButtonIcon
        
        return colors
    }
}
