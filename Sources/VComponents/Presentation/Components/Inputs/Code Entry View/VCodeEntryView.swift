//
//  VCodeEntryView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.09.23.
//

public import SwiftUI
import VCore

/// Input component that displays an editable text interface for entering code, such as PIN.
///
///     @FocusState private var isFocused: Bool
///     @State private var text: String = ""
///
///     var body: some View {
///         VCodeEntryView(
///             appearance: {
///                 var appearance: VCodeEntryViewAppearance = .init()
///                 appearance.keyboardType = .numberPad
///                 return appearance
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
/// Highlights can be applied using `success`, `warning`, and `secure` instances of `VCodeEntryViewAppearance`.
///
/// When running in `SwiftUI` previews or simulators, `mac` keyboard may cause the hidden `TextField` decoration to appear.
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VCodeEntryView: View {
    // MARK: Properties - Appearance
    private let appearance: VCodeEntryViewAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @FocusState private var isFocused: Bool
    
    private func internalState(
        _ index: Int
    ) -> VCodeEntryViewInternalState {
        let isFilled: Bool =
            index < text.count
        
        let isEditingCurrentCharacter: Bool =
            index == text.count ||
            (index + 1 == text.count && text.count == appearance.length)
        
        return VCodeEntryViewInternalState(
            isEnabled: isEnabled,
            isFocused: isFocused && isEditingCurrentCharacter,
            isFilled: isFilled
        )
    }

    // MARK: Properties - Texts
    private let placeholder: Character?
    @Binding private var text: String

    // MARK: Initializers
    /// Initializes `VCodeEntryView` with text.
    public init(
        appearance: VCodeEntryViewAppearance = .init(),
        placeholder: Character? = nil,
        text: Binding<String>
    ) {
        self.appearance = appearance
        self.placeholder = placeholder
        self._text = text
    }

    // MARK: Body
    public var body: some View {
        // `bottomLeading` is required for hiding hidden `TextField` behind first character
        ZStack(alignment: .bottomLeading) {
            textField
            charactersView
        }
        // Detects all gestures on frame and focuses hidden `TextField`
        .contentShape(.rect)
        .onTapGesture { isFocused = true }

        // Ensures that hidden `TextField`'s frame doesn't overflow
        .clipped()

        .onChange(of: text, initial: true) { processText($1) }
    }

    private var textField: some View {
        TextField("", text: $text)
            // Removes all decoration
            .textFieldStyle(.plain)
        
            // Hides `TextField`
            .opacity(0)

            // Makes `TextField` as small as possible
            .frame(dimension: 1)

            // Positions `TextField` behind first character's center.
            // `1/4` for `y` helps maintain proper keyboard offset.
            .offset(x: appearance.characterBackgroundSize.width/2, y: -appearance.characterBackgroundSize.height/4)

            // Makes text invisible
            .foregroundStyle(.clear)

            // Makes highlighting invisible. Although, invisible highlight still maintains gray color,
            // it is only ever an issue on previews and simulators where `mac` keyboard can act as an input.
            //.tint(.clear) // Disabled, as it makes toolbar items invisible

            // Blocks hit testing for gestures, to ensure that highlighting doesn't occur, and that menu isn't opened
            .blocksHitTesting()

            .focused($isFocused)

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

    private var charactersView: some View {
        HStack(
            spacing: {
                switch appearance.spacingType {
                case .fixed(let spacing): spacing
                case .stretched: 0
                }
            }()
        ) {
            ForEach(0..<appearance.length, id: \.self) { index in
                characterView(index: index)

                if
                    appearance.spacingType.hasFlexibleSpace,
                    index != appearance.length-1
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
            .textConfiguration(
                isPopulated ? appearance.textConfiguration : appearance.placeholderTextConfiguration,
                state: internalState
            )

            .frame(size: appearance.characterBackgroundSize)

            .background { characterBackgroundBorderView(internalState) }
            .background { characterBackgroundView(internalState) }
            .clipShape(.rect(cornerRadius: appearance.characterBackgroundCornerRadius))
    }

    private func characterBackgroundView(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        Rectangle()
            .foregroundStyle(appearance.characterBackgroundColors.value(for: internalState))
    }

    @ViewBuilder 
    private func characterBackgroundBorderView(
        _ internalState: VCodeEntryViewInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.characterBackgroundBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.characterBackgroundCornerRadius)
                .strokeBorder(appearance.characterBackgroundBorderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }

    // MARK: Text Processing
    private func processText(_ newValue: String) {
        text = String(newValue.prefix(appearance.length))

        if
            appearance.submitsWhenLastCharacterIsEntered,
            isFocused,
            text.count == appearance.length
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

#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var text: String = "123"

    PreviewContainer {
        VCodeEntryView(text: $text)
    }
}

#Preview("States") {
    StatesContentView()
}

#Preview("Expanded State") {
    @Previewable @State var text: String = "123"

    PreviewContainer {
        VCodeEntryView(
            appearance: {
                var appearance: VCodeEntryViewAppearance = .init()
                appearance.characterBackgroundColors.enabledFilled = appearance.characterBackgroundColors.enabledFilled.darkened(by: 0.1)
                appearance.characterBackgroundColors.focusedFilled = appearance.characterBackgroundColors.focusedFilled.darkened(by: 0.1)
                appearance.characterBackgroundBorderColors.enabledFilled = appearance.characterBackgroundBorderColors.enabledFilled.darkened(by: 0.1)
                appearance.characterBackgroundBorderColors.focusedFilled = appearance.characterBackgroundBorderColors.focusedFilled.darkened(by: 0.1)
                return appearance
            }(),
            text: $text
        )
    }
}

#Preview("Stretched") {
    @Previewable @State var text: String = "123"

    PreviewContainer {
        VCodeEntryView(
            appearance: {
                var appearance: VCodeEntryViewAppearance = .init()
                appearance.spacingType = .stretched
                return appearance
            }(),
            text: $text
        )
        .padding(.horizontal)
    }
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
    // MARK: Properties
    private let appearance: VCodeEntryViewAppearance

    // MARK: Initializers
    init(
        appearance: VCodeEntryViewAppearance = .init()
    ) {
        self.appearance = appearance
    }

    // MARK: Body
    var body: some View {
        PreviewContainer {
            PreviewRow("Enabled") {
                VCodeEntryView(
                    appearance: appearance,
                    text: .constant("123")
                )
            }

            // Color is also applied to other characters
            PreviewRow("Focused (*)") {
                VCodeEntryView(
                    appearance: {
                        var appearanceMapped: VCodeEntryViewAppearance = appearance
                        appearanceMapped.characterBackgroundColors.enabledEmpty = appearance.characterBackgroundColors.focusedEmpty
                        appearanceMapped.characterBackgroundColors.enabledFilled = appearance.characterBackgroundColors.focusedFilled
                        appearanceMapped.characterBackgroundBorderColors.enabledEmpty = appearance.characterBackgroundBorderColors.focusedEmpty
                        appearanceMapped.characterBackgroundBorderColors.enabledFilled = appearance.characterBackgroundBorderColors.focusedFilled
                        appearanceMapped.textConfiguration.colors!.enabledEmpty = appearance.textConfiguration.colors!.focusedEmpty // Unsafe (DEBUG)
                        appearanceMapped.textConfiguration.colors!.enabledFilled = appearance.textConfiguration.colors!.focusedFilled // Unsafe (DEBUG)
                        return appearanceMapped
                    }(),
                    text: .constant("123")
                )
            }

            PreviewRow("Disabled") {
                VCodeEntryView(
                    appearance: appearance,
                    text: .constant("123")
                )
                .disabled(true)
            }
        }
    }
}

#endif

#endif
