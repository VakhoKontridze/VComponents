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
    // MARK: Properties - UI Model
    private let uiModel: VTextFieldUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextFieldInternalState {
        .init(
            isEnabled: isEnabled,
            isFocused: isFocused
        )
    }

    // MARK: Properties - Header & Footer
    private let headerTitle: String?
    private let footerTitle: String?

    // MARK: Properties - Texts
    private let placeholder: String?
    @Binding private var text: String

    // MARK: Properties - Flags
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
        
        return VStack(
            alignment: .leading,
            spacing: uiModel.headerTextFieldAndFooterSpacing,
            content: {
                header
                input
                footer
            }
        )
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.headerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)

                .padding(.horizontal, uiModel.headerMarginHorizontal)
        }
    }
    
    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)

                .padding(.horizontal, uiModel.footerMarginHorizontal)
        }
    }
    
    private var input: some View {
        HStack(spacing: uiModel.textAndButtonSpacing, content: {
            searchIcon // Only for search field
            textField
            clearButton
            visibilityButton // Only for secure field
        })
        .frame(height: uiModel.height)
        .padding(.horizontal, uiModel.contentMarginHorizontal)
        .clipped() // Prevents large content from overflowing
        .background(backgroundBorder) // Has own rounding
        .background(background) // Has own rounding
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundColor(uiModel.backgroundColors.value(for: internalState))
    }

    @ViewBuilder private var backgroundBorder: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }
    
    @ViewBuilder private var searchIcon: some View {
        if uiModel.contentType.isSearch {
            ImageBook.textFieldSearch
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(dimension: uiModel.searchIconDimension)
                .foregroundColor(uiModel.searchIconColors.value(for: internalState))
        }
    }
    
    private var textField: some View {
        SecurableTextField(
            isSecure: uiModel.contentType.isSecure && !secureFieldIsVisible,
            placeholder: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.placeholderTextColors.value(for: internalState))
                    .font(uiModel.placeholderTextFont)
            },
            text: $text
        )
        .textFieldStyle(.plain)
        
        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
        .onChange(of: text, perform: textChanged)

        .multilineTextAlignment(uiModel.textAlignment)
        .lineLimit(1)
        .foregroundColor(uiModel.textColors.value(for: internalState))
        .font(uiModel.textFont)
        .applyModifier({
#if os(iOS)
            $0.keyboardType(uiModel.keyboardType)
#else
            $0
#endif
        })
        .applyModifier({
#if os(iOS)
            $0.textContentType(uiModel.textContentType)
#else
            $0
#endif
        })
        .disableAutocorrection(uiModel.autocorrection.map { !$0 })
        .applyModifier({
#if os(iOS)
            $0.textInputAutocapitalization(uiModel.autocapitalization)
#else
            $0
#endif
        })
        .submitLabel(uiModel.submitButton)
    }
    
    private var clearButton: some View {
        let isVisible: Bool = // Keyboard animation breaks offset when using conditional instead of opacity
            !uiModel.contentType.isSecure &&
            uiModel.hasClearButton &&
            internalState == .focused &&
            textIsNonEmpty
        
        return VRoundedButton(
            uiModel: uiModel.clearButtonSubUIModel,
            action: didTapClearButton,
            icon: ImageBook.xMark.renderingMode(.template)
        )
        .opacity(isVisible ? 1 : 0)
        .allowsHitTesting(isVisible)
    }
    
    @ViewBuilder private var visibilityButton: some View {
        if uiModel.contentType.isSecure {
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
            if secureFieldIsVisible && !uiModel.contentType.isSecure { secureFieldIsVisible = false }
        })
    }
    
    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        if secureFieldIsVisible {
            return ImageBook.textFieldVisibilityOn
                .renderingMode(.template)
        } else {
            return ImageBook.textFieldVisibilityOff
                .renderingMode(.template)
        }
    }
    
    // MARK: Actions
    private func textChanged(_ text: String) {
        withAnimation(uiModel.clearButtonAppearDisappearAnimation, { textIsNonEmpty = !text.isEmpty })
    }
    
    private func didTapClearButton() {
        text = ""
        withAnimation(uiModel.clearButtonAppearDisappearAnimation, { textIsNonEmpty = false })
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
    private static var contentType: VTextFieldUIModel.ContentType { .standard }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
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
                        uiModel.contentType = contentType
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
                                    uiModel.contentType = contentType
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
                                    uiModel.contentType = contentType
                                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.focused
                                    uiModel.textColors.enabled = uiModel.textColors.focused
                                    uiModel.headerTitleTextColors.enabled = uiModel.headerTitleTextColors.focused
                                    uiModel.footerTitleTextColors.enabled = uiModel.footerTitleTextColors.focused
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
                                    uiModel.contentType = contentType
                                    uiModel.clearButtonSubUIModel.backgroundColors.enabled = uiModel.clearButtonSubUIModel.backgroundColors.pressed
                                    uiModel.clearButtonSubUIModel.iconColors.enabled = uiModel.clearButtonSubUIModel.iconColors.pressed
                                    uiModel.visibilityButtonSubUIModel.iconColors.enabled = uiModel.visibilityButtonSubUIModel.iconColors.pressed
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
                                    uiModel.contentType = contentType
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

    private struct OutOfBoundsContentPreventionPreview: View {
        @State private var text: String = VTextField_Previews.text

        var body: some View {
            PreviewContainer(content: {
                VTextField(
                    uiModel: {
                        var uiModel: VTextFieldUIModel = .search
                        uiModel.searchIconDimension = 100
                        uiModel.textFont = .system(size: 100)
                        return uiModel
                    }(),
                    text: $text
                )
                .padding()
            })
        }
    }
}
