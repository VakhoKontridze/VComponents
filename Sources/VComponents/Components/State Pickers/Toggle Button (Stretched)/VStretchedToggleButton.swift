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
///             icon: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support.
public struct VStretchedToggleButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VStretchedToggleButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VStretchedToggleButtonState
    private var internalState: VStretchedToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VStretchedToggleButtonLabel<Label>

    // MARK: Initializers
    /// Initializes `VStretchedToggleButton` with state and title.
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VStretchedToggleButton` with state and icon.
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .icon(icon: icon)
    }

    /// Initializes `VStretchedToggleButton` with state, icon, and title.
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        title: String,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .titleAndIcon(title: title, icon: icon)
    }

    /// Initializes `VStretchedToggleButton` with state and label.
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        @ViewBuilder label: @escaping (VStretchedToggleButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .label(label: label)
    }

    // MARK: Body
    public var body: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                labelView
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView }) // Has own rounding
                    .overlay(content: { borderView }) // Has own rounding
            }
        )
        .applyIf(uiModel.appliesStateChangeAnimation, transform: {
            $0.animation(uiModel.stateChangeAnimation, value: internalState)
        })
    }

    private var labelView: some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelViewComponent(title: title)

            case .icon(let icon):
                iconLabelViewComponent(icon: icon)

            case .titleAndIcon(let title, let icon):
                switch uiModel.titleTextAndIconPlacement {
                case .titleAndIcon:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        titleLabelViewComponent(title: title)
                        iconLabelViewComponent(icon: icon)
                    })

                case .iconAndTitle:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        iconLabelViewComponent(icon: icon)
                        titleLabelViewComponent(title: title)
                    })
                }

            case .label(let label):
                label(internalState)
            }
        })
        .frame(maxWidth: .infinity)
        .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }

    private func titleLabelViewComponent(
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
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundStyle(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.backgroundPressedScale : 1)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }

    @ViewBuilder private var borderView: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.backgroundPressedScale : 1)
        }
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: GestureBaseButtonGestureState) {
        isPressed = gestureState.didRecognizePress

        if gestureState.didRecognizeClick {
            playHapticEffect()
            state.setNextState()
        }
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#endif
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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

#if !(os(tvOS) || os(watchOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VStretchedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VStretchedToggleButton(
                    state: $state,
                    title: "Lorem Ipsum"
                )
                .padding(.horizontal)
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Off", content: {
            VStretchedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .padding(.horizontal)
        })

        PreviewRow("Pressed Off", content: {
            VStretchedToggleButton(
                uiModel: {
                    var uiModel: VStretchedToggleButtonUIModel = .init()
                    uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                    uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                    return uiModel
                }(),
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .padding(.horizontal)
        })

        PreviewRow("On", content: {
            VStretchedToggleButton(
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
            .padding(.horizontal)
        })

        PreviewRow("Pressed On", content: {
            VStretchedToggleButton(
                uiModel: {
                    var uiModel: VStretchedToggleButtonUIModel = .init()
                    uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                    uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                    return uiModel
                }(),
                state: .constant(.on),
                title: "Lorem Ipsum"
            )
            .padding(.horizontal)
        })

        PreviewRow("Disabled", content: {
            VStretchedToggleButton(
                state: .constant(.off),
                title: "Lorem Ipsum"
            )
            .disabled(true)
            .padding(.horizontal)
        })
    })
})

#endif

#endif
