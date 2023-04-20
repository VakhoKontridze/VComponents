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
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             placeholder: "Lorem ipsum",
///             text: $text
///         )
///         .padding()
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
///         .padding()
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
///         .padding()
///     }
///
/// You can apply highlights by using `success`, `warning`, and `secure` instances of `VTextFieldUIModel`.
@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS 15.0, *)@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS 8.0, *)@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
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
    
    @State private var textIsNonEmpty: Bool = false
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
                type: uiModel.layout.headerTextLineType,
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
                type: uiModel.layout.footerTextLineType,
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
        .clipped()
        .background(background)
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
                .scaledToFit()
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
        .textFieldStyle(.plain)
        
        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
        .onChange(of: text, perform: textChanged)
        
        .multilineTextAlignment(uiModel.layout.textAlignment)
        .foregroundColor(uiModel.colors.text.value(for: internalState))
        .font(uiModel.fonts.text)
        .applyModifier({
#if os(iOS)
            $0.keyboardType(uiModel.misc.keyboardType)
#else
            $0
#endif
        })
        .applyModifier({
#if os(iOS)
            $0.textContentType(uiModel.misc.textContentType)
#else
            $0
#endif
        })
        .disableAutocorrection(uiModel.misc.autocorrection.map { !$0 })
        .applyModifier({
#if os(iOS)
            $0.textInputAutocapitalization(uiModel.misc.autocapitalization)
#else
            $0
#endif
        })
        .submitLabel(uiModel.misc.submitButton)
    }
    
    private var clearButton: some View {
        let isVisible: Bool = // Keyboard animation breaks offset when using conditional instead of opacity
            !uiModel.layout.contentType.isSecure &&
            uiModel.misc.hasClearButton &&
            internalState == .focused &&
            textIsNonEmpty
        
        return VRoundedButton(
            uiModel: uiModel.clearButtonSubUIModel,
            action: didTapClearButton,
            icon: ImageBook.xMark
        )
            .opacity(isVisible ? 1 : 0)
            .allowsHitTesting(isVisible)
    }
    
    @ViewBuilder private var visibilityButton: some View {
        if uiModel.layout.contentType.isSecure {
            VPlainButton(
                uiModel: uiModel.visibilityButtonSubUIModel,
                action: { secureFieldIsVisible.toggle() },
                icon: visibilityIcon
            )
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
        withAnimation(uiModel.animations.clearButton, { textIsNonEmpty = !text.isEmpty })
    }
    
    private func didTapClearButton() {
        text = ""
        withAnimation(uiModel.animations.clearButton, { textIsNonEmpty = false })
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VTextField_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    private static var highlight: VTextFieldUIModel { .init() }
    private static var contentType: VTextFieldUIModel.Layout.ContentType { .standard }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    private static var placeholder: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    private static var text: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var text: String = VTextField_Previews.text
        
        var body: some View {
            PreviewContainer(content: {
                VTextField(
                    uiModel: {
                        var uiModel: VTextFieldUIModel = highlight
                        uiModel.layout.contentType = contentType
                        return uiModel
                    }(),
                    headerTitle: headerTitle,
                    footerTitle: footerTitle,
                    placeholder: placeholder,
                    text: $text
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(
                embeddedInScrollView: true,
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            VTextField(
                                uiModel: {
                                    var uiModel: VTextFieldUIModel = highlight
                                    uiModel.layout.contentType = contentType
                                    return uiModel
                                }(),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle,
                                placeholder: placeholder,
                                text: .constant(text)
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Focused",
                        content: {
                            VTextField(
                                uiModel: {
                                    var uiModel: VTextFieldUIModel = highlight
                                    uiModel.layout.contentType = contentType
                                    uiModel.colors.background.enabled = uiModel.colors.background.focused
                                    uiModel.colors.text.enabled = uiModel.colors.text.focused
                                    uiModel.colors.header.enabled = uiModel.colors.header.focused
                                    uiModel.colors.footer.enabled = uiModel.colors.footer.focused
                                    return uiModel
                                }(),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle,
                                placeholder: placeholder,
                                text: .constant(text)
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Pressed (Button)",
                        content: {
                            VTextField(
                                uiModel: {
                                    var uiModel: VTextFieldUIModel = highlight
                                    uiModel.layout.contentType = contentType
                                    uiModel.colors.clearButtonSubUIModel.background.enabled = uiModel.colors.clearButtonSubUIModel.background.pressed
                                    uiModel.colors.clearButtonSubUIModel.icon.enabled = uiModel.colors.clearButtonSubUIModel.icon.pressed
                                    uiModel.colors.visibilityButtonSubUIModel.icon.enabled = uiModel.colors.visibilityButtonSubUIModel.icon.pressed
                                    return uiModel
                                }(),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle,
                                placeholder: placeholder,
                                text: .constant(text)
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Disabled",
                        content: {
                            VTextField(
                                uiModel: {
                                    var uiModel: VTextFieldUIModel = highlight
                                    uiModel.layout.contentType = contentType
                                    return uiModel
                                }(),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle,
                                placeholder: placeholder,
                                text: .constant(text)
                            )
                            .disabled(true)
                        }
                    )
                    
                    PreviewSectionHeader("Native")
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            TextField(
                                placeholder,
                                text: .constant(text)
                            )
                            .textFieldStyle(.roundedBorder)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Disabled",
                        content: {
                            TextField(
                                placeholder,
                                text: .constant(text)
                            )
                            .textFieldStyle(.roundedBorder)
                            .disabled(true)
                        }
                    )
                }
            )
        }
    }
}
