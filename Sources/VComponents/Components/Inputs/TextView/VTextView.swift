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
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             placeholder: "Lorem ipsum",
///             text: $text
///         )
///             .padding()
///     }
///
/// To change height, change `textLineType`:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             uiModel: {
///                 var uiModel: VTextViewUIModel = .init()
///                 uiModel.layout.textLineType = .multiLine(
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
/// You can apply highlights by using `success`, `warning`, and `secure` instances of `VTextViewIModel`.
@available(iOS 16.0, *)
@available(macOS 13.0, *)@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS 16.0, *)@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS 9.0, *)@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VTextView: View {
    // MARK: Properties
    private let uiModel: VTextViewUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextViewInternalState { .init(isEnabled: isEnabled, isFocused: isFocused) }
    
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
            .textFieldStyle(.plain)
        
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .ifLet(uiModel.layout.textLineType.textAlignment, transform: { $0.multilineTextAlignment($1) })
            .lineLimit(type: uiModel.layout.textLineType.textLineLimitType)
            .foregroundColor(uiModel.colors.text.value(for: internalState))
            .font(uiModel.fonts.text)
            .modifier({
#if os(iOS)
                $0.keyboardType(uiModel.misc.keyboardType)
#else
                $0
#endif
            })
            .modifier({
#if os(iOS)
                $0.textContentType(uiModel.misc.textContentType)
#else
                $0
#endif
            })
            .disableAutocorrection(uiModel.misc.autocorrection.map { !$0 })
            .modifier({
#if os(iOS)
                $0.textInputAutocapitalization(uiModel.misc.autocapitalization)
#else
                $0
#endif
            })
            .submitLabel(uiModel.misc.submitButton)
    }
}

// MARK: - Preview
@available(iOS 16.0, *)
@available(macOS 13.0, *)@available(macOS, unavailable)
@available(tvOS 16.0, *)@available(tvOS, unavailable)
@available(watchOS 9.0, *)@available(watchOS, unavailable)
struct VTextView_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    private static var highlight: VTextViewUIModel { .init() }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet" }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit" }
    private static var placeholder: String { "Lorem ipsum" }
    private static var text: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit" }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        
        var body: some View {
            PreviewContainer(content: {
                VTextView(
                    uiModel: {
                        var uiModel: VTextViewUIModel = highlight
                        uiModel.layout.textLineType = .multiLine(alignment: .leading, lineLimit: 7, reservesSpace: true)
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
