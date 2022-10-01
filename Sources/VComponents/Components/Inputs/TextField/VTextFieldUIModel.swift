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
    fileprivate static let closeButtonReference: VCloseButtonUIModel = .init()
    fileprivate static let segmentedPickerReference: VSegmentedPickerUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()
    
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
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
        
        /// Content horizontal margin. Defaults to `15`.
        public var contentMarginHorizontal: CGFloat = 15
        
        /// Search icon dimension. Defaults to `15`.
        public var searchIconDimension: CGFloat = 15
        
        /// Clear button dimension. Defaults to `22`.
        public var clearButtonDimension: CGFloat = 22
        
        /// Clear button  icon dimension. Defaults to `8`.
        public var clearButtonIconDimension: CGFloat = 8
        
        /// Visibility button dimension. Defaults to `22`.
        public var visibilityButtonDimension: CGFloat = 22
        
        /// Visibility button  icon dimension. Defaults to `8`.
        public var visibilityButtonIconDimension: CGFloat = 20
        
        /// Spacing between text and buttons. Defaults to `10`.
        public var contentSpacing: CGFloat = 10
        
        /// Header title line type. Defaults to `singleline`.
        public var headerTitleLineType: TextLineType = .singleLine
        
        /// Footer title line type. Defaults to `multiline` of `1...5` lines.
        public var footerTitleLineType: TextLineType = .multiLine(alignment: .leading, lineLimit: 1...5)

        /// Spacing between header, textfield, and footer. Defaults to `3`.
        public var headerTextFieldFooterSpacing: CGFloat = segmentedPickerReference.layout.headerPickerFooterSpacing
        
        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerFooterMarginHorizontal: CGFloat = segmentedPickerReference.layout.headerFooterMarginHorizontal
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
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

        /// Visibility button icon colors.
        public var visibilityButtonIcon: ButtonStateColors = .init(
            enabled: .init(componentAsset: "TextField.PlainButton.enabled"),
            pressed: ColorBook.primaryPressedDisabled,
            focused: .init(componentAsset: "TextField.PlainButton.enabled"),
            disabled: ColorBook.primaryPressedDisabled
        )

        /// Clear button background colors.
        public var clearButtonBackground: ButtonStateColors = .init(
            enabled: .init(componentAsset: "TextField.ClearButton.Background.enabled"),
            pressed: .init(componentAsset: "TextField.ClearButton.Background.pressed"),
            focused: .init(componentAsset: "TextField.ClearButton.Background.enabled"),
            disabled: .init(componentAsset: "TextField.ClearButton.Background.disabled")
        )

        /// Clear button icon colors.
        public var clearButtonIcon: ButtonStateColors = .init(
            enabled: .init(componentAsset: "TextField.ClearButton.Icon"),
            pressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            focused: .init(componentAsset: "TextField.ClearButton.Icon"),
            disabled: .init(componentAsset: "TextField.ClearButton.Icon")
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
        
        // MARK: Button State Colors
        /// Sub-model containing colors for component states.
        public typealias ButtonStateColors = GenericStateModel_EnabledPressedFocusedDisabled<Color>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
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
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Clear button appear and disappear animation. Defaults to `easeInOut` with duration `0.2`.
        public var clearButton: Animation? = .easeInOut(duration: 0.2)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
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
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
    var clearButtonSubUIModel: VCloseButtonUIModel {
        var uiModel: VCloseButtonUIModel = .init()
        
        uiModel.layout.dimension = layout.clearButtonDimension
        uiModel.layout.iconDimension = layout.clearButtonIconDimension
        uiModel.layout.hitBox.horizontal = 0
        uiModel.layout.hitBox.vertical = 0
        
        uiModel.colors.background = .init(colors.clearButtonBackground)
        uiModel.colors.icon = .init(colors.clearButtonIcon)
        
        return uiModel
    }
    
    var visibilityButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout.dimension = layout.visibilityButtonDimension
        uiModel.layout.cornerRadius = layout.visibilityButtonDimension / 2
        uiModel.layout.labelMargins.horizontal = 0
        uiModel.layout.labelMargins.vertical = 0
        uiModel.layout.hitBox.horizontal = 0
        uiModel.layout.hitBox.vertical = 0
        
        uiModel.colors.background = .clearColors
        uiModel.colors.icon = .init(colors.visibilityButtonIcon)
        
        return uiModel
    }
}
