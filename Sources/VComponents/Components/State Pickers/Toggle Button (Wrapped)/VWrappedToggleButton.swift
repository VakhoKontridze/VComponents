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
public struct VWrappedToggleButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VWrappedToggleButtonUIModel

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
    private let label: VWrappedToggleButtonLabel<Label>

    // MARK: Initializers
    /// Initializes `VWrappedToggleButton` with state and title.
    public init(
        uiModel: VWrappedToggleButtonUIModel = .init(),
        state: Binding<VWrappedToggleButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VWrappedToggleButton` with state and icon.
    public init(
        uiModel: VWrappedToggleButtonUIModel = .init(),
        state: Binding<VWrappedToggleButtonState>,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .icon(icon: icon)
    }

    /// Initializes `VWrappedToggleButton` with state, icon, and title.
    public init(
        uiModel: VWrappedToggleButtonUIModel = .init(),
        state: Binding<VWrappedToggleButtonState>,
        title: String,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .titleAndIcon(title: title, icon: icon)
    }

    /// Initializes `VWrappedToggleButton` with state and label.
    public init(
        uiModel: VWrappedToggleButtonUIModel = .init(),
        state: Binding<VWrappedToggleButtonState>,
        @ViewBuilder label: @escaping (VWrappedToggleButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .label(label: label)
    }

    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VWrappedToggleButtonInternalState = internalState(baseButtonState)

                labelView(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView(internalState: internalState) }) // Has own rounding
                    .overlay(content: { borderView(internalState: internalState) }) // Has own rounding
                    .padding(uiModel.hitBox)
                    .applyIf(uiModel.appliesStateChangeAnimation, transform: {
                        $0
                            .animation(uiModel.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed)
                    })
            }
        )
    }

    private func labelView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch uiModel.titleTextAndIconPlacement {
                case .titleAndIcon:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        titleLabelViewComponent(internalState: internalState, title: title)
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                    })

                case .iconAndTitle:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                        titleLabelViewComponent(internalState: internalState, title: title)
                    })
                }

            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }

    private func titleLabelViewComponent(
        internalState: VWrappedToggleButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .dynamicTypeSize(...uiModel.titleTextDynamicTypeSizeMax)
    }

    private func iconLabelViewComponent(
        internalState: VWrappedToggleButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(uiModel.isIconResizable, transform: { $0.resizable() })
            .applyIfLet(uiModel.iconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
            .applyIfLet(uiModel.iconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
            .applyIfLet(uiModel.iconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
            .font(uiModel.iconFont)
            .frame(size: uiModel.iconSize)
    }

    private func backgroundView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.backgroundPressedScale : 1)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }

    @ViewBuilder 
    private func borderView(
        internalState: VWrappedToggleButtonInternalState
    ) -> some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.backgroundPressedScale : 1)
        }
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#elseif os(watchOS)
        HapticManager.shared.playImpact(uiModel.haptic)
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

#if !(os(tvOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VWrappedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VWrappedToggleButton(
                    state: $state,
                    title: "Lorem Ipsum"
                )
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Off", content: {
            VWrappedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Pressed Off", content: {
            VWrappedToggleButton(
                uiModel: {
                    var uiModel: VWrappedToggleButtonUIModel = .init()
                    uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                    uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                    return uiModel
                }(),
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("On", content: {
            VWrappedToggleButton(
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Pressed On", content: {
            VWrappedToggleButton(
                uiModel: {
                    var uiModel: VWrappedToggleButtonUIModel = .init()
                    uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                    uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                    return uiModel
                }(),
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VWrappedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .disabled(true)
        })
    })
})

#endif

#endif
