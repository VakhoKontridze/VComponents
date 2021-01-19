//
//  VBaseTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Base Text Field
/// Core component that is used throughout the framework as text field
///
/// Model, state, focus, and event callbacks can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var text: String = "Lorem ipsum"
///
/// var body: some View {
///     VBaseTextField(
///         text: $text,
///         onBegin: { print("Editing Began") },
///         onChange: {  print("Editing Changed") },
///         onEnd: { print("Editing Ended") }
///     )
///         .padding()
/// }
/// ```
///
public struct VBaseTextField: View {
    private let model: VBaseTextFieldModel
    
    private let state: VBaseTextFieldState
    @Binding private var isFocused: Bool
    private let isFocusable: Bool
    
    private let placeholder: String?
    @Binding private var text: String
    
    private let beginHandler: (() -> Void)?
    private let changeHandler: (() -> Void)?
    private let endHandler: (() -> Void)?
    
    // MARK: Initialiers
    public init(
        model: VBaseTextFieldModel = .init(),
        state: VBaseTextFieldState = .enabled,
        isFocused: Binding<Bool>,
        placeholder: String? = nil,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)? = nil,
        onChange changeHandler: (() -> Void)? = nil,
        onEnd endHandler: (() -> Void)? = nil
    ) {
        self.model = model
        self.state = state
        self._isFocused = isFocused
        self.isFocusable = true
        self.placeholder = placeholder
        self._text = text
        self.beginHandler = beginHandler
        self.changeHandler = changeHandler
        self.endHandler = endHandler
    }
    
    public init(
        model: VBaseTextFieldModel = .init(),
        state: VBaseTextFieldState = .enabled,
        placeholder: String? = nil,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)? = nil,
        onChange changeHandler: (() -> Void)? = nil,
        onEnd endHandler: (() -> Void)? = nil
    ) {
        self.model = model
        self.state = state
        self._isFocused = .constant(false)
        self.isFocusable = false
        self.placeholder = placeholder
        self._text = text
        self.beginHandler = beginHandler
        self.changeHandler = changeHandler
        self.endHandler = endHandler
    }
}

// MARK:- Body
extension VBaseTextField {
    public var body: some View {
        UIKitTextFieldRepresentable(
            model: model,
            state: state,
            isFocused: $isFocused,
            isFocusable: isFocusable,
            placeholder: placeholder,
            text: $text,
            onBegin: beginHandler,
            onChange: changeHandler,
            onEnd: endHandler
        )
    }
}

// MARK:- Preview
struct VBaseTextField_Previews: PreviewProvider {
    @State private static var text: String = "Lorem ipsum"
    
    static var previews: some View {
        VBaseTextField(
            text: $text,
            onBegin: { print("Editing Began") },
            onChange: {  print("Editing Changed") },
            onEnd: { print("Editing Ended") }
        )
            .padding()
    }
}
