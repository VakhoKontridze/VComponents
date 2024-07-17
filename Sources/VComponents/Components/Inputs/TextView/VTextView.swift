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
///                 Task(operation: {
///                     try? await Task.sleep(seconds: 1)
///                     isFocused = true
///                 })
///             })
///     }
///
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VTextViewIModel`.
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VTextView: View {
    // MARK: Properties - UI Model
    private let uiModel: VTextViewUIModel
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
                headerView
                inputView
                footerView
            }
        )
    }

    private var inputView: some View {
        textField
            .padding(uiModel.textViewContentMargins)
            .frame(
                minHeight: uiModel.minimumHeight,
                alignment: .top
            )
            .clipped() // Prevents large content from overflowing
            .background(content: { backgroundBorderView }) // Has own rounding
            .background(content: { backgroundView }) // Has own rounding
    }

    private var textField: some View {
        TextField(
            text: $text,
            prompt: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.placeholderTextColors.value(for: internalState)) // TODO: iOS 17.0 - Replace with `foregroundStyle(_:)`
                    .font(uiModel.placeholderTextFont)
                    //.applyIfLet(uiModel.placeholderTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) }) // Cannot be applied to placeholder only
            },
            axis: .vertical,
            label: EmptyView.init
        )
        .textFieldStyle(.plain)

        .focused($isFocused) // Catches the focus from outside and stores in `isFocused`

        .multilineTextAlignment(uiModel.textLineType.textAlignment ?? .leading) // May glitch for previews
        .lineLimit(type: uiModel.textLineType.textLineLimitType)
        .foregroundStyle(uiModel.textColors.value(for: internalState))
        .font(uiModel.textFont)
        .applyIfLet(uiModel.textDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
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

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .onTapGesture(perform: { isFocused = true }) // Detects gestures even on background
    }

    @ViewBuilder 
    private var backgroundBorderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }

    @ViewBuilder
    private var headerView: some View {
        if let headerTitle = headerTitle?.nonEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.headerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)
                .applyIfLet(uiModel.headerTitleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

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
        if let footerTitle = footerTitle?.nonEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)
                .applyIfLet(uiModel.footerTitleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

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
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var text: String = "Lorem ipsum"

        var body: some View {
            PreviewContainer(content: {
                VTextView(
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

#Preview("States", body: {
    Preview_StatesContentView()
})

#Preview("Success", body: {
    Preview_StatesContentView(uiModel: .success)
})

#Preview("Warning", body: {
    Preview_StatesContentView(uiModel: .warning)
})

#Preview("Error", body: {
    Preview_StatesContentView(uiModel: .error)
})

private struct Preview_StatesContentView: View {
    private let uiModel: VTextViewUIModel

    init(
        uiModel: VTextViewUIModel = .init()
    ) {
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer(content: {
            PreviewRow("Enabled", content: {
                VTextView(
                    uiModel: uiModel,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .padding(.horizontal)
            })

            PreviewRow("Focused", content: {
                VTextView(
                    uiModel: {
                        var mappedUIModel: VTextViewUIModel = uiModel
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

            PreviewRow("Disabled", content: {
                VTextView(
                    uiModel: uiModel,
                    headerTitle: "Lorem ipsum dolor sit amet",
                    footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    placeholder: "Lorem ipsum",
                    text: .constant("Lorem ipsum")
                )
                .disabled(true)
                .padding(.horizontal)
            })
        })
    }
}

#endif

#endif
