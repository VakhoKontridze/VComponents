//
//  UIKitTextFieldRepresentable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: UIKit Text Field Representable
struct UIKitTextFieldRepresentable {
    // MARK: Properties
    private let model: VBaseTextFieldModel
    
    @Binding private var state: VBaseTextFieldState
    
    private let placeholder: String?
    @Binding private var text: String
    
    let beginHandler: (() -> Void)?
    let changeHandler: (() -> Void)?
    let endHandler: (() -> Void)?
    
    let returnAction: VBaseTextFieldReturnButtonAction
    
    // MARK: Initialiers
    init(
        model: VBaseTextFieldModel,
        state: Binding<VBaseTextFieldState>,
        placeholder: String?,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)?,
        onChange changeHandler: (() -> Void)?,
        onEnd endHandler: (() -> Void)?,
        onReturn returnAction: VBaseTextFieldReturnButtonAction
    ) {
        self.model = model
        self._state = state
        self.placeholder = placeholder
        self._text = text
        self.beginHandler = beginHandler
        self.changeHandler = changeHandler
        self.endHandler = endHandler
        self.returnAction = returnAction
    }
}

// MARK:- Representable
extension UIKitTextFieldRepresentable: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        .init(representable: self)
    }
    
    func makeUIView(context: Context) -> FocusableTextField {
        let textField: FocusableTextField = .init(representable: self)
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        setBindedValues(textField, context: context)
        
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.textFieldDidChange), for: .editingChanged)
        
        return textField
    }
    
    func updateUIView(_ uiView: FocusableTextField, context: Context) {
        setBindedValues(uiView, context: context)
    }
    
    private func setBindedValues(_ textField: FocusableTextField, context: Context) {
        textField.isUserInteractionEnabled = state.isEnabled
        
        textField.isSecureTextEntry = model.misc.isSecureTextEntry
        
        let keybardTypeChanged: Bool = textField.keyboardType != model.misc.keyboardType
        textField.keyboardType = model.misc.keyboardType
        if keybardTypeChanged { textField.reloadInputViews() }
        
        let spellCheckChanged: Bool = textField.spellCheckingType != model.misc.spellCheck
        textField.spellCheckingType = model.misc.spellCheck
        if spellCheckChanged {
            let text = textField.text
            textField.text = ""
            textField.text = text   // Breaks when going from no to yes
        }
        
        let autocorrectChanged: Bool = textField.autocorrectionType != model.misc.autoCorrect
        textField.autocorrectionType = model.misc.autoCorrect
        if autocorrectChanged { textField.reloadInputViews() }
        
        textField.textAlignment = model.layout.textAlignment.nsTextAlignment
        
        textField.placeholder = placeholder
        textField.text = text
        
        textField.font = model.fonts.text
        textField.textColor = .init(model.colors.textContent.for(state))
        textField.alpha = .init(model.colors.textContent.for(state))
        textField.backgroundColor = .clear
        
        let returnKeyChanged: Bool = textField.returnKeyType != model.misc.returnButton
        textField.returnKeyType = model.misc.returnButton
        if returnKeyChanged { textField.reloadInputViews() }

        switch state.isFocused {
        case false:
            _ = textField.resignFirstResponder()
            
        case true:
            guard
                !textField.isFirstResponder,
                state.isEnabled,
                textField.canBecomeFirstResponder,
                context.environment.isEnabled
            else {
                return
            }
            
            _ = textField.becomeFirstResponder()
        }
    }
}

// MARK:- Focus and Commit
extension UIKitTextFieldRepresentable {
    func textFieldReturned(_ textField: UITextField) {
        DispatchQueue.main.async(execute: { self.state.setFocus(from: false) }) // Animation here is glitchy
    }
    
    func commitText(_ text: String?) {
        DispatchQueue.main.async(execute: { self.text = text ?? "" })
    }
    
    func setBindedFocus(to state: Bool) {
        DispatchQueue.main.async(execute: { withAnimation { self.state.setFocus(from: state) } })
    }
}

// MARK:- preview
struct UIKitTextFieldRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextField_Previews.previews
    }
}
