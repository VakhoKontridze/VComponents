//
//  VStretchedToggleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched Toggle Button
/// Stretched state picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VStretchedToggleButtonState = .on
///
///     var body: some View {
///         VStretchedToggleButton(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///         .padding()
///     }
///
/// Component can be also initialized with `Bool`.
///
///     @State private var isOn: Bool = true
///
///     var body: some View {
///         VStretchedToggleButton(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///         .padding()
///     }
///
/// Component can be radio-ed by ignoring select values in state's `Binding`'s setters.
///
///     @State private var state: VStretchedToggleButtonState = .on
///
///     var body: some View {
///         VStretchedToggleButton(
///             state: Binding(
///                 get: { state },
///                 set: { if $0 == .on { state = $0 } }
///             ),
///             image: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VStretchedToggleButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VStretchedToggleButtonAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VRectangularToggleButtonState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VStretchedToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }
    // MARK: Properties - Label
    private let label: VStretchedToggleButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VStretchedToggleButton` with state and title.
    public init(
        appearance: VStretchedToggleButtonAppearance = .init(),
        state: Binding<VStretchedToggleButtonState>,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VStretchedToggleButton` with state and image.
    public init(
        appearance: VStretchedToggleButtonAppearance = .init(),
        state: Binding<VStretchedToggleButtonState>,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .image(image: image)
    }

    /// Initializes `VStretchedToggleButton` with state, title, and image.
    public init(
        appearance: VStretchedToggleButtonAppearance = .init(),
        state: Binding<VStretchedToggleButtonState>,
        title: String,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .titleAndImage(title: title, image: image)
    }

    /// Initializes `VStretchedToggleButton` with state and custom label.
    public init(
        appearance: VStretchedToggleButtonAppearance = .init(),
        state: Binding<VStretchedToggleButtonState>,
        @ViewBuilder label customLabel: @escaping (VStretchedToggleButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self._state = state
        self.label = .custom(builder: customLabel)
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
                let internalState: VStretchedToggleButtonInternalState = internalState(baseButtonState)

                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: appearance.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
                    .applyIf(appearance.appliesStateChangeAnimation) {
                        $0
                            .animation(appearance.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed)
                    }
            }
        )
    }

    private func labelView(
        internalState: VStretchedToggleButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                labelTextElement(internalState: internalState, title: title)

            case .image(let image):
                labelImageElement(internalState: internalState, image: image)

            case .titleAndImage(let title, let image):
                switch appearance.labelTextAndLabelImagePlacement {
                case .textAndImage:
                    HStack(spacing: appearance.labelSpacing) {
                        labelTextElement(internalState: internalState, title: title)
                        labelImageElement(internalState: internalState, image: image)
                    }

                case .imageAndText:
                    HStack(spacing: appearance.labelSpacing) {
                        labelImageElement(internalState: internalState, image: image)
                        labelTextElement(internalState: internalState, title: title)
                    }
                }

            case .custom(let builder):
                builder(internalState)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(internalState.isPressedOffPressedOn ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }

    private func labelTextElement(
        internalState: VStretchedToggleButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.labelTextMinimumScaleFactor)
            .foregroundStyle(appearance.labelTextColors.value(for: internalState))
            .font(appearance.labelTextFont)
            .applyIfLet(appearance.labelTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }

    private func labelImageElement(
        internalState: VStretchedToggleButtonInternalState,
        image: Image
    ) -> some View {
        image
            .applyIf(appearance.isLabelImageResizable) { $0.resizable() }
            .applyIfLet(appearance.labelImageContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .frame(size: appearance.labelImageSize)
            .applyIfLet(appearance.labelImageColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.labelImageOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.labelImageFont)
            .applyIfLet(appearance.labelImageDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }

    private func backgroundView(
        internalState: VStretchedToggleButtonInternalState
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
        internalState: VStretchedToggleButtonInternalState
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
#endif
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VStretchedToggleButtonInternalState {
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

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VStretchedToggleButtonState = .on

    PreviewContainer {
        VStretchedToggleButton(
            state: $state,
            title: "Lorem Ipsum"
        )
        .modifier(StretchedButtonFrameModifier())
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VStretchedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Pressed Off") {
            VStretchedToggleButton(
                appearance: {
                    var appearance: VStretchedToggleButtonAppearance = .init()
                    appearance.backgroundColors.off = appearance.backgroundColors.pressedOff
                    appearance.labelTextColors.off = appearance.labelTextColors.pressedOff
                    return appearance
                }(),
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("On") {
            VStretchedToggleButton(
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Pressed On") {
            VStretchedToggleButton(
                appearance: {
                    var appearance: VStretchedToggleButtonAppearance = .init()
                    appearance.backgroundColors.on = appearance.backgroundColors.pressedOn
                    appearance.labelTextColors.on = appearance.labelTextColors.pressedOn
                    return appearance
                }(),
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Disabled") {
            VStretchedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .disabled(true)
            .modifier(StretchedButtonFrameModifier())
        }
    }
}

#endif

#endif
