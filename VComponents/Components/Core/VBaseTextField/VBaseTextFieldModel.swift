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
    public var returnKeyType: UIReturnKeyType = .default
    
    public init() {}
}

// MARK:- Colors
extension VBaseTextFieldModel {
    public struct Colors {
        public var color: Color = ColorBook.primary
        public var disabledOpacity: Double = 0.5
        
        public init() {}
    }
}

// MARK:- VM
extension VBaseTextFieldModel.Colors {
    func textOpacity(state: VBaseTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return disabledOpacity
        }
    }
}
