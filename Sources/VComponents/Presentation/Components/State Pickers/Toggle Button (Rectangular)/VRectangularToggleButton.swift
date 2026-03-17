//
//  VRectangularToggleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

/// Rectangular state picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VRectangularToggleButtonState = .on
///
///     var body: some View {
///         VRectangularToggleButton(
///             state: $state,
///             image: Image(systemName: "swift")
///         )
///     }
///
/// Component can be also initialized with `Bool`.
///
///     @State private var isOn: Bool = true
///
///     var body: some View {
///         VRectangularToggleButton(
///             state: Binding(isOn: $isOn),
///             image: Image(systemName: "swift")
///         )
///     }
///
/// Component can be radio-ed by ignoring select values in state's `Binding`'s setters.
///
///     @State private var state: VRectangularToggleButtonState = .on
///
///     var body: some View {
///         VRectangularToggleButton(
///             state: Binding(
///                 get: { state },
///                 set: { if $0 == .on { state = $0 } }
///             ),
///             image: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularToggleButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VRectangularToggleButtonAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var state: VRectangularToggleButtonState
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VRectangularToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VRectangularToggleButtonLabel<CustomLabel>
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

    // MARK: Initializers
    /// Initializes `VRectangularToggleButton` with state and title.
    public init(
        appearance: VRectangularToggleButtonAppearance = .init(),
        state: Binding<VRectangularToggleButtonState>,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VRectangularToggleButton` with state and image.
    public init(
        appearance: VRectangularToggleButtonAppearance = .init(),
        state: Binding<VRectangularToggleButtonState>,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .image(image: image)
    }

    /// Initializes `VRectangularToggleButton` with state and custom label.
    public init(
        appearance: VRectangularToggleButtonAppearance = .init(),
        state: Binding<VRectangularToggleButtonState>,
        @ViewBuilder label customLabel: @escaping (VRectangularToggleButtonInternalState) -> CustomLabel
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
                state.setNextState()
                sensoryFeedbackTrigger()
            },
            label: { baseButtonState in
                let internalState: VRectangularToggleButtonInternalState = internalState(baseButtonState)

                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(size: appearance.size)
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
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }

    private func labelView(
        internalState: VRectangularToggleButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                labelTextElement(internalState: internalState, title: title)

            case .image(let image):
                labelImageElement(internalState: internalState, image: image)

            case .custom(let builder):
                builder(internalState)
            }
        }
        .scaleEffect(internalState.isPressedOffPressedOn ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }

    private func labelTextElement(
        internalState: VRectangularToggleButtonInternalState,
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
        internalState: VRectangularToggleButtonInternalState,
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
        internalState: VRectangularToggleButtonInternalState
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
        internalState: VRectangularToggleButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState.isPressedOffPressedOn ? appearance.backgroundPressedScale : 1)
        }
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
nonisolated extension VRectangularToggleButtonInternalState {
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

#if DEBUG

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VRectangularToggleButtonState = .on

    PreviewContainer {
        VRectangularToggleButton(
            state: $state,
            title: "ABC"
        )

        VRectangularToggleButton(
            state: $state,
            image: Image(systemName: "swift")
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VRectangularToggleButton(
                state: .constant(.off),
                image: Image(systemName: "swift")
            )
        }

        PreviewRow("Pressed Off") {
            VRectangularToggleButton(
                appearance: {
                    var appearance: VRectangularToggleButtonAppearance = .init()
                    appearance.backgroundColors.off = appearance.backgroundColors.pressedOff
                    appearance.labelImageColors!.off = appearance.labelImageColors!.pressedOff // Unsafe (DEBUG)
                    return appearance
                }(),
                state: .constant(.off),
                image: Image(systemName: "swift")
            )
        }

        PreviewRow("On") {
            VRectangularToggleButton(
                state: .constant(.on),
                image: Image(systemName: "swift")
            )
        }

        PreviewRow("Pressed On") {
            VRectangularToggleButton(
                appearance: {
                    var appearance: VRectangularToggleButtonAppearance = .init()
                    appearance.backgroundColors.on = appearance.backgroundColors.pressedOn
                    appearance.labelImageColors!.on = appearance.labelImageColors!.pressedOn // Unsafe (DEBUG)
                    return appearance
                }(),
                state: .constant(.on),
                image: Image(systemName: "swift")
            )
        }

        PreviewRow("Disabled") {
            VRectangularToggleButton(
                state: .constant(.off),
                image: Image(systemName: "swift")
            )
            .disabled(true)
        }
    }
}

#endif

#endif
