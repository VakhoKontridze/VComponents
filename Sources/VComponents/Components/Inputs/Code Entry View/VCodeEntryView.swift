//
//  VCodeEntryView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.09.23.
//

import SwiftUI
import VCore

// MARK: - V Code Entry View
/// Input component that displays an editable text interface for entering code, such as PIN.
///
///     @FocusState private var isFocused: Bool
///     @State private var text: String = ""
///
///     var body: some View {
///         VCodeEntryView(
///             uiModel: {
///                 var uiModel: VCodeEntryViewUIModel = .init()
///                 uiModel.keyboardType = .numberPad
///                 return uiModel
///             }(),
///             text: $text
///         )
///         .focused($isFocused)
///         .toolbar(content: {
///             ToolbarItemGroup(
///                 placement: .keyboard,
///                 content: {
///                     Spacer()
///                     Button("Done", action: { isFocused = false })
///                 }
///             )
///         })
///     }
///
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VCodeEntryViewUIModel`.
///
/// Component may cause issues when rendered in `SwiftUI` previews.
/// When running is simulators, `mac` keyboard may cause the hidden `TextField` decoration to appear.
@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS 16.0, *)@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS 8.0, *)@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VCodeEntryView: View {
    // MARK: Properties
    private let uiModel: VCodeEntryViewUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private func internalState(_ index: Int) -> VCodeEntryViewInternalState {
        .init(
            isEnabled: isEnabled,
            isFocused: isFocused && {
                if text.count == index { return true }
                else if text.count == uiModel.length && text.count == index + 1 { return true }
                else { return false }
            }()
        )
    }

    // MARK: Properties - Texts
    private let placeholder: Character?
    @Binding private var text: String

    // MARK: Initializers
    /// Initializes `VCodeEntryView` with text.
    public init(
        uiModel: VCodeEntryViewUIModel = .init(),
        placeholder: Character? = nil,
        text: Binding<String>
    ) {
        self.uiModel = uiModel
        self.placeholder = placeholder
        self._text = text
    }

    // MARK: Body
    public var body: some View {
        // `bottomLeading` is required for hiding hidden `TextField` behind first character
        ZStack(alignment: .bottomLeading, content: {
            hiddenTextField
            charactersView
        })
        // Detects all gestures on frame and focuses hidden `TextField`
        .contentShape(Rectangle())
        .onTapGesture(perform: { isFocused = true })

        // Ensures that hidden `TextField`'s frame doesn't overflow
        .clipped()

        .onAppear(perform: { processText(text) })
        .onChange(of: text, perform: { processText($0) })
    }

    private var hiddenTextField: some View {
        TextField("", text: $text)
            // Removes all decoration
            .textFieldStyle(.plain)

            // Makes `TextField` as small as possible
            .frame(dimension: 1)
            // Positions `TextField` behind first character's center.
            // `1/4` for `y` helps maintain proper keyboard offset.
            .offset(x: uiModel.characterBackgroundSize.width/2, y: -uiModel.characterBackgroundSize.height/4)

            // Makes text invisible
            .foregroundColor(.clear)
            // Makes highlighting invisible. Although, invisible highlight still maintains gray color,
            // it is only ever an issue on previews and simulators where `mac` keyboard can act as an input.
            .tint(.clear)

            // Blocks hit testing for gestures, to ensure that highlighting doesn't occur,
            // and that menu isn't opened
            .blocksHitTesting()

            .focused($isFocused)

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

    private var charactersView: some View {
        HStack(
            spacing: uiModel.spacing,
            content: {
                ForEach(
                    0..<uiModel.length,
                    id: \.self,
                    content: { index in characterView(at: index) }
                )
            }
        )
    }

    private func characterView(at index: Int) -> some View {
        let internalState: VCodeEntryViewInternalState = internalState(index)
        let isPopulated: Bool = isPopulated(at: index)

        return Text(character(at: index))
            .lineLimit(1)
            .foregroundColor(isPopulated ? uiModel.textColors.value(for: internalState) : uiModel.placeholderTextColors.value(for: internalState))
            .font(isPopulated ? uiModel.textFont : uiModel.placeholderTextFont)
            .multilineTextAlignment(.center)

            .frame(size: uiModel.characterBackgroundSize)
            .clipped() // Prevents large content from overflowing
            .background(characterBackgroundBorder(internalState)) // Has own rounding
            .background(characterBackground(internalState)) // Has own rounding
    }

    private func characterBackground(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.characterBackgroundCornerRadius)
            .foregroundColor(uiModel.characterBackgroundColors.value(for: internalState))
    }

    @ViewBuilder private func characterBackgroundBorder(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        if uiModel.characterBackgroundBorderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.characterBackgroundCornerRadius)
                .strokeBorder(
                    uiModel.characterBackgroundBorderColors.value(for: internalState),
                    lineWidth: uiModel.characterBackgroundBorderWidth
                )
        }
    }

    // MARK: Text Processing
    private func processText(_ newValue: String) {
        text = String(newValue.prefix(uiModel.length))

        if
            uiModel.submitsWhenLastCharacterIsEntered,
            isFocused,
            text.count == uiModel.length
        {
            isFocused = false
        }
    }

    private func isPopulated(at index: Int) -> Bool {
        index < text.count
    }

    private func character(at index: Int) -> String {
        guard isPopulated(at: index) else {
            return placeholder.map { String($0) } ?? ""
        }

        return String(text[index])
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VCodeEntryView_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    private static var highlight: VCodeEntryViewUIModel { .init() }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var text: String = ""

        var body: some View {
            PreviewContainer(content: {
                VCodeEntryView(
                    uiModel: highlight,
                    text: $text
                )
            })
        }
    }

    private struct StatesPreview: View {
        private let text: String = "123"

        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VCodeEntryView(
                            uiModel: highlight,
                            text: .constant(text)
                        )
                    }
                )

                // Color is also applied to other characters
                PreviewRow(
                    axis: .vertical,
                    title: "Focused (*)",
                    content: {
                        VCodeEntryView(
                            uiModel: {
                                var uiModel: VCodeEntryViewUIModel = highlight
                                uiModel.characterBackgroundColors.enabled = uiModel.characterBackgroundColors.focused
                                uiModel.characterBackgroundBorderColors.enabled = uiModel.characterBackgroundColors.focused
                                uiModel.textColors.enabled = uiModel.textColors.focused
                                return uiModel
                            }(),
                            text: .constant(text)
                        )
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VCodeEntryView(
                            uiModel: highlight,
                            text: .constant(text)
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        @State private var text: String = "123"

        var body: some View {
            PreviewContainer(content: {
                VCodeEntryView(
                    uiModel: {
                        var uiModel: VCodeEntryViewUIModel = highlight
                        uiModel.textFont = .system(size: 100)
                        return uiModel
                    }(),
                    text: $text
                )
            })
        }
    }
}
