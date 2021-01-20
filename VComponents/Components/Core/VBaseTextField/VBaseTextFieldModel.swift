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
    public var colors: Colors = .init()
    public var font: UIFont = .systemFont(ofSize: 16, weight: .regular)
    public var keyboardType: UIKeyboardType = .default
    public var returnBUtton: UIReturnKeyType = .default
    
    public init() {}
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
    }
}

// MARK:- ViewModel
extension VBaseTextFieldModel.Colors {
    func text(state: VBaseTextFieldState) -> Color {
        color(from: text, state: state)
    }
    
    func textOpacity(state: VBaseTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return text.disabledOpacity
        }
    }
    
    private func color(from colorSet: StateColorsAndOpacity, state: VBaseTextFieldState) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .focused: return colorSet.enabled
        case .disabled: return colorSet.disabled
        }
    }
}
