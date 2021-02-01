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
/// Model, placeholder, event callbacks, and button action can be passed as parameters
///
/// It is possible to override action of return button by passing it as a parameter
///
/// If two TextField's state is managed by a single property, unpredictable behaviors would occur
///
/// # Usage Example #
///
/// ```
/// @State var state: VBaseTextFieldState = .focused
/// @State var text: String = "Lorem ipsum"
///
/// var body: some View {
///     VBaseTextField(
///         state: $state,
///         placeholder: "Lorem ipsum",
///         text: $text
///     )
///         .padding()
/// }
/// ```
///
/// Full use of overriden action and event callbacks:
/// ```
/// @State var state: VBaseTextFieldState = .enabled
/// @State var text: String = "Lorem ipsum"
///
/// var body: some View {
///     VBaseTextField(
///         state: $state,
///         placeholder: "Lorem ipsum",
///         text: $text,
///         onBegin: { print("Editing Began") },
///         onChange: {  print("Editing Changed") },
///         onEnd: { print("Editing Ended") },
///         onReturn: .returnAndCustom({ print("Returned and ...") })
///     )
///         .padding()
/// }
/// ```
///
public struct VBaseTextField: View {
    private let model: VBaseTextFieldModel
    
    @Binding private var state: VBaseTextFieldState
    
    private let placeholder: String?
    @Binding private var text: String
    
    private let beginHandler: (() -> Void)?
    private let changeHandler: (() -> Void)?
    private let endHandler: (() -> Void)?
    
    private let returnAction: VBaseTextFieldReturnButtonAction
    
    // MARK: Initialiers
    public init(
        model: VBaseTextFieldModel = .init(),
        state: Binding<VBaseTextFieldState>,
        placeholder: String? = nil,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)? = nil,
        onChange changeHandler: (() -> Void)? = nil,
        onEnd endHandler: (() -> Void)? = nil,
        onReturn returnAction: VBaseTextFieldReturnButtonAction = .default
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

// MARK:- Body
extension VBaseTextField {
    public var body: some View {
        UIKitTextFieldRepresentable(
            model: model,
            state: $state,
            placeholder: placeholder,
            text: $text,
            onBegin: beginHandler,
            onChange: changeHandler,
            onEnd: endHandler,
            onReturn: returnAction
        )
    }
}

// MARK:- Preview
struct VBaseTextField_Previews: PreviewProvider {
    @State private static var state: VBaseTextFieldState = .enabled
    @State private static var text: String = "Lorem ipsum"
    
    static var previews: some View {
        VBaseTextField(
            state: $state,
            placeholder: "Lorem ipsum",
            text: $text
        )
            .padding()
    }
}
