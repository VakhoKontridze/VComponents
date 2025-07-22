//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box
/// State picker component that toggles between `off`, `on`, and `indeterminate` states, and displays label.
///
///     @State private var state: VCheckBoxState = .on
///
///     var body: some View {
///         VCheckBox(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///
/// Component can be also initialized with `Bool`.
///
///     @State private var isOn: Bool = true
///
///     var body: some View {
///         VCheckBox(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VCheckBox<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VCheckBoxAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VCheckBoxState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VCheckBoxInternalState {
        .init(
            isEnabled: isEnabled,
            state: state,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VCheckBoxLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VCheckBox` with state.
    public init(
        appearance: VCheckBoxAppearance = .init(),
        state: Binding<VCheckBoxState>
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VCheckBox` with state and title.
    public init(
        appearance: VCheckBoxAppearance = .init(),
        state: Binding<VCheckBoxState>,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VCheckBox` with state and custom label.
    public init(
        appearance: VCheckBoxAppearance = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label customLabel: @escaping (VCheckBoxInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self._state = state
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        Group {
            switch label {
            case .empty:
                checkBoxView
                
            case .title(let title):
                labeledCheckBoxView {
                    baseButtonView { internalState in
                        Text(title)
                            .multilineTextAlignment(appearance.titleTextLineType.textAlignment ?? .leading)
                            .lineLimit(type: appearance.titleTextLineType.textLineLimitType)
                            .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
                            .foregroundStyle(appearance.titleTextColors.value(for: internalState))
                            .font(appearance.titleTextFont)
                            .applyIfLet(appearance.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                    }
                    .blocksHitTesting(!appearance.labelIsClickable)
                }

            case .custom(let custom):
                labeledCheckBoxView {
                    baseButtonView(label: custom)
                        .blocksHitTesting(!appearance.labelIsClickable)
                }
            }
        }
    }
    
    private var checkBoxView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        return baseButtonView { internalState in
            ZStack {
                RoundedRectangle(cornerRadius: appearance.cornerRadius)
                    .foregroundStyle(appearance.fillColors.value(for: internalState))

                if borderWidth > 0 {
                    RoundedRectangle(cornerRadius: appearance.cornerRadius)
                        .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                }

                if let checkmarkIcon: Image = checkmarkIcon(internalState: internalState) {
                    checkmarkIcon
                        .applyIf(appearance.isCheckmarkIconResizable) { $0.resizable() }
                        .applyIfLet(appearance.checkmarkIconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
                        .applyIfLet(appearance.checkmarkIconColors) { $0.foregroundStyle($1.value(for: internalState)) }
                        .applyIfLet(appearance.checkmarkIconOpacities) { $0.opacity($1.value(for: internalState)) }
                        .font(appearance.checkmarkIconFont)
                        .applyIfLet(appearance.checkmarkIconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                        .frame(size: appearance.checkmarkIconSize)
                }
            }
            .frame(size: appearance.size)
            .clipShape(.rect(cornerRadius: appearance.cornerRadius)) // Prevents large content from overflowing
            .padding(appearance.checkboxHitBox)
        }
    }

    private func labeledCheckBoxView<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: appearance.checkBoxAndLabelSpacing) {
            checkBoxView
            label()
        }
    }

    private func baseButtonView<Content>(
        label: @escaping (VCheckBoxInternalState) -> Content
    ) -> some View
        where Content: View
    {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VCheckBoxInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(appearance.appliesStateChangeAnimation) {
                        $0
                            .animation(appearance.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    }
            }
        )
    }

    // MARK: Checkmark Icon
    private func checkmarkIcon(
        internalState: VCheckBoxInternalState
    ) -> Image? {
        switch internalState {
        case .off, .pressedOff: nil
        case .on, .pressedOn: appearance.checkmarkIconOn
        case .indeterminate, .pressedIndeterminate: appearance.checkmarkIconIndeterminate
        case .disabled: nil
        }
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(appearance.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VCheckBoxState = .on

    PreviewContainer {
        VCheckBox(
            state: $state,
            title: "Lorem ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VCheckBox(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed Off") {
            VCheckBox(
                appearance: {
                    var appearance: VCheckBoxAppearance = .init()
                    appearance.fillColors.off = appearance.fillColors.pressedOff
                    appearance.borderColors.off = appearance.borderColors.pressedOff
                    appearance.checkmarkIconColors!.off = appearance.checkmarkIconColors!.pressedOff // Force-unwrap
                    appearance.titleTextColors.off = appearance.titleTextColors.pressedOff
                    return appearance
                }(),
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("On") {
            VCheckBox(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed On") {
            VCheckBox(
                appearance: {
                    var appearance: VCheckBoxAppearance = .init()
                    appearance.fillColors.on = appearance.fillColors.pressedOn
                    appearance.borderColors.on = appearance.borderColors.pressedOn
                    appearance.checkmarkIconColors!.on = appearance.checkmarkIconColors!.pressedOn // Force-unwrap
                    appearance.titleTextColors.on = appearance.titleTextColors.pressedOn
                    return appearance
                }(),
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Indeterminate") {
            VCheckBox(
                state: .constant(.indeterminate),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed Indeterminate") {
            VCheckBox(
                appearance: {
                    var appearance: VCheckBoxAppearance = .init()
                    appearance.fillColors.indeterminate = appearance.fillColors.pressedIndeterminate
                    appearance.borderColors.indeterminate = appearance.borderColors.pressedIndeterminate
                    appearance.checkmarkIconColors!.indeterminate = appearance.checkmarkIconColors!.pressedIndeterminate // Force-unwrap
                    appearance.titleTextColors.indeterminate = appearance.titleTextColors.pressedIndeterminate
                    return appearance
                }(),
                state: .constant(.indeterminate),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Disabled") {
            VCheckBox(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        }

#if !(os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)) // No `CheckboxToggleStyle`
        PreviewHeader("Native")

        PreviewRow("Off") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .toggleStyle(.checkbox)
        }

        PreviewRow("On") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(true)
            )
            .toggleStyle(.checkbox)
        }

        PreviewRow("Disabled") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .toggleStyle(.checkbox)
            .disabled(true)
        }
#endif
    }
}

#endif

#endif
