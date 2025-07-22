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

    // MARK: Properties - Header & Footer
    private let headerTitle: String?
    private let footerTitle: String?

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
        appearance.contentType == .secure &&
        !isSecureTextFieldContentRevealed
    }

    // MARK: Initializers
    /// Initializes `VTextField` with text.
    public init(
        appearance: VTextFieldAppearance = .init(),
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.appearance = appearance
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: Body
    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: appearance.headerAndTextFieldAndFooterSpacing,
        ) {
            headerView
            textField
            footerView
        }
        // No need for initial checks, as secure field is always hidden by default
        .onChange(of: appearance.contentType) { (_, newValue) in
            if newValue != .secure {
                isSecureTextFieldContentRevealed = false
            }
        }
    }

    private var textField: some View {
        HStack(spacing: appearance.textFieldContentSpacingHorizontal) {
            searchIcon
            _textField
            clearButton
            visibilityButton
        }
        .frame(height: appearance.height)
        .padding(.horizontal, appearance.textFieldContentMarginHorizontal)
        .background { borderView }
        .background { backgroundView }
        .clipShape(.rect(cornerRadius: appearance.cornerRadius))
    }

    private var _textField: some View {
        SecurableTextField(
            isSecure: isTextFieldSecure,
            placeholder: placeholder.map {
                Text($0)
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
        
        .onChange(of: text, initial: true) { setClearButtonVisibility($1) }
    }

    @ViewBuilder
    private var searchIcon: some View {
        if appearance.contentType.hasSearchIcon {
            appearance.searchButtonIcon
                .applyIf(appearance.isSearchIconResizable) { $0.resizable() }
                .applyIfLet(appearance.searchIconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
                .applyIfLet(appearance.searchIconColors) { $0.foregroundStyle($1.value(for: internalState)) }
                .applyIfLet(appearance.searchIconOpacities) { $0.opacity($1.value(for: internalState)) }
                .font(appearance.searchIconFont)
                .applyIfLet(appearance.searchIconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                .frame(size: appearance.searchIconSize)
        }
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if appearance.contentType.hasClearButton {
            ZStack {
                VRectangularButton(
                    appearance: appearance.clearButtonAppearance,
                    action: didTapClearButton,
                    icon: appearance.clearButtonIcon
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
        if appearance.contentType.hasVisibilityButton {
            ZStack {
                VPlainButton(
                    appearance: appearance.visibilityButtonAppearance,
                    action: { isSecureTextFieldContentRevealed.toggle() },
                    icon: visibilityIcon
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

    @ViewBuilder 
    private var headerView: some View {
        if let headerTitle = headerTitle?.nonEmpty {
            Text(headerTitle)
                .multilineTextAlignment(appearance.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: appearance.headerTitleTextLineType.textLineLimitType)
                .foregroundStyle(appearance.headerTitleTextColors.value(for: internalState))
                .font(appearance.headerTitleTextFont)
                .applyIfLet(appearance.headerTitleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: appearance.headerTitleTextFrameAlignment,
                        vertical: .center
                    )
                )

                .padding(.horizontal, appearance.headerMarginHorizontal)
        }
    }

    @ViewBuilder 
    private var footerView: some View {
        if let footerTitle = footerTitle?.nonEmpty {
            Text(footerTitle)
                .multilineTextAlignment(appearance.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: appearance.footerTitleTextLineType.textLineLimitType)
                .foregroundStyle(appearance.footerTitleTextColors.value(for: internalState))
                .font(appearance.footerTitleTextFont)
                .applyIfLet(appearance.footerTitleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: appearance.footerTitleTextFrameAlignment,
                        vertical: .center
                    )
                )

                .padding(.horizontal, appearance.footerMarginHorizontal)
        }
    }


    // MARK: Visibility Icon
    private var visibilityIcon: Image {
        if isSecureTextFieldContentRevealed {
            appearance.visibilityOnButtonIcon
        } else {
            appearance.visibilityOffButtonIcon
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

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var text: String = "Lorem ipsum"

    PreviewContainer {
        VTextField(
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            placeholder: "Lorem ipsum",
            text: $text
        )
        .padding(.horizontal)
    }
}

#Preview("Content Types") {
    @Previewable @State var text: String = "Lorem ipsum"

    PreviewContainer {
        ForEach(
            VTextFieldAppearance.ContentType.allCases,
            id: \.self
        ) { contentType in
            let title: String = .init(describing: contentType).capitalized

            PreviewRow(title) {
                VTextField(
                    appearance: {
                        var appearance: VTextFieldAppearance = .init()
                        appearance.contentType = contentType
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
    private let appearance: VTextFieldAppearance
    private let showsNative: Bool

    init(
        appearance: VTextFieldAppearance = .init(),
        showsNative: Bool = true
    ) {
        self.appearance = appearance
        self.showsNative = showsNative
    }

    var body: some View {
        PreviewContainer {
            PreviewRow("Enabled") {
                VTextField(
                    appearance: appearance,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
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
                        mappedAppearance.headerTitleTextColors.enabled = appearance.headerTitleTextColors.focused
                        mappedAppearance.footerTitleTextColors.enabled = appearance.footerTitleTextColors.focused
                        return mappedAppearance
                    }(),
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
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
                        mappedAppearance.clearButtonAppearance.iconColors!.enabled = appearance.clearButtonAppearance.iconColors!.pressed // Force-unwrap
                        mappedAppearance.visibilityButtonAppearance.iconColors!.enabled = appearance.visibilityButtonAppearance.iconColors!.pressed // Force-unwrap
                        return mappedAppearance
                    }(),
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            }

            PreviewRow("Disabled") {
                VTextField(
                    appearance: appearance,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
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
