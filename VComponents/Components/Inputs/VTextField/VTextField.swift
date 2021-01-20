//
//  VTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Text Field
/// Input component that displays an editable text interface
///
/// Model, highligh, palceholder, title, subtitle, and event callbacks can be passed as parameters
///
/// It is possible to override actions of return, clear, and cancel buttons by passing them as a parameter
///
/// # Usage Example #
///
/// ```
/// @State var state: VTextFieldState = .focused
/// @State var text: String = "Lorem ipsum"
///
/// var body: some View {
///     VTextField(
///         state: $state,
///         placeholder: "Lorem ipsum",
///         title: "Lorem ipsum dolor sit amet",
///         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///         text: $text
///     )
///         .padding()
/// }
/// ```
///
/// Full use of overriden actions and event callbacks looks like this:
/// ```
/// let model: VTextFieldModel = {
///     var model: VTextFieldModel = .init()
///
///     model.returnButton = .default
///     model.clearButton = true
///     model.cancelButton = "Cancel"
///
///     return model
/// }()
///
/// @State private var state: VTextFieldState = .enabled
/// @State private var text: String = "Lorem ipsum"
///
/// var body: some View {
///     VTextField(
///         model: model,
///         state: $state,
///         placeholder: "Lorem ipsum",
///         title: "Lorem ipsum dolor sit amet",
///         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///         text: $text,
///         onBegin: { print("Editing Began") },
///         onChange: {  print("Editing Changed") },
///         onEnd: { print("Editing Ended") },
///         onReturn: .returnAndCustom({ print("Returned and ...") }),
///         onClear: .clearAndCustom({ print("Cleared and ...") }),
///         onCancel: .clearAndCustom({ print("Cancelled and ...") })
///     )
///         .padding()
/// }
/// ```
///
public struct VTextField: View {
    private let model: VTextFieldModel
    
    @Binding private var state: VTextFieldState
    private let highlight: VTextFieldHighlight
    
    private let placeholder: String?
    private let title: String?
    private let description: String?
    @Binding private var text: String
                
    private let beginHandler: (() -> Void)?
    private let changeHandler: (() -> Void)?
    private let endHandler: (() -> Void)?
    
    private let returnButtonAction: VTextFieldReturnButtonAction
    private let clearButtonAction: VTextFieldClearButtonAction
    private let cancelButtonAction: VTextFieldCancelButtonAction
    
    @State private var nonEmptyText: Bool

    // MARK: Initialiers
    public init(
        model: VTextFieldModel = .init(),
        state: Binding<VTextFieldState>,
        highlight: VTextFieldHighlight = .default,
        placeholder: String? = nil,
        title: String? = nil,
        description: String? = nil,
        text: Binding<String>,
        onBegin beginHandler: (() -> Void)? = nil,
        onChange changeHandler: (() -> Void)? = nil,
        onEnd endHandler: (() -> Void)? = nil,
        onReturn returnButtonAction: VTextFieldReturnButtonAction = .default,
        onClear clearButtonAction: VTextFieldClearButtonAction = .default,
        onCancel cancelButtonAction: VTextFieldCancelButtonAction = .default
    ) {
        self.model = model
        self._state = state
        self.highlight = highlight
        self.placeholder = placeholder
        self.title = title
        self.description = description
        self._text = text
        self.beginHandler = beginHandler
        self.changeHandler = changeHandler
        self.endHandler = endHandler
        self.returnButtonAction = returnButtonAction
        self.clearButtonAction = clearButtonAction
        self.cancelButtonAction = cancelButtonAction
        self._nonEmptyText = .init(wrappedValue: !text.wrappedValue.isEmpty)
    }
}

// MARK:- Body
extension VTextField {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleSpacing, content: {
            titleView
            textFieldView
            descriptionView
        })
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VBaseText(
                title: title,
                color: model.colors.titleColor(state: state, highlight: highlight),
                font: model.fonts.title,
                type: .oneLine
            )
                .padding(.horizontal, model.layout.titleMarginHor)
                .opacity(model.colors.contentOpacity(state: state))
        }
    }
    
    private var textFieldView: some View {
        HStack(spacing: 10, content: {
            HStack(spacing: 10, content: {
                textFieldContentView
                clearButton
            })
                .padding(.horizontal, model.layout.contentMarginHorizontal)
                .frame(height: model.layout.height)
                .background(background)
            
            cancelButton
        })
            .frame(height: model.layout.height)
    }
    
    private var textFieldContentView: some View {
        UIKitTextFieldRepresentable(
            model: model.baseTextFieldModel(state: state),
            state: $state,
            placeholder: placeholder,
            text: $text,
            onBegin: beginHandler,
            onChange: changeHandler,
            onEnd: endHandler,
            onReturn: returnButtonAction
        )
            .onChange(of: text, perform: textChanged)
    }
    
    @ViewBuilder private var clearButton: some View {
        if nonEmptyText && model.clearButton {
            VCloseButton(
                model: model.clearButtonModel(state: state, highlight: highlight),
                state: state.clearButtonState,
                action: runClearAction
            )
        }
    }
    
    @ViewBuilder private var cancelButton: some View {
        if state.isFocused, nonEmptyText, let cancelButton = model.cancelButton, !cancelButton.isEmpty {
            VPlainButton(
                model: model.cancelButtonModel,
                state: state.cancelButtonState,
                action: runCancelAction,
                title: cancelButton
            )
        }
    }
    
    private var background: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .foregroundColor(model.colors.backgroundColor(state: state, highlight: highlight))
            
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.borderColor(state: state, highlight: highlight), lineWidth: model.layout.borderWidth)
        })
    }
    
    @ViewBuilder private var descriptionView: some View {
        if let description = description, !description.isEmpty {
            VBaseText(
                title: description,
                color: model.colors.descriptionColor(state: state, highlight: highlight),
                font: model.fonts.description,
                type: .multiLine(limit: nil, alignment: .leading)
            )
                .padding(.horizontal, model.layout.titleMarginHor)
                .opacity(model.colors.contentOpacity(state: state))
        }
    }
}

// MARK:- Helpers
private extension VTextField {
    func textChanged(_ text: String) {
        let shouldShow: Bool = !text.isEmpty

        let animation: Animation? = {
            switch shouldShow {
            case false: return nil
            case true: return model.clearButtonAnimation
            }
        }()

        withAnimation(animation, { nonEmptyText = shouldShow })
    }
    
    func runClearAction() {
        switch clearButtonAction {
        case .clear: zeroText()
        case .custom(let action): action()
        case .clearAndCustom(let action): zeroText(); action()
        }
    }
    
    func runCancelAction() {
        switch cancelButtonAction {
        case .clear: zeroText()
        case .custom(let action): action()
        case .clearAndCustom(let action): zeroText(); action()
        }
    }
    
    func zeroText() {
        text = ""
        withAnimation(model.clearButtonAnimation, { nonEmptyText = false })
    }
}

// MARK:- Preview
struct VTextField_Previews: PreviewProvider {
    @State private static var state: VTextFieldState = .enabled
    @State private static var text: String = "Lorem ipsum"

    static var previews: some View {
        VTextField(
            state: $state,
            placeholder: "Lorem ipsum",
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            text: $text
        )
            .padding()
    }
}
