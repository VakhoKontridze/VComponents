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
/// Textfield can be focused externally by applied `focused(_:) modifier`.
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
/// Editing states can be observed by using `onChange(of:perform:)` modifiers.
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
/// TextField can be configured as secure by passing UI model.
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
/// TextField can be configured as search by passing UI model.
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
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VTextFieldUIModel`.
@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
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
    @State private var clearButtonCanBecomeVisible: Bool = false
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
        VStack(
            alignment: .leading,
            spacing: uiModel.headerTextFieldAndFooterSpacing,
            content: {
                headerView
                inputView
                footerView
            }
        )
        
        // No need for initial checks, as secure field is always hidden by default
        .onChange(of: uiModel.contentType, perform: {
            if !$0.isSecure {
                secureFieldIsVisible = false
            }
        })
    }

    private var inputView: some View {
        HStack(spacing: uiModel.textAndButtonSpacing, content: {
            searchIcon // Only for search field
            textField
            clearButton
            visibilityButton // Only for secure field
        })
        .frame(height: uiModel.height)
        .padding(.horizontal, uiModel.contentMarginHorizontal)
        .clipped() // Prevents large content from overflowing
        .background(content: { backgroundBorderView }) // Has own rounding
        .background(content: { backgroundView }) // Has own rounding
    }

    private var textField: some View {
        SecurableTextField(
            isSecure: uiModel.contentType.isSecure && !secureFieldIsVisible,
            placeholder: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.placeholderTextColors.value(for: internalState)) // TODO: iOS 17 - Replace with `foregroundStyle(_:)`
                    .font(uiModel.placeholderTextFont)
            },
            text: $text
        )
        .textFieldStyle(.plain)

        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`

        .applyModifier({
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                $0
                    .onChange(
                        of: text,
                        initial: true,
                        { (_, newValue) in setClearButtonVisibility(newValue) }
                    )
            } else {
                $0
                    .onAppear(perform: { setClearButtonVisibility(text) })
                    .onChange(of: text, perform: setClearButtonVisibility)
            }
        })

        .multilineTextAlignment(uiModel.textAlignment)
        .lineLimit(1)
        .foregroundStyle(uiModel.textColors.value(for: internalState))
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
        .disableAutocorrection(uiModel.isAutocorrectionEnabled?.toggled())
        .applyModifier({
#if os(iOS)
            $0.textInputAutocapitalization(uiModel.autocapitalization)
#else
            $0
#endif
        })
        .submitLabel(uiModel.submitButton)
    }

    @ViewBuilder private var searchIcon: some View {
        if uiModel.contentType.isSearch {
            uiModel.searchButtonIcon
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(dimension: uiModel.searchIconDimension)
                .foregroundStyle(uiModel.searchIconColors.value(for: internalState))
        }
    }
    
    private var clearButton: some View {
        let isVisible: Bool = // Keyboard animation breaks offset when using conditional instead of opacity
            !uiModel.contentType.isSecure &&
            uiModel.hasClearButton &&
            internalState == .focused &&
            clearButtonCanBecomeVisible
        
        return VRectangularButton(
            uiModel: uiModel.clearButtonSubUIModel,
            action: didTapClearButton,
            icon: uiModel.clearButtonIcon.renderingMode(.template)
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

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .onTapGesture(perform: { isFocused = true }) // Detects gestures even on background
    }

    @ViewBuilder private var backgroundBorderView: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }

    @ViewBuilder private var headerView: some View {
        if let headerTitle, !headerTitle.isEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.headerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)

                .padding(.horizontal, uiModel.headerMarginHorizontal)
        }
    }

    @ViewBuilder private var footerView: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)

                .padding(.horizontal, uiModel.footerMarginHorizontal)
        }
    }


    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        if secureFieldIsVisible {
            uiModel.visibilityOnButtonIcon.renderingMode(.template)
        } else {
            uiModel.visibilityOffButtonIcon.renderingMode(.template)
        }
    }
    
    // MARK: Actions
    private func didTapClearButton() {
        text = ""
    }

    private func setClearButtonVisibility(_ text: String) {
        withAnimation(uiModel.clearButtonAppearDisappearAnimation, {
            clearButtonCanBecomeVisible = !text.isEmpty
        })
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
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
        .preferredColorScheme(colorScheme)
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
                                    uiModel.borderColors.enabled = uiModel.borderColors.focused
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
