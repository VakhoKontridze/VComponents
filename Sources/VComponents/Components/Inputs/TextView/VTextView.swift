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
/// UI Model, line limit type, placeholder, header, and footer can be passed as parameters.
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             placeholder: "Lorem ipsum",
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             text: $text
///         )
///             .padding()
///     }
///
/// Textview can also be focused externally by passing state:
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
/// Success textview:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             uiModel: .success,
///             text: $text
///         )
///             .padding()
///     }
///
/// Warning textview:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             uiModel: .warning,
///             text: $text
///         )
///             .padding()
///     }
///
/// Error textview:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             uiModel: .error,
///             text: $text
///         )
///             .padding()
///     }
///
public struct VTextView: View {
    // MARK: Properties
    private let uiModel: VTextViewUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextFieldInternalState { .init(isEnabled: isEnabled, isFocused: isFocused) }
    
    private let headerTitle: String?
    private let footerTitle: String?
    
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
        VStack(alignment: .leading, spacing: uiModel.layout.headerTextViewFooterSpacing, content: {
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
        Group(content: {
            textField
        })
            .padding(uiModel.layout.contentMargin)
            .frame(minHeight: uiModel.layout.minHeight)
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
    
    private var textField: some View {
        TextField(
            text: $text,
            prompt: placeholder.map {
                Text($0)
                    .foregroundColor(uiModel.colors.placeholder.value(for: internalState))
                    .font(uiModel.fonts.placeholder)
            },
            axis: .vertical,
            label: EmptyView.init
        )
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .ifLet(uiModel.layout.textLineType.textAlignment, transform: { $0.multilineTextAlignment($1) })
            .lineLimit(type: uiModel.layout.textLineType.textLineLimitType)
            .foregroundColor(uiModel.colors.text.value(for: internalState))
            .font(uiModel.fonts.text)
            .keyboardType(uiModel.misc.keyboardType)
            .textContentType(uiModel.misc.textContentType)
            .disableAutocorrection(uiModel.misc.autocorrection.map { !$0 })
            .textInputAutocapitalization(uiModel.misc.autocapitalization)
            .submitLabel(uiModel.misc.submitButton)
    }
}

// MARK: - Preview
struct VTextView_Previews: PreviewProvider {
    private static var headerTitle: String { "Lorem ipsum dolor sit amet" }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit" }
    private static var placeholder: String { "Lorem ipsum" }
    private static var text: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
        ColorSchemePreview(title: "Highlights", content: HighlightsPreview.init)
    }
    
    private struct Preview: View {
        @State private var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        
        var body: some View {
            PreviewContainer(content: {
                VTextView(
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
                                var uiModel: VTextViewUIModel = .init()
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
                    title: "Disabled",
                    content: {
                        VTextView(
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
    
    // No focus or disabled state is supported, so there's no need to exhaust them.
    private struct HighlightsPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Success",
                    content: {
                        VTextView(
                            uiModel: .success,
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            placeholder: placeholder,
                            text: .constant(text)
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Warning",
                    content: {
                        VTextView(
                            uiModel: .warning,
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            placeholder: placeholder,
                            text: .constant(text)
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Error",
                    content: {
                        VTextView(
                            uiModel: .error,
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            placeholder: placeholder,
                            text: .constant(text)
                        )
                    }
                )
            })
        }
    }
}
