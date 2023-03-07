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
/// UI Model, placeholder, header, and footer can be passed as parameters.
///
/// By default, component type is `standard`.
/// If `secure` type is used, visibility button would replace clear button. When textfield is secure and text is empty, and buttons are not visible.
/// If `search` type is used, a magnification glass icon would appear on the left.
///
///     @State private var text: String = ""
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
///     @FocusState private var isFocused: Bool
///     @State private var text: String = ""
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
///                 if $0 {
///                     print("Editing Began")
///                 } else {
///                     print("Editing Ended")
///                 }
///             })
///             .onSubmit({ print("Submitted") })
///     }
///
/// `Secure` textfield:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
///             uiModel: .secure,
///             text: $text
///         )
///             .padding()
///     }
///
/// `Search` textfield:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
///             uiModel: .search,
///             text: $text
///         )
///             .padding()
///     }
///
/// Success textfield:
///
///     @State private var text: String = ""
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
///     @State private var text: String = ""
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
///     @State private var text: String = ""
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
    /// Initializes `VTextField` with text.
    public init(
        uiModel: VTextFieldUIModel = .init(),
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.uiModel = uiModel
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.placeholder = placeholder
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
                type: uiModel.layout.headerTitleLineType,
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
                type: uiModel.layout.footerTitleLineType,
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
            .background(content: { background })
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
        if uiModel.layout.contentType.isSearch {
            ImageBook.textFieldSearch
                .resizable()
                .frame(dimension: uiModel.layout.searchIconDimension)
                .foregroundColor(uiModel.colors.searchIcon.value(for: internalState))
        }
    }

    private var textField: some View {
        SecurableTextField(
            isSecure: uiModel.layout.contentType.isSecure && !secureFieldIsVisible,
            placeholder: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.colors.placeholder.value(for: internalState))
                    .font(uiModel.fonts.placeholder)
            },
            text: $text
        )
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .onChange(of: text, perform: textChanged)
        
            .multilineTextAlignment(uiModel.layout.textAlignment)
            .foregroundColor(uiModel.colors.text.value(for: internalState))
            .font(uiModel.fonts.text)
            .keyboardType(uiModel.misc.keyboardType)
            .textContentType(uiModel.misc.textContentType)
            .disableAutocorrection(uiModel.misc.autocorrection.map { !$0 })
            .textInputAutocapitalization(uiModel.misc.autocapitalization)
            .submitLabel(uiModel.misc.submitButton)
    }

    @ViewBuilder private var clearButton: some View {
        if !uiModel.layout.contentType.isSecure && clearButtonIsVisible && uiModel.misc.hasClearButton {
            VRoundedButton(
                uiModel: uiModel.clearButtonSubUIModel,
                action: didTapClearButton,
                icon: ImageBook.xMark
            )
                .disabled(!internalState.isEnabled)
        }
    }

    @ViewBuilder private var visibilityButton: some View {
        if uiModel.layout.contentType.isSecure {
            VPlainButton(
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
            if secureFieldIsVisible && !uiModel.layout.contentType.isSecure { secureFieldIsVisible = false }
        })
    }

    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        if secureFieldIsVisible {
            return ImageBook.textFieldVisibilityOn
        } else {
            return ImageBook.textFieldVisibilityOff
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
    static var previews: some View {
        Preview()
    }
    
    private struct Preview: View {
        @State private var text: String = "Lorem ipsum"
        
        var body: some View {
            VStack(spacing: 50, content: {
                ForEach(VTextFieldUIModel.Layout.ContentType.allCases, id: \.self, content: { contentType in
                    VTextField(
                        uiModel: {
                            var uiModel: VTextFieldUIModel = .init()
                            uiModel.layout.contentType = contentType
                            return uiModel
                        }(),
                        headerTitle: "Lorem ipsum dolor sit amet",
                        footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                        placeholder: "Lorem ipsum",
                        text: $text
                    )
                })
            })
                .padding()
        }
    }
}
