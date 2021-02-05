//
//  VBaseTextFieldModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Base Text Field Model
/// Model that describes UI
public struct VBaseTextFieldModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VBaseTextFieldModel {
    public struct Layout {
        public var textAlignment: TextAlignment = .default

        public init() {}
    }
}

extension VBaseTextFieldModel.Layout {
    /// Enum that describes text alignment, such as leading, center, trailing, or auto
    public enum TextAlignment: Int, CaseIterable {
        case center
        case leading
        case trailing
        case auto
        
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

// MARK:- Colors
extension VBaseTextFieldModel {
    public struct Colors {
        public var textContent: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            disabled: ColorBook.primary,
            disabledOpacity: 0.5
        )

        public init() {}
    }
}

extension VBaseTextFieldModel.Colors {
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEP_D
}

// MARK:- Fonts
extension VBaseTextFieldModel {
    public struct Fonts {
        public var text: UIFont = .systemFont(ofSize: 16, weight: .regular)
        
        public init() {}
    }
}

// MARK:- Misc
extension VBaseTextFieldModel {
    public struct Misc {
        public var isSecureTextEntry: Bool = false
        
        public var keyboardType: UIKeyboardType = .default
        public var textContentType: UITextContentType?
        
        public var spellCheck: UITextSpellCheckingType = .default
        public var autoCorrect: UITextAutocorrectionType = .default
        
        public var returnButton: UIReturnKeyType = .default
        
        public init() {}
    }
}

extension VBaseTextFieldModel {
    
}
