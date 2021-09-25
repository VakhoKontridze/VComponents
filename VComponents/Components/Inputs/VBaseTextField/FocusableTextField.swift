//
//  FocusableTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import UIKit

// MARK: - Focusable Text Field
final class FocusableTextField: UITextField {
    // MARK: Proeprties
    private let representable: UIKitTextFieldRepresentable
    
    // MARK: Initializers
    init(representable: UIKitTextFieldRepresentable) {
        self.representable = representable
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Responder
extension FocusableTextField {
    override func becomeFirstResponder() -> Bool {
        representable.setBindedFocus(to: true)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        representable.setBindedFocus(to: false)
        return super.resignFirstResponder()
    }
}
