//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

public import SwiftUI
public import VCore

/// State picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VToggleState = .on
///
///     var body: some View {
///         VToggle(
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
///         VToggle(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VToggle<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VToggleAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var state: VToggleState
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VToggleInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VToggleLabel<CustomLabel>
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

    // MARK: Initializers
    /// Initializes `VToggle` with state.
    public init(
        appearance: VToggleAppearance = .init(),
        state: Binding<VToggleState>
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VToggle` with state and title.
    public init(
        appearance: VToggleAppearance = .init(),
        state: Binding<VToggleState>,
        title: String?
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.label = {
            if let title {
                .title(title: title)
            } else {
                .empty
            }
        }()
    }
    
    /// Initializes `VToggle` with state and custom label.
    public init(
        appearance: VToggleAppearance = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder label customLabel: @escaping (VToggleInternalState) -> CustomLabel
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
                toggleView

            case .title(let title):
                labeledToggleView {
                    baseButtonView { internalState in
                        Text(title)
                            .textConfiguration(appearance.labelTextConfiguration, state: internalState)
                    }
                    .blocksHitTesting(!appearance.labelIsClickable)
                }

            case .custom(let builder):
                labeledToggleView {
                    baseButtonView(label: builder)
                        .blocksHitTesting(!appearance.labelIsClickable)
                }
            }
        }
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }
    
    private var toggleView: some View {
        baseButtonView { internalState in
            ZStack {
                RoundedRectangle(cornerRadius: appearance.cornerRadius)
                    .foregroundStyle(appearance.fillColors.value(for: internalState))

                let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)
                if borderWidth > 0 {
                    RoundedRectangle(cornerRadius: appearance.cornerRadius)
                        .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                }

                RoundedRectangle(cornerRadius: appearance.thumbCornerRadius)
                    .frame(size: appearance.thumbSize)
                    .foregroundStyle(appearance.thumbColors.value(for: internalState))
                    .offset(x: thumbOffset(internalState: internalState))
            }
            .frame(size: appearance.size)
        }
    }

    private func labeledToggleView<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: appearance.toggleAndLabelSpacing) {
            toggleView
            label()
        }
    }

    private func baseButtonView<Content>(
        label: @escaping (VToggleInternalState) -> Content
    ) -> some View
        where Content: View
    {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                state.setNextState()
                sensoryFeedbackTrigger()
            },
            label: { baseButtonState in
                let internalState: VToggleInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(appearance.appliesStateChangeAnimation) {
                        $0
                            .animation(appearance.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    }
            }
        )
    }
    
    // MARK: Thumb Position
    private func thumbOffset(
        internalState: VToggleInternalState
    ) -> CGFloat {
        let offset: CGFloat = {
            let thumbWidth: CGFloat = appearance.thumbSize.width
            let spacing: CGFloat = (appearance.size.height - thumbWidth)/2
            let thumbStartPoint: CGFloat = (appearance.size.width - thumbWidth)/2
            let offset: CGFloat = thumbStartPoint - spacing
            
            return offset
        }()

        switch internalState {
        case .off: return -offset
        case .on: return offset
        case .pressedOff: return -offset
        case .pressedOn: return offset
        case .disabled: return -offset
        }
    }
}

#if DEBUG

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VToggleState = .on

    PreviewContainer {
        VToggle(
            state: $state,
            title: "Lorem ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VToggle(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed Off") {
            VToggle(
                appearance: VToggleAppearance {
                    $0.fillColors.off = $0.fillColors.pressedOff
                    $0.borderColors.off = $0.borderColors.pressedOff
                    $0.thumbColors.off = $0.thumbColors.pressedOff
                    $0.labelTextConfiguration.colors!.off = $0.labelTextConfiguration.colors!.pressedOff  // Unsafe (DEBUG)
                },
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("On") {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed On") {
            VToggle(
                appearance: VToggleAppearance {
                    $0.fillColors.on = $0.fillColors.pressedOn
                    $0.borderColors.on = $0.borderColors.pressedOn
                    $0.thumbColors.on = $0.thumbColors.pressedOn
                    $0.labelTextConfiguration.colors!.on = $0.labelTextConfiguration.colors!.pressedOn  // Unsafe (DEBUG)
                },
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Disabled") {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        }

        PreviewHeader("Native")

        PreviewRow("Off") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        }

        PreviewRow("On") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(true)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        }

        PreviewRow("Disabled") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .disabled(true)
        }
    }
}

#endif

#endif
