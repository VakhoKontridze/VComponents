//
//  VTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

/// Input component that displays an editable text interface.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
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
///             .onFirstAppear) {
///                 Task { @MainActor in
///                     try await Task.sleep(for: .seconds(1))
///                     isFocused = true
///                 }
///             }
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
///             .onChange(of: text) { _ in print("Editing Changed") }
///             .onChange(of: isFocused) {
///                 if $0 {
///                     print("Editing Began")
///                 } else {
///                     print("Editing Ended")
///                 }
///             }
///             .onSubmit { print("Submitted") }
///     }
///
/// TextField can be configured as secure by passing Appearance.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
///             appearance: .secure,
///             text: $text
///         )
///         .padding()
///     }
///
/// TextField can be configured as search by passing Appearance.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextField(
///             appearance: .search,
///             text: $text
///         )
///         .padding()
///     }
///
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VTextFieldAppearance`.
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VTextField: View {
    // MARK: Properties - Appearance
    private let appearance: VTextFieldAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextFieldInternalState {
        .init(
            isEnabled: isEnabled,
            isFocused: isFocused
        )
    }

    // MARK: Properties - Texts
    private let placeholder: String?
    @Binding private var text: String

    // MARK: Properties - Clear Button
    @State private var _isClearButtonVisible: Bool = false
    
    private var isClearButtonVisible: Bool {
        appearance.hasClearButton &&
        internalState == .focused &&
        _isClearButtonVisible
    }

    // MARK: Properties - Secure Field
    @State private var isSecureTextFieldContentRevealed: Bool = false
    
    private var isTextFieldSecure: Bool {
        appearance.style == .secure &&
        !isSecureTextFieldContentRevealed
    }

    // MARK: Initializers
    /// Initializes `VTextField` with text.
    public init(
        appearance: VTextFieldAppearance = .init(),
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.appearance = appearance
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: Body
    public var body: some View {
        HStack(spacing: appearance.contentSpacingHorizontal) {
            searchImage
            _textField
            clearButton
            visibilityButton
        }
        .frame(height: appearance.height)
        .padding(.horizontal, appearance.contentMarginHorizontal)
        .background { borderView }
        .background { backgroundView }
        .clipShape(.rect(cornerRadius: appearance.cornerRadius))
        
        .onChange(of: appearance.style) { (_, newValue) in // No need for initial checks, as secure field is always hidden by default
            if newValue != .secure {
                isSecureTextFieldContentRevealed = false
            }
        }
        .onChange(of: text, initial: true) { setClearButtonVisibility($1) }
    }

    private var _textField: some View {
        SecurableTextField(
            isSecure: isTextFieldSecure,
            placeholder: placeholder.map {
                Text($0)
                    //.lineLimit(1)
                    //.minimumScaleFactor(1)
                    .foregroundStyle(appearance.placeholderTextColors.value(for: internalState))
                    .font(appearance.placeholderTextFont)
                    //.applyIfLet(appearance.placeholderTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) } // Cannot be applied to placeholder only
            },
            text: $text
        )
        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
        .textFieldStyle(.plain)
        .multilineTextAlignment(appearance.textAlignment)
        .lineLimit(1)
        //.minimumScaleFactor(1)
        .foregroundStyle(appearance.textColors.value(for: internalState))
        .font(appearance.textFont)
        .applyIfLet(appearance.textDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
#if !(os(macOS) || os(watchOS))
        .keyboardType(appearance.keyboardType)
#endif
#if !(os(macOS) || os(watchOS))
        .textContentType(appearance.textContentType)
#endif
        .disableAutocorrection(appearance.isAutocorrectionEnabled?.toggled())
#if !(os(macOS) || os(watchOS))
        .textInputAutocapitalization(appearance.autocapitalization)
#endif
        .submitLabel(appearance.submitButton)
    }

    @ViewBuilder
    private var searchImage: some View {
        if appearance.style.hasSearchImage {
            appearance.searchImage
                .applyIf(appearance.isSearchImageResizable) { $0.resizable() }
                .applyIfLet(appearance.searchImageContentMode) { $0.aspectRatio(nil, contentMode: $1) }
                .frame(size: appearance.searchImageSize)
                .applyIfLet(appearance.searchImageColors) { $0.foregroundStyle($1.value(for: internalState)) }
                .applyIfLet(appearance.searchImageOpacities) { $0.opacity($1.value(for: internalState)) }
                .font(appearance.searchImageFont)
                .applyIfLet(appearance.searchImageDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
        }
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if appearance.style.hasClearButton {
            ZStack {
                VRectangularButton(
                    appearance: appearance.clearButtonAppearance,
                    action: didTapClearButton,
                    image: appearance.clearButtonImage
                )
                .opacity(isClearButtonVisible ? 1 : 0)
            }
            // Occupies full height to prevent touches from accidentally focusing the TextField
            .frame(maxHeight: .infinity)
            .background { Color.clear.contentShape(.rect) }
        }
    }
    
    @ViewBuilder 
    private var visibilityButton: some View {
        if appearance.style.hasVisibilityButton {
            ZStack {
                VPlainButton(
                    appearance: appearance.visibilityButtonAppearance,
                    action: { isSecureTextFieldContentRevealed.toggle() },
                    image: visibilityImage
                )
            }
            // Occupies full height to prevent touches from accidentally focusing the TextField
            .frame(maxHeight: .infinity)
            .background { Color.clear.contentShape(.rect) }
        }
    }

    private var backgroundView: some View {
        Rectangle()
            .foregroundStyle(appearance.backgroundColors.value(for: internalState))
            .onTapGesture { isFocused = true } // Detects gestures even on background
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }

    // MARK: Visibility Image
    private var visibilityImage: Image {
        if isSecureTextFieldContentRevealed {
            appearance.visibilityOnButtonImage
        } else {
            appearance.visibilityOffButtonImage
        }
    }

    // MARK: Actions
    private func didTapClearButton() {
        text = ""
    }

    private func setClearButtonVisibility(_ text: String) {
        withAnimation(appearance.clearButtonAppearDisappearAnimation) {
            _isClearButtonVisible = !text.isEmpty
        }
    }
}

#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var text: String = "Lorem ipsum"

    PreviewContainer {
        VTextField(
            placeholder: "Lorem ipsum",
            text: $text
        )
        .padding(.horizontal)
    }
}

#Preview("Styles") {
    @Previewable @State var text: String = "Lorem ipsum"

    PreviewContainer {
        ForEach(
            VTextFieldAppearance.Style.allCases,
            id: \.self
        ) { style in
            let title: String = .init(describing: style).capitalized

            PreviewRow(title) {
                VTextField(
                    appearance: {
                        var appearance: VTextFieldAppearance = .init()
                        appearance.style = style
                        return appearance
                    }(),
                    placeholder: "Lorem ipsum",
                    text: $text
                )
                .padding(.horizontal)
            }
        }
    }
}

#Preview("States") {
    StatesContentView()
}

#Preview("Success") {
    StatesContentView(
        appearance: .success,
        showsNative: false
    )
}

#Preview("Warning") {
    StatesContentView(
        appearance: .warning,
        showsNative: false
    )
}

#Preview("Error") {
    StatesContentView(
        appearance: .error,
        showsNative: false
    )
}

private struct StatesContentView: View {
    // MARK: Properties
    private let appearance: VTextFieldAppearance
    private let showsNative: Bool

    // MARK: Initializers
    init(
        appearance: VTextFieldAppearance = .init(),
        showsNative: Bool = true
    ) {
        self.appearance = appearance
        self.showsNative = showsNative
    }

    // MARK: Body
    var body: some View {
        PreviewContainer {
            PreviewRow("Enabled") {
                VTextField(
                    appearance: appearance,
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            }

            PreviewRow("Focused") {
                VTextField(
                    appearance: {
                        var mappedAppearance: VTextFieldAppearance = appearance
                        mappedAppearance.backgroundColors.enabled = appearance.backgroundColors.focused
                        mappedAppearance.borderColors.enabled = appearance.borderColors.focused
                        mappedAppearance.textColors.enabled = appearance.textColors.focused
                        return mappedAppearance
                    }(),
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            }

            PreviewRow("Pressed (Button) (*)") {
                VTextField(
                    appearance: {
                        var mappedAppearance: VTextFieldAppearance = appearance
                        mappedAppearance.clearButtonAppearance.backgroundColors.enabled = appearance.clearButtonAppearance.backgroundColors.pressed
                        mappedAppearance.clearButtonAppearance.labelImageColors!.enabled = appearance.clearButtonAppearance.labelImageColors!.pressed // Force-unwrap
                        mappedAppearance.visibilityButtonAppearance.labelImageColors!.enabled = appearance.visibilityButtonAppearance.labelImageColors!.pressed // Force-unwrap
                        return mappedAppearance
                    }(),
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            }

            PreviewRow("Disabled") {
                VTextField(
                    appearance: appearance,
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .disabled(true)
                .padding(.horizontal)
            }

            if showsNative {
                PreviewHeader("Native")

                PreviewRow("Enabled") {
                    TextField(
                        "Lorem ipsum",
                        text: .constant("Lorem ipsum")
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                }

                PreviewRow("Disabled") {
                    TextField(
                        "Lorem ipsum",
                        text: .constant("Lorem ipsum")
                    )
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#endif

#endif
