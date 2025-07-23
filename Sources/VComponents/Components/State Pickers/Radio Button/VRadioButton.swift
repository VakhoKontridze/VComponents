//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button
/// State picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VRadioButtonState = .on
///
///     var body: some View {
///         VRadioButton(
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
///         VRadioButton(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRadioButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VRadioButtonAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VRadioButtonState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRadioButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VRadioButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VRadioButton` with state.
    public init(
        appearance: VRadioButtonAppearance = .init(),
        state: Binding<VRadioButtonState>
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VRadioButton` with state and title.
    public init(
        appearance: VRadioButtonAppearance = .init(),
        state: Binding<VRadioButtonState>,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VRadioButton` with state and custom label.
    public init(
        appearance: VRadioButtonAppearance = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder label customLabel: @escaping (VRadioButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self._state = state
        self.label = .custom(builder: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        Group {
            switch label {
            case .empty:
                radioButton
                
            case .title(let title):
                labeledRadioButton {
                    baseButtonView { internalState in
                        Text(title)
                            .multilineTextAlignment(appearance.labelTextLineType.textAlignment ?? .leading)
                            .lineLimit(type: appearance.labelTextLineType.textLineLimitType)
                            .minimumScaleFactor(appearance.labelTextMinimumScaleFactor)
                            .foregroundStyle(appearance.labelTextColors.value(for: internalState))
                            .font(appearance.labelTextFont)
                            .applyIfLet(appearance.labelTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                    }
                    .blocksHitTesting(!appearance.labelIsClickable)
                }

            case .custom(let builder):
                labeledRadioButton {
                    baseButtonView(label: builder)
                        .blocksHitTesting(!appearance.labelIsClickable)
                }
            }
        }
    }

    private var radioButton: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        return baseButtonView { internalState in
            ZStack {
                RoundedRectangle(cornerRadius: appearance.cornerRadius)
                    .frame(size: appearance.size)
                    .foregroundStyle(appearance.fillColors.value(for: internalState))

                if borderWidth > 0 {
                    RoundedRectangle(cornerRadius: appearance.cornerRadius)
                        .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                        .frame(size: appearance.size)
                }

                RoundedRectangle(cornerRadius: appearance.bulletCornerRadius)
                    .frame(size: appearance.bulletSize)
                    .foregroundStyle(appearance.bulletColors.value(for: internalState))
            }
            .frame(size: appearance.size)
            .padding(appearance.radioButtonHitBox)
        }
    }

    private func labeledRadioButton<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: appearance.radioButtonAndLabelSpacing) {
            radioButton
            label()
        }
    }

    private func baseButtonView<Content>(
        label: @escaping (VRadioButtonInternalState) -> Content
    ) -> some View
        where Content: View
    {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                playHapticEffect()
                state.setNextStateRadio()
            },
            label: { baseButtonState in
                let internalState: VRadioButtonInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(appearance.appliesStateChangeAnimation) {
                        $0
                            .animation(appearance.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    }
            }
        )
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(appearance.haptic)
#endif
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VRadioButtonState {
    mutating fileprivate func setNextStateRadio() {
        switch self {
        case .off: self = .on
        case .on: break
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VRadioButtonState = .on

    PreviewContainer {
        VRadioButton(
            state: $state,
            title: "Lorem ipsum"
        )

        VPlainButton(
            action: { state.setNextState() },
            title: "Toggle State"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VRadioButton(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed Off") {
            VRadioButton(
                appearance: {
                    var appearance: VRadioButtonAppearance = .init()
                    appearance.fillColors.off = appearance.fillColors.pressedOff
                    appearance.borderColors.off = appearance.borderColors.pressedOff
                    appearance.bulletColors.off = appearance.bulletColors.pressedOff
                    appearance.labelTextColors.off = appearance.labelTextColors.pressedOff
                    return appearance
                }(),
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("On") {
            VRadioButton(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed On") {
            VRadioButton(
                appearance: {
                    var appearance: VRadioButtonAppearance = .init()
                    appearance.fillColors.on = appearance.fillColors.pressedOn
                    appearance.borderColors.on = appearance.borderColors.pressedOn
                    appearance.bulletColors.on = appearance.bulletColors.pressedOn
                    appearance.labelTextColors.on = appearance.labelTextColors.pressedOn
                    return appearance
                }(),
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Disabled") {
            VRadioButton(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        }
    }
}

#endif

#endif
