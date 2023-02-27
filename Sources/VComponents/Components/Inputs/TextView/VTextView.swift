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
/// Text line limit can be changed the following way:
///
///     @State private var text: String = ""
///
///     var body: some View {
///         VTextView(
///             type: .spaceReserved(lineLimit: 10, reservesSpace: true),
///             placeholder: "Lorem ipsum",
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             text: $text
///         )
///             .padding()
///     }
///
public struct VTextView: View {
    // MARK: Properties
    private let uiModel: VTextViewUIModel
    
    private let textLineLimitType: TextLineLimitType
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private var internalState: VTextFieldInternalState { .init(isEnabled: isEnabled, isFocused: isFocused) }
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let placeholder: String?
    @Binding private var text: String
    
    // MARK: Initializers
    /// Initializes component with text.
    public init(
        uiModel: VTextViewUIModel = .init(),
        type textLineLimitType: TextLineLimitType = .none,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.uiModel = uiModel
        self.textLineLimitType = textLineLimitType
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
                type: uiModel.layout.headerTitleLineType,
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
                type: uiModel.layout.footerTitleLineType,
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
            .focused($isFocused) // Catches the focus from outside and stores in `isFocused`
        
            .multilineTextAlignment(uiModel.layout.textAlignment)
            .lineLimit(type: textLineLimitType)
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
    @State private static var text: String = "Lorem ipsum"

    static var previews: some View {
        VTextView(
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            placeholder: "Lorem ipsum",
            text: $text
        )
    }
}
