//
//  VTextView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.09.22.
//

import SwiftUI
import VCore

// MARK: - V Text View
/// Input component that displays an editable multiline text interface.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             placeholder: "Lorem ipsum",
///             text: $text
///         )
///         .padding()
///     }
///
/// Height can be changed via `textLineType` in Appearance.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             appearance: {
///                 var appearance: VTextViewAppearance = .init()
///                 appearance.textLineType = .multiLine(
///                     alignment: .leading,
///                     lineLimit: 7,
///                     reservesSpace: true
///                 )
///                 return appearance
///             }(),
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             placeholder: "Lorem ipsum",
///             text: $text
///         )
///         .padding()
///     }
///
/// TextView can be focused externally by applied `focused(_:) modifier`.
///
///     @FocusState private var isFocused: Bool
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(text: $text)
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
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VTextViewIModel`.
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VTextView: View {
    // MARK: Properties - Appearance
    private let appearance: VTextViewAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextViewInternalState {
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

    // MARK: Initializers
    /// Initializes `VTextView` with text.
    public init(
        appearance: VTextViewAppearance = .init(),
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
            spacing: appearance.headerAndTextViewAndFooterSpacing
        ) {
            headerView
            inputView
            footerView
        }
    }

    private var inputView: some View {
        textField
            .padding(appearance.textViewContentMargins)
            .frame(
                minHeight: appearance.minimumHeight,
                alignment: .top
            )
            .background { borderView }
            .background { backgroundView }
            .clipShape(.rect(cornerRadius: appearance.cornerRadius))
    }

    private var textField: some View {
        TextField(
            text: $text,
            prompt: placeholder.map {
                Text($0)
                    //.lineLimit(1)
                    //.minimumScaleFactor(1)
                    .foregroundStyle(appearance.placeholderTextColors.value(for: internalState))
                    .font(appearance.placeholderTextFont)
                    //.applyIfLet(appearance.placeholderTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) } // Cannot be applied to placeholder only
            },
            axis: .vertical,
            label: EmptyView.init
        )
        .textFieldStyle(.plain)

        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`

        .multilineTextAlignment(appearance.textLineType.textAlignment ?? .leading) // May glitch for previews
        .lineLimit(type: appearance.textLineType.textLineLimitType)
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
                .minimumScaleFactor(appearance.headerTitleTextMinimumScaleFactor)
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
                .minimumScaleFactor(appearance.footerTitleTextMinimumScaleFactor)
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
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var text: String = "Lorem ipsum"

    PreviewContainer {
        VTextView(
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            placeholder: "Lorem ipsum",
            text: $text
        )
        .padding(.horizontal)
    }
}

#Preview("States") {
    StatesContentView()
}

#Preview("Success") {
    StatesContentView(appearance: .success)
}

#Preview("Warning") {
    StatesContentView(appearance: .warning)
}

#Preview("Error") {
    StatesContentView(appearance: .error)
}

private struct StatesContentView: View {
    private let appearance: VTextViewAppearance

    init(
        appearance: VTextViewAppearance = .init()
    ) {
        self.appearance = appearance
    }

    var body: some View {
        PreviewContainer {
            PreviewRow("Enabled") {
                VTextView(
                    appearance: appearance,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            }

            PreviewRow("Focused") {
                VTextView(
                    appearance: {
                        var mappedAppearance: VTextViewAppearance = appearance
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

            PreviewRow("Disabled") {
                VTextView(
                    appearance: appearance,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .disabled(true)
                .padding(.horizontal)
            }
        }
    }
}

#endif

#endif
