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
///         .toolbar {
///             ToolbarItemGroup(placement: .keyboard) {
///                 Spacer()
///                 Button("Done") {
///                     isFocused = false
///                 }
///             }
///         }
///     }
///
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VCodeEntryViewUIModel`.
///
/// When running in `SwiftUI` previews or simulators, `mac` keyboard may cause the hidden `TextField` decoration to appear.
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VCodeEntryView: View {
    // MARK: Properties - UI Model
    private let uiModel: VCodeEntryViewUIModel
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var isFocused: Bool
    private func internalState(_ index: Int) -> VCodeEntryViewInternalState {
        .init(
            isEnabled: isEnabled,
            isFocused: isFocused && {
                if text.count == index { true }
                else if text.count == uiModel.length && text.count == index + 1 { true }
                else { false }
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
        ZStack(alignment: .bottomLeading) {
            hiddenTextField
            charactersView
        }
        // Detects all gestures on frame and focuses hidden `TextField`
        .contentShape(.rect)
        .onTapGesture { isFocused = true }

        // Ensures that hidden `TextField`'s frame doesn't overflow
        .clipped()

        .onChange(of: text, initial: true) { processText($1) }
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
            .foregroundStyle(.clear)

            // Makes highlighting invisible. Although, invisible highlight still maintains gray color,
            // it is only ever an issue on previews and simulators where `mac` keyboard can act as an input.
            //.tint(.clear) // Disabled, as it makes toolbar items invisible

            // Blocks hit testing for gestures, to ensure that highlighting doesn't occur, and that menu isn't opened
            .blocksHitTesting()

            .focused($isFocused)

#if !(os(macOS) || os(watchOS))
            .keyboardType(uiModel.keyboardType)
#endif
#if !(os(macOS) || os(watchOS))
            .textContentType(uiModel.textContentType)
#endif
            .disableAutocorrection(uiModel.isAutocorrectionEnabled?.toggled())
#if !(os(macOS) || os(watchOS))
            .textInputAutocapitalization(uiModel.autocapitalization)
#endif
            .submitLabel(uiModel.submitButton)
    }

    private var charactersView: some View {
        HStack(
            spacing: {
                switch uiModel.spacingType {
                case .fixed(let spacing): spacing
                case .stretched: 0
                }
            }()
        ) {
            ForEach(0..<uiModel.length, id: \.self) { index in
                characterView(index: index)

                if
                    uiModel.spacingType.hasFlexibleSpace,
                    index != uiModel.length-1
                {
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func characterView(
        index: Int
    ) -> some View {
        let internalState: VCodeEntryViewInternalState = internalState(index)
        let isPopulated: Bool = isPopulated(at: index)

        return Text(character(at: index))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .foregroundStyle(isPopulated ? uiModel.textColors.value(for: internalState) : uiModel.placeholderTextColors.value(for: internalState))
            .font(isPopulated ? uiModel.textFont : uiModel.placeholderTextFont)
            .applyIfLet(isPopulated ? uiModel.textDynamicTypeSizeType : uiModel.placeholderTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

            .frame(size: uiModel.characterBackgroundSize)

            .background { characterBackgroundBorderView(internalState) }
            .background { characterBackgroundView(internalState) }
            .clipShape(.rect(cornerRadius: uiModel.characterBackgroundCornerRadius))
    }

    private func characterBackgroundView(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        Rectangle()
            .foregroundStyle(uiModel.characterBackgroundColors.value(for: internalState))
    }

    @ViewBuilder 
    private func characterBackgroundBorderView(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        let borderWidth: CGFloat = uiModel.characterBackgroundBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.characterBackgroundCornerRadius)
                .strokeBorder(uiModel.characterBackgroundBorderColors.value(for: internalState), lineWidth: borderWidth)
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
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var text: String = "123"

    PreviewContainer {
        VCodeEntryView(text: $text)
    }
}

#Preview("States") {
    Preview_StatesContentView()
}

#Preview("Stretched") {
    @Previewable @State var text: String = "123"

    PreviewContainer {
        VCodeEntryView(
            uiModel: {
                var uiModel: VCodeEntryViewUIModel = .init()
                uiModel.spacingType = .stretched
                return uiModel
            }(),
            text: $text
        )
        .padding(.horizontal)
    }
}

#Preview("Success") {
    Preview_StatesContentView(uiModel: .success)
}

#Preview("Warning") {
    Preview_StatesContentView(uiModel: .warning)
}

#Preview("Error") {
    Preview_StatesContentView(uiModel: .error)
}

private struct Preview_StatesContentView: View {
    private let uiModel: VCodeEntryViewUIModel

    init(
        uiModel: VCodeEntryViewUIModel = .init()
    ) {
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer {
            PreviewRow("Enabled") {
                VCodeEntryView(
                    uiModel: uiModel,
                    text: .constant("123")
                )
            }

            // Color is also applied to other characters
            PreviewRow("Focused (*)") {
                VCodeEntryView(
                    uiModel: {
                        var uiModelMapped: VCodeEntryViewUIModel = uiModel
                        uiModelMapped.characterBackgroundColors.enabled = uiModel.characterBackgroundColors.focused
                        uiModelMapped.characterBackgroundBorderColors.enabled = uiModel.characterBackgroundBorderColors.focused
                        uiModelMapped.textColors.enabled = uiModel.textColors.focused
                        return uiModelMapped
                    }(),
                    text: .constant("123")
                )
            }

            PreviewRow("Disabled") {
                VCodeEntryView(
                    uiModel: uiModel,
                    text: .constant("123")
                )
                .disabled(true)
            }
        }
    }
}

#endif

#endif
