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
    public var font: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    public var isSecureTextEntry: Bool = false
    
    public var keyboardType: UIKeyboardType = .default
    public var useAutoCorrect: Bool = true
    
    public var returnButton: UIReturnKeyType = .default
    
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
    public enum TextAlignment: Int, CaseIterable {
        case leading
        case center
        case trailing
        case automatic
        
        public static let `default`: Self = .leading
        
        var nsTextAlignment: NSTextAlignment {
            switch self {
            case .leading: return .left
            case .center: return .center
            case .trailing: return .right
            case .automatic: return .natural
            }
        }
    }
}

// MARK:- Colors
extension VBaseTextFieldModel {
    public struct Colors {
        public var text: StateColorsAndOpacity = .init(
            enabled: ColorBook.primary,
            disabled: ColorBook.primary,
            disabledOpacity: 0.5
        )

        public init() {}
    }
}

extension VBaseTextFieldModel.Colors {
    public struct StateColorsAndOpacity {
        public var enabled: Color
        public var disabled: Color
        public var disabledOpacity: Double
        
        public init(enabled: Color, disabled: Color, disabledOpacity: Double) {
            self.enabled = enabled
            self.disabled = disabled
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VBaseTextFieldState) -> Color {
            switch state {
            case .enabled: return enabled
            case .focused: return enabled
            case .disabled: return disabled
            }
        }
        
        func `for`(_ state: VBaseTextFieldState) -> Double {
            switch state {
            case .enabled: return 1
            case .focused: return 1
            case .disabled: return disabledOpacity
            }
        }
    }
}
