//
//  VTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Text Field
/// Input component that displays an editable text interface.
///
/// Model, type, palceholder, header, and footer can be passed as parameters.
///
/// By default, component type is `standard`.
/// If `secure` type is used, visiblity button would replace clear button. When textfield is secure and text is empty, and buttons are not visible.
/// If `search` type is used, a magnification glass icon would appear on the left.
///
/// Usage example:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             placeholder: "Lorem ipsum",
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             text: $text
///         )
///             .padding()
///     }
///
/// Textfield can also be focused externally by passing state:
///
///     @FocusState var isFocused: Bool
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(text: $text)
///             .padding()
///
///             .focused($isFocused)
///             .onAppear(perform: {
///                 DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
///                     isFocused = true
///                 })
///             })
///     }
///
/// Editing states can be observed by using `onChange` `View` modifiers.
///
///     @FocusState private var isFocused: Bool
///     @State private var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(text: $text)
///             .padding()
///
///             .focused($isFocused)
///             .onChange(of: text, perform: { _ in print("Ediging Changed") })
///             .onChange(of: isFocused, perform: {
///                 switch $0 {
///                 case false: print("Ediging Ended")
///                 case true: print("Ediging Began")
///                 }
///             })
///             .onSubmit({ print("Submitted") })
///     }
///
/// `Secure` textfield:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             type: .securem
///             text: $text
///         )
///             .padding()
///     }
///
/// `Search` textfield:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             type: .search,
///             text: $text
///         )
///             .padding()
///     }
///
/// Success textfield:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             model: .success,
///             text: $text
///         )
///             .padding()
///     }
///
/// Warning textfield:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             model: .warning,
///             text: $text
///         )
///             .padding()
///     }
///
/// Error textfield:
///
///     @State var text: String = "Lorem ipsum"
///
///     var body: some View {
///         VTextField(
///             model: .error,
///             text: $text
///         )
///             .padding()
///     }
///
public struct VTextField: View {
    // MARK: Properties
    private let model: VTextFieldModel
    private let textFieldType: VTextFieldType

    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextFieldInternalState { .init(isEnabled: isEnabled, isFocused: isFocused) }

    private let headerTitle: String?
    private let footerTitle: String?
    
    private let placeholder: String?
    @Binding private var text: String
    
    @State private var clearButtonIsVisible: Bool = false
    @State private var secureFieldIsVisible: Bool = false

    // MARK: Initialiers
    /// Initializes component with title.
    public init(
        model: VTextFieldModel = .init(),
        type textFieldType: VTextFieldType = .default,
        placeholder: String? = nil,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        text: Binding<String>
    ) {
        self.model = model
        self.textFieldType = textFieldType
        self.placeholder = placeholder
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self._text = text
    }

    // MARK: Body
    public var body: some View {
        syncInternalStateWithState()

        return VStack(alignment: .leading, spacing: model.layout.headerFooterSpacing, content: {
            header
            input
            footer
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                color: model.colors.header.for(internalState),
                font: model.fonts.header,
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerFooterMarginHorizontal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, limit: nil),
                color: model.colors.footer.for(internalState),
                font: model.fonts.footer,
                title: footerTitle
            )
                .padding(.horizontal, model.layout.headerFooterMarginHorizontal)
        }
    }
    
    private var input: some View {
        HStack(spacing: model.layout.contentSpacing, content: {
            searchIcon // Only for search field
            textField
            clearButton
            visibilityButton // Only for secure field
        })
            .padding(.horizontal, model.layout.contentMarginHorizontal)
            .frame(height: model.layout.height)
            .background(background)
            .frame(height: model.layout.height)
    }
    
    private var background: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .foregroundColor(model.colors.background.for(internalState))

            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWidth)
        })
    }

    @ViewBuilder private var searchIcon: some View {
        if textFieldType.isSearch {
            ImageBook.search
                .resizable()
                .frame(dimension: model.layout.searchIconDimension)
                .foregroundColor(model.colors.searchIcon.for(internalState))
        }
    }

    private var textField: some View {
        SecurableTextField(
            isSecure: textFieldType.isSecure && !secureFieldIsVisible,
            text: $text,
            placeholder: placeholder
        )
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .onChange(of: text, perform: textChanged)
        
            .multilineTextAlignment(model.layout.textAlignment)
            .foregroundColor(model.colors.text.for(internalState))
            .font({
                switch text.isEmpty {
                case false: return model.fonts.text
                case true: return model.fonts.placeholder
                }
            }())
            .keyboardType(model.misc.keyboardType)
            .textContentType(model.misc.textContentType)
            .disableAutocorrection(model.misc.autocorrection.map { !$0 })
            .textInputAutocapitalization(model.misc.autocapitalization)
            .submitLabel(model.misc.submitButton)
    }

    @ViewBuilder private var clearButton: some View {
        if !textFieldType.isSecure && clearButtonIsVisible && model.misc.clearButton {
            VSquareButton.close(
                model: model.clearButtonSubModel,
                action: didTapClearButton
            )
                .disabled(!internalState.isEnabled)
        }
    }

    @ViewBuilder private var visibilityButton: some View {
        if textFieldType.isSecure {
            VSquareButton(
                model: model.visibilityButtonSubModel,
                action: { secureFieldIsVisible.toggle() },
                icon: visiblityIcon
            )
                .disabled(!internalState.isEnabled)
        }
    }

    // MARK: State Syncs
    private func syncInternalStateWithState() {
        DispatchQueue.main.async(execute: {
            textChanged(text)
        })

        DispatchQueue.main.async(execute: {
            if secureFieldIsVisible && !textFieldType.isSecure { secureFieldIsVisible = false }
        })
    }

    // MARK: Visiblity Icon
    private var visiblityIcon: Image {
        switch secureFieldIsVisible {
        case false: return ImageBook.visibilityOff
        case true: return ImageBook.visibilityOn
        }
    }

    // MARK: Actions
    private func textChanged(_ text: String) {
        withAnimation(model.animations.clearButton, { clearButtonIsVisible = !text.isEmpty })
    }

    private func didTapClearButton() {
        text = ""
        withAnimation(model.animations.clearButton, { clearButtonIsVisible = false })
    }
}

// MARK: - Preview
struct VTextField_Previews: PreviewProvider {
    @State private static var text: String = "Lorem ipsum"

    static var previews: some View {
        VStack(spacing: 50, content: {
            ForEach(VTextFieldType.allCases, id: \.self, content: { type in
                VTextField(
                    type: type,
                    placeholder: "Lorem ipsum",
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    text: $text
                )
            })
        })
            .padding()
    }
}
