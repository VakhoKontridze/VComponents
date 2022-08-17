//
//  VTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Text Field
/// Input component that displays an editable text interface.
///
/// UI Model, type, placeholder, header, and footer can be passed as parameters.
///
/// By default, component type is `standard`.
/// If `secure` type is used, visibility button would replace clear button. When textfield is secure and text is empty, and buttons are not visible.
/// If `search` type is used, a magnification glass icon would appear on the left.
///
///     @State var text: String = ""
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
///     @State var text: String = ""
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
///             .onChange(of: text, perform: { _ in print("Editing Changed") })
///             .onChange(of: isFocused, perform: {
///                 switch $0 {
///                 case false: print("Editing Ended")
///                 case true: print("Editing Began")
///                 }
///             })
///             .onSubmit({ print("Submitted") })
///     }
///
/// `Secure` textfield:
///
///     @State var text: String = ""
///
///     var body: some View {
///         VTextField(
///             type: .secure,
///             text: $text
///         )
///             .padding()
///     }
///
/// `Search` textfield:
///
///     @State var text: String = ""
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
///     @State var text: String = ""
///
///     var body: some View {
///         VTextField(
///             uiModel: .success,
///             text: $text
///         )
///             .padding()
///     }
///
/// Warning textfield:
///
///     @State var text: String = ""
///
///     var body: some View {
///         VTextField(
///             uiModel: .warning,
///             text: $text
///         )
///             .padding()
///     }
///
/// Error textfield:
///
///     @State var text: String = ""
///
///     var body: some View {
///         VTextField(
///             uiModel: .error,
///             text: $text
///         )
///             .padding()
///     }
///
public struct VTextField: View {
    // MARK: Properties
    private let uiModel: VTextFieldUIModel
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

    // MARK: Initializers
    /// Initializes component with title.
    public init(
        uiModel: VTextFieldUIModel = .init(),
        type textFieldType: VTextFieldType = .default,
        placeholder: String? = nil,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        text: Binding<String>
    ) {
        self.uiModel = uiModel
        self.textFieldType = textFieldType
        self.placeholder = placeholder
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self._text = text
    }

    // MARK: Body
    public var body: some View {
        syncInternalStateWithState()

        return VStack(alignment: .leading, spacing: uiModel.layout.headerTextFieldFooterSpacing, content: {
            header
            input
            footer
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            VText(
                type: uiModel.layout.headerTitleType,
                color: uiModel.colors.header.value(for: internalState),
                font: uiModel.fonts.header,
                text: headerTitle
            )
                .padding(.horizontal, uiModel.layout.headerFooterMarginHorizontal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            VText(
                type: uiModel.layout.footerTitleType,
                color: uiModel.colors.footer.value(for: internalState),
                font: uiModel.fonts.footer,
                text: footerTitle
            )
                .padding(.horizontal, uiModel.layout.headerFooterMarginHorizontal)
        }
    }
    
    private var input: some View {
        HStack(spacing: uiModel.layout.contentSpacing, content: {
            searchIcon // Only for search field
            textField
            clearButton
            visibilityButton // Only for secure field
        })
            .padding(.horizontal, uiModel.layout.contentMarginHorizontal)
            .frame(height: uiModel.layout.height)
            .background(background)
            .frame(height: uiModel.layout.height)
    }
    
    private var background: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .foregroundColor(uiModel.colors.background.value(for: internalState))

            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        })
    }

    @ViewBuilder private var searchIcon: some View {
        if textFieldType.isSearch {
            ImageBook.textFieldSearch
                .resizable()
                .frame(dimension: uiModel.layout.searchIconDimension)
                .foregroundColor(uiModel.colors.searchIcon.value(for: internalState))
        }
    }

    private var textField: some View {
        SecurableTextField(
            isSecure: textFieldType.isSecure && !secureFieldIsVisible,
            placeholder: placeholder,
            text: $text
        )
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .onChange(of: text, perform: textChanged)
        
            .multilineTextAlignment(uiModel.layout.textAlignment)
            .foregroundColor(uiModel.colors.text.value(for: internalState))
            .font({
                switch text.isEmpty {
                case false: return uiModel.fonts.text
                case true: return uiModel.fonts.placeholder
                }
            }())
            .keyboardType(uiModel.misc.keyboardType)
            .textContentType(uiModel.misc.textContentType)
            .disableAutocorrection(uiModel.misc.autocorrection.map { !$0 })
            .textInputAutocapitalization(uiModel.misc.autocapitalization)
            .submitLabel(uiModel.misc.submitButton)
    }

    @ViewBuilder private var clearButton: some View {
        if !textFieldType.isSecure && clearButtonIsVisible && uiModel.misc.hasClearButton {
            VRoundedButton.close(
                uiModel: uiModel.clearButtonSubUIModel,
                action: didTapClearButton
            )
                .disabled(!internalState.isEnabled)
        }
    }

    @ViewBuilder private var visibilityButton: some View {
        if textFieldType.isSecure {
            VRoundedButton(
                uiModel: uiModel.visibilityButtonSubUIModel,
                action: { secureFieldIsVisible.toggle() },
                icon: visibilityIcon
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

    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        switch secureFieldIsVisible {
        case false: return ImageBook.textFieldVisibilityOff
        case true: return ImageBook.textFieldVisibilityOn
        }
    }

    // MARK: Actions
    private func textChanged(_ text: String) {
        withAnimation(uiModel.animations.clearButton, { clearButtonIsVisible = !text.isEmpty })
    }

    private func didTapClearButton() {
        text = ""
        withAnimation(uiModel.animations.clearButton, { clearButtonIsVisible = false })
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
