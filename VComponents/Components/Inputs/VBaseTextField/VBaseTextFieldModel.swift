//
//  VBaseTextFieldModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Base Text Field Model
/// Model that describes UI
public struct VBaseTextFieldModel {
    // MARK: Properties
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    // MARK: Initializers
    /// Initializes model with default values
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties
    public struct Layout {
        // MARK: Properties
        /// Textfield text alignment. Defaults to `default`.
        public var textAlignment: TextAlignment = .default

        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
        
        // MARK: Text Alignment
        /// Enum that describes text alignment, such as `center`, `leading`, `trailing`, or `auto`
        public enum TextAlignment: Int, CaseIterable {
            /// Center alignment
            case center
            
            /// Leading alignment
            case leading
            
            /// Trailing alignment
            case trailing
            
            /// Auto alignment based on the current localization of the app
            case auto
            
            /// Default value. Set to `leading`.
            public static let `default`: Self = .leading
            
            var nsTextAlignment: NSTextAlignment {
                switch self {
                case .center: return .center
                case .leading: return .left
                case .trailing: return .right
                case .auto: return .natural
                }
            }
        }
    }

    // MARK: Colors
    /// Sub-model containing color properties
    public struct Colors {
        // MARK: Properties
        /// Text colors and opacities
        public var text: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            disabled: ColorBook.primary,
            disabledOpacity: 0.5
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
        
        // MARK: State Colors and Opacities
        /// Sub-model containing colors and opacities for component states
        public typealias StateColorsAndOpacities = StateColorsAndOpacities_EP_D
    }

    // MARK: Fonts
    /// Sub-model containing font properties
    public struct Fonts {
        // MARK: Properties
        /// Text font. Defaults to system font of size `16`.
        public var text: UIFont = .systemFont(ofSize: 16)
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }
    
    // MARK: Misc
    /// Sub-model containing misc properties
    public struct Misc {
        // MARK: Properties
        /// Indicates if secure entry is enabled. Defaults to `false`.
        public var isSecureTextEntry: Bool = false
        
        /// Keyboard type. Defaults to `default`.
        public var keyboardType: UIKeyboardType = .default
        
        /// Text content type. Defaults to `nil`.
        public var textContentType: UITextContentType?
        
        /// Spell check type. Defaults to `default`.
        public var spellCheck: UITextSpellCheckingType = .default
        
        /// Auto correct type. Defaults to `default`.
        public var autoCorrect: UITextAutocorrectionType = .default
        
        /// Auto-capitalization type. Defaults to `sentences`.
        public var autoCapitalization: UITextAutocapitalizationType = .sentences
        
        /// Default button type. Defaults to `default`.
        public var returnButton: UIReturnKeyType = .default
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }
}
