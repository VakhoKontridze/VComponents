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
///                 Task(operation: {
///                     try? await Task.sleep(seconds: 1)
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
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS 16.0, *)@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
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
    @State private var _isClearButtonVisible: Bool = false
    private var isClearButtonVisible: Bool {
        uiModel.hasClearButton &&
        internalState == .focused &&
        _isClearButtonVisible
    }

    @State private var textFieldIsSecure: Bool = false

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
                textFieldIsSecure = false
            }
        })
    }

    private var inputView: some View {
        HStack(spacing: uiModel.textAndButtonSpacing, content: {
            searchIcon // Only for search field
            textField
            clearButton // Not for secure field
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
            isSecure: uiModel.contentType.isSecure && !textFieldIsSecure,
            placeholder: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.placeholderTextColors.value(for: internalState)) // TODO: iOS 17.0 - Replace with `foregroundStyle(_:)`
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
#if !(os(macOS) || os(watchOS))
            $0.keyboardType(uiModel.keyboardType)
#else
            $0
#endif
        })
        .applyModifier({
#if !(os(macOS) || os(watchOS))
            $0.textContentType(uiModel.textContentType)
#else
            $0
#endif
        })
        .disableAutocorrection(uiModel.isAutocorrectionEnabled?.toggled())
        .applyModifier({
#if !(os(macOS) || os(watchOS))
            $0.textInputAutocapitalization(uiModel.autocapitalization)
#else
            $0
#endif
        })
        .submitLabel(uiModel.submitButton)
    }

    @ViewBuilder
    private var searchIcon: some View {
        if uiModel.contentType.isSearch {
            uiModel.searchButtonIcon
                .applyIf(uiModel.isSearchIconResizable, transform: { $0.resizable() })
                .applyIfLet(uiModel.searchIconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
                .applyIfLet(uiModel.searchIconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
                .applyIfLet(uiModel.searchIconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
                .font(uiModel.searchIconFont)
                .frame(size: uiModel.searchIconSize)
        }
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if !uiModel.contentType.isSecure {
            ZStack(content: {
                VRectangularButton(
                    uiModel: uiModel.clearButtonSubUIModel,
                    action: didTapClearButton,
                    icon: uiModel.clearButtonIcon
                )
                .opacity(isClearButtonVisible ? 1 : 0)
            })
            // Occupies full height to prevent touches from accidentally focusing the TextField
            .frame(maxHeight: .infinity)
            .background(content: { Color.clear.contentShape(.rect) })
        }
    }
    
    @ViewBuilder 
    private var visibilityButton: some View {
        if uiModel.contentType.isSecure {
            ZStack(content: {
                VPlainButton(
                    uiModel: uiModel.visibilityButtonSubUIModel,
                    action: { textFieldIsSecure.toggle() },
                    icon: visibilityIcon
                )
            })
            // Occupies full height to prevent touches from accidentally focusing the TextField
            .frame(maxHeight: .infinity)
            .background(content: { Color.clear.contentShape(.rect) })
        }
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .onTapGesture(perform: { isFocused = true }) // Detects gestures even on background
    }

    @ViewBuilder
    private var backgroundBorderView: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }

    @ViewBuilder 
    private var headerView: some View {
        if let headerTitle, !headerTitle.isEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.headerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.headerTitleTextFrameAlignment,
                        vertical: .center
                    )
                )

                .padding(.horizontal, uiModel.headerMarginHorizontal)
        }
    }

    @ViewBuilder 
    private var footerView: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.footerTitleTextFrameAlignment,
                        vertical: .center
                    )
                )

                .padding(.horizontal, uiModel.footerMarginHorizontal)
        }
    }


    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        if textFieldIsSecure {
            uiModel.visibilityOnButtonIcon
        } else {
            uiModel.visibilityOffButtonIcon
        }
    }

    // MARK: Actions
    private func didTapClearButton() {
        text = ""
    }

    private func setClearButtonVisibility(_ text: String) {
        withAnimation(uiModel.clearButtonAppearDisappearAnimation, {
            _isClearButtonVisible = !text.isEmpty
        })
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var text: String = "Lorem ipsum"

        var body: some View {
            PreviewContainer(content: {
                VTextField(
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: $text
                )
                .padding(.horizontal)
            })
        }
    }

    return ContentView()
})

