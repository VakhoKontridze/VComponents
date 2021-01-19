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
    
    private let state: VBaseTextFieldState
    @Binding private var isFocused: Bool
    private let isFocusable: Bool
    
    @Binding private var text: String
    
    let beginHandler: (() -> Void)?
    let changeHandler: (() -> Void)?
    let endHandler: (() -> Void)?
    
    @State private var manualRefresh: Int = 0
    
    // MARK: Initialiers
    init(
        model: VBaseTextFieldModel,
        state: VBaseTextFieldState,
        isFocused: Binding<Bool>,
        isFocusable: Bool,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)?,
        onChange changeHandler: (() -> Void)?,
        onEnd endHandler: (() -> Void)?
    ) {
        self.model = model
        self.state = state
        self._isFocused = isFocused
        self.isFocusable = isFocusable
        self._text = text
        self.beginHandler = beginHandler
        self.changeHandler = changeHandler
        self.endHandler = endHandler
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
        
        textField.isUserInteractionEnabled = state.isEnabled
        
        textField.text = text
        
        textField.font = model.font
        textField.textColor = .init(model.colors.color)
        textField.alpha = .init(model.colors.textOpacity(state: state))
        textField.backgroundColor = .clear
        
        textField.keyboardType = model.keyboardType
        textField.returnKeyType = model.returnKeyType
        
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.textFieldDidChange), for: .editingChanged)
        
        return textField
    }
    
    func updateUIView(_ uiView: FocusableTextField, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        updateKeyboardType(in: uiView)
        updateReturnType(in: uiView)
        updateState(in: uiView)
        updateText(in: uiView)
        updateFocus(in: uiView, context: context)
    }
    
    private func updateKeyboardType(in textField: FocusableTextField) {
        guard textField.keyboardType != model.keyboardType else { return }
        
        textField.keyboardType = model.keyboardType
    }
    
    private func updateReturnType(in textField: FocusableTextField) {
        guard textField.returnKeyType != model.returnKeyType else { return }
        
        textField.returnKeyType = model.returnKeyType
        textField.reloadInputViews()
    }
    
    private func updateState(in textField: FocusableTextField) {
        guard textField.isUserInteractionEnabled != state.isEnabled else { return }
        
        textField.isUserInteractionEnabled = state.isEnabled
        textField.alpha = .init(model.colors.textOpacity(state: state))
    }
    
    private func updateText(in textField: FocusableTextField) {
        guard textField.text != text else { return }
        
        textField.text = text
    }
    
    private func updateFocus(in textField: FocusableTextField, context: Context) {
        let isFocused: Bool = {
            switch isFocusable {
            case false: return textField.isFirstResponder
            case true: return self.isFocused
            }
        }()
        
        switch isFocused {
        case false:
            _ = textField.resignFirstResponder()
            
        case true:
            guard
                state.isEnabled,
                textField.canBecomeFirstResponder,
                textField.window != nil,
                context.environment.isEnabled
            else {
                _ = textField.resignFirstResponder()
                return
            }
            
            _ = textField.becomeFirstResponder()
        }
    }
}

// MARK:- Focus and Commit
extension UIKitTextFieldRepresentable {
    func commitText(_ text: String?) {
        DispatchQueue.main.async(execute: {
            self.text = text ?? ""
        })
    }
    
    func textFieldReturned(_ textField: UITextField) {
        DispatchQueue.main.async(execute: {
            let textField = textField as! FocusableTextField
            
            switch isFocusable {
            case false: _ = textField.resignFirstResponder(); manualRefresh += 1
            case true: isFocused = false
            }
        })
    }
    
    func setBindedFocus(to state: Bool) {
        DispatchQueue.main.async(execute: {
            switch isFocusable {
            case false: break
            case true: isFocused = state
            }
        })
    }
}

// MARK:- preview
struct VBaseTextFieldRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextField_Previews.previews
    }
}
