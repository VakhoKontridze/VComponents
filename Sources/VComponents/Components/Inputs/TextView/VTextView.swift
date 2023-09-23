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
/// Height can be changed via `textLineType` in UI model.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             uiModel: {
///                 var uiModel: VTextViewUIModel = .init()
///                 uiModel.textLineType = .multiLine(
///                     alignment: .leading,
///                     lineLimit: 7,
///                     reservesSpace: true
///                 )
///                 return uiModel
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
///             .onAppear(perform: {
///                 DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
///                     isFocused = true
///                 })
///             })
///     }
///
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VTextViewIModel`.
@available(iOS 16.0, *)
@available(macOS 13.0, *)@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS 16.0, *)@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS 9.0, *)@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VTextView: View {
    // MARK: Properties - UI Model
    private let uiModel: VTextViewUIModel

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
        uiModel: VTextViewUIModel = .init(),
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
            spacing: uiModel.headerTextViewAndFooterSpacing,
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
                .foregroundStyle(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)

                .padding(.horizontal, uiModel.headerMarginHorizontal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)

                .padding(.horizontal, uiModel.footerMarginHorizontal)
        }
    }

    private var input: some View {
        textField
            .frame(minHeight: uiModel.minHeight)
            .padding(uiModel.contentMargins)
            .clipped() // Prevents large content from overflowing
            .background(content: { backgroundBorder }) // Has own rounding
            .background(content: { background }) // Has own rounding
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
    }

    @ViewBuilder private var backgroundBorder: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
        }
    }

    private var textField: some View {
        TextField(
            text: $text,
            prompt: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.placeholderTextColors.value(for: internalState)) // TODO: iOS 17 - Replace with `foregroundStyle(_:)`
                    .font(uiModel.placeholderTextFont)
            },
            axis: .vertical,
            label: EmptyView.init
        )
        .textFieldStyle(.plain)

        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`

        .multilineTextAlignment(uiModel.textLineType.textAlignment ?? .leading)
        .lineLimit(type: uiModel.textLineType.textLineLimitType)
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
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VTextView_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    private static var highlight: VTextViewUIModel { .init() }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }

    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    private static var placeholder: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    private static var text: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

        var body: some View {
            PreviewContainer(content: {
                VTextView(
                    uiModel: {
                        var uiModel: VTextViewUIModel = highlight
                        uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 7, reservesSpace: true)
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
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VTextView(
                            uiModel: highlight,
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
                        VTextView(
                            uiModel: {
                                var uiModel: VTextViewUIModel = highlight
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
                    title: "Disabled",
                    content: {
                        VTextView(
                            uiModel: highlight,
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            placeholder: placeholder,
                            text: .constant(text)
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }
}