#Preview("Content Types", body: {
    struct ContentView: View {
        @State private var text: String = "Lorem ipsum"

        var body: some View {
            PreviewContainer(content: {
                ForEach(
                    VTextFieldUIModel.ContentType.allCases,
                    id: \.self,
                    content: { contentType in
                        let title: String = .init(describing: contentType).capitalized

                        PreviewRow(title, content: {
                            VTextField(
                                uiModel: {
                                    var uiModel: VTextFieldUIModel = .init()
                                    uiModel.contentType = contentType
                                    return uiModel
                                }(),
                                placeholder: "Lorem ipsum",
                                text: $text
                            )
                            .padding(.horizontal)
                        })
                    }
                )
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    Preview_StatesContentView()
})

#Preview("Success", body: {
    Preview_StatesContentView(
        uiModel: .success,
        showsNative: false
    )
})

#Preview("Warning", body: {
    Preview_StatesContentView(
        uiModel: .warning,
        showsNative: false
    )
})

#Preview("Error", body: {
    Preview_StatesContentView(
        uiModel: .error,
        showsNative: false
    )
})

private struct Preview_StatesContentView: View {
    private let uiModel: VTextFieldUIModel
    private let showsNative: Bool

    init(
        uiModel: VTextFieldUIModel = .init(),
        showsNative: Bool = true
    ) {
        self.uiModel = uiModel
        self.showsNative = showsNative
    }

    var body: some View {
        PreviewContainer(content: {
            PreviewRow("Enabled", content: {
                VTextField(
                    uiModel: uiModel,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            })

            PreviewRow("Focused", content: {
                VTextField(
                    uiModel: {
                        var mappedUIModel: VTextFieldUIModel = uiModel
                        mappedUIModel.backgroundColors.enabled = uiModel.backgroundColors.focused
                        mappedUIModel.borderColors.enabled = uiModel.borderColors.focused
                        mappedUIModel.textColors.enabled = uiModel.textColors.focused
                        mappedUIModel.headerTitleTextColors.enabled = uiModel.headerTitleTextColors.focused
                        mappedUIModel.footerTitleTextColors.enabled = uiModel.footerTitleTextColors.focused
                        return mappedUIModel
                    }(),
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            })

            PreviewRow("Pressed (Button) (*)", content: {
                VTextField(
                    uiModel: {
                        var mappedUIModel: VTextFieldUIModel = uiModel
                        mappedUIModel.clearButtonSubUIModel.backgroundColors.enabled = uiModel.clearButtonSubUIModel.backgroundColors.pressed
                        mappedUIModel.clearButtonSubUIModel.iconColors!.enabled = uiModel.clearButtonSubUIModel.iconColors!.pressed // Force-unwrap
                        mappedUIModel.visibilityButtonSubUIModel.iconColors!.enabled = uiModel.visibilityButtonSubUIModel.iconColors!.pressed // Force-unwrap
                        return mappedUIModel
                    }(),
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            })

            PreviewRow("Disabled", content: {
                VTextField(
                    uiModel: uiModel,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .disabled(true)
                .padding(.horizontal)
            })

            if showsNative {
                PreviewHeader("Native")

                PreviewRow("Enabled", content: {
                    TextField(
                        "Lorem ipsum",
                        text: .constant("Lorem ipsum")
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                })

                PreviewRow("Disabled", content: {
                    TextField(
                        "Lorem ipsum",
                        text: .constant("Lorem ipsum")
                    )
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                    .padding(.horizontal)
                })
            }
        })
    }
}

#endif

#endif
