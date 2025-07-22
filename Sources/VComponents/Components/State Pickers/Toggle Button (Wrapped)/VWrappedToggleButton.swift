//
//  VWrappedToggleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Wrapped Toggle Button
/// Wrapped state picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VWrappedToggleButtonState = .on
///
///     var body: some View {
///         VWrappedToggleButton(
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
///         VWrappedToggleButton(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
/// Component can be radio-ed by ignoring select values in state's `Binding`'s setters.
///
///     @State private var state: VWrappedToggleButtonState = .on
///
///     var body: some View {
///         VWrappedToggleButtonState(
///             state: Binding(
///                 get: { state },
///                 set: { if $0 == .on { state = $0 } }
///             ),
///             icon: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VWrappedToggleButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VWrappedToggleButtonAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VRectangularToggleButtonState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VWrappedToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VWrappedToggleButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VWrappedToggleButton` with state and title.
    public init(
        appearance: VWrappedToggleButtonAppearance = .init(),
        state: Binding<VWrappedToggleButtonState>,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VWrappedToggleButton` with state and icon.
    public init(
        appearance: VWrappedToggleButtonAppearance = .init(),
        state: Binding<VWrappedToggleButtonState>,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .icon(icon: icon)
    }

    /// Initializes `VWrappedToggleButton` with state, icon, and title.
    public init(
        appearance: VWrappedToggleButtonAppearance = .init(),
        state: Binding<VWrappedToggleButtonState>,
        title: String,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .titleAndIcon(title: title, icon: icon)
    }

    /// Initializes `VWrappedToggleButton` with state and custom label.
    public init(
        appearance: VWrappedToggleButtonAppearance = .init(),
        state: Binding<VWrappedToggleButtonState>,
        @ViewBuilder label customLabel: @escaping (VWrappedToggleButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self._state = state
        self.label = .custom(custom: customLabel)
    }

    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VWrappedToggleButtonInternalState = internalState(baseButtonState)

                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: appearance.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
                    .padding(appearance.hitBox)
                    .applyIf(appearance.appliesStateChangeAnimation) {
                        $0
                            .animation(appearance.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed)
                    }
            }
        )
    }

    private func labelView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch appearance.titleTextAndIconPlacement {
                case .titleAndIcon:
                    HStack(spacing: appearance.titleTextAndIconSpacing) {
                        titleLabelViewComponent(internalState: internalState, title: title)
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                    }

                case .iconAndTitle:
                    HStack(spacing: appearance.titleTextAndIconSpacing) {
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                        titleLabelViewComponent(internalState: internalState, title: title)
                    }
                }

            case .custom(let custom):
                custom(internalState)
            }
        }
        .scaleEffect(internalState.isPressedOffPressedOn ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }

    private func titleLabelViewComponent(
        internalState: VWrappedToggleButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
            .foregroundStyle(appearance.titleTextColors.value(for: internalState))
            .font(appearance.titleTextFont)
            .applyIfLet(appearance.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }

    private func iconLabelViewComponent(
        internalState: VWrappedToggleButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(appearance.isIconResizable) { $0.resizable() }
            .applyIfLet(appearance.iconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.iconColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.iconOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.iconFont)
            .applyIfLet(appearance.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.iconSize)
    }

    private func backgroundView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState.isPressedOffPressedOn ? appearance.backgroundPressedScale : 1)
            .foregroundStyle(appearance.backgroundColors.value(for: internalState))
            .shadow(
                color: appearance.shadowColors.value(for: internalState),
                radius: appearance.shadowRadius,
                offset: appearance.shadowOffset
            )
    }

    @ViewBuilder 
    private func borderView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState.isPressedOffPressedOn ? appearance.backgroundPressedScale : 1)
        }
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(appearance.haptic)
#elseif os(watchOS)
        HapticManager.shared.playImpact(appearance.haptic)
#endif
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension VWrappedToggleButtonInternalState {
    fileprivate var isPressedOffPressedOn: Bool {
        switch self {
        case .off: false
        case .on: false
        case .pressedOff: true
        case .pressedOn: true
        case .disabled: false
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VWrappedToggleButtonState = .on

    PreviewContainer {
        VWrappedToggleButton(
            state: $state,
            title: "Lorem Ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VWrappedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed Off") {
            VWrappedToggleButton(
                appearance: {
                    var appearance: VWrappedToggleButtonAppearance = .init()
                    appearance.backgroundColors.off = appearance.backgroundColors.pressedOff
                    appearance.titleTextColors.off = appearance.titleTextColors.pressedOff
                    return appearance
                }(),
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("On") {
            VWrappedToggleButton(
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed On") {
            VWrappedToggleButton(
                appearance: {
                    var appearance: VWrappedToggleButtonAppearance = .init()
                    appearance.backgroundColors.on = appearance.backgroundColors.pressedOn
                    appearance.titleTextColors.on = appearance.titleTextColors.pressedOn
                    return appearance
                }(),
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Disabled") {
            VWrappedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .disabled(true)
        }
    }
}

#endif

#endif
