//
//  VRectangularToggleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Toggle Button
/// Rectangular state picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VRectangularToggleButtonState = .on
///
///     var body: some View {
///         VRectangularToggleButton(
///             state: $state,
///             icon: Image(systemName: "swift")
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
///             icon: Image(systemName: "swift")
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
///             icon: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG. No `SwiftUIGestureBaseButton`.
@available(watchOS, unavailable) // No `SwiftUIGestureBaseButton`.
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularToggleButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VRectangularToggleButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRectangularToggleButtonState
    private var internalState: VRectangularToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VRectangularToggleButtonLabel<Label>

    // MARK: Initializers
    /// Initializes `VRectangularToggleButton` with state and title.
    public init(
        uiModel: VRectangularToggleButtonUIModel = .init(),
        state: Binding<VRectangularToggleButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VRectangularToggleButton` with state and icon.
    public init(
        uiModel: VRectangularToggleButtonUIModel = .init(),
        state: Binding<VRectangularToggleButtonState>,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .icon(icon: icon)
    }

    /// Initializes `VRectangularToggleButton` with state and label.
    public init(
        uiModel: VRectangularToggleButtonUIModel = .init(),
        state: Binding<VRectangularToggleButtonState>,
        @ViewBuilder label: @escaping (VRectangularToggleButtonInternalState) -> Label
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
                    .frame(size: uiModel.size)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView }) // Has own rounding
                    .overlay(content: { borderView }) // Has own rounding
                    .padding(uiModel.hitBox)
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

            case .label(let label):
                label(internalState)
            }
        })
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
            .applyIf(uiModel.isIconResizable, transform: { $0.resizable() })
            .applyIfLet(uiModel.iconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
            .applyIfLet(uiModel.iconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
            .applyIfLet(uiModel.iconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
            .font(uiModel.iconFont)
            .frame(size: uiModel.iconSize)
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

    @ViewBuilder 
    private var borderView: some View {
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
@available(visionOS, unavailable)
extension VRectangularToggleButtonInternalState {
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

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VRectangularToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRectangularToggleButton(
                    state: $state,
                    title: "ABC"
                )

                VRectangularToggleButton(
                    state: $state,
                    icon: Image(systemName: "swift")
                )
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Off", content: {
            VRectangularToggleButton(
                state: .constant(.off),
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("Pressed Off", content: {
            VRectangularToggleButton(
                uiModel: {
                    var uiModel: VRectangularToggleButtonUIModel = .init()
                    uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                    uiModel.iconColors!.off = uiModel.iconColors!.pressedOff // Force-unwrap
                    return uiModel
                }(),
                state: .constant(.off),
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("On", content: {
            VRectangularToggleButton(
                state: .constant(.on),
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("Pressed On", content: {
            VRectangularToggleButton(
                uiModel: {
                    var uiModel: VRectangularToggleButtonUIModel = .init()
                    uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                    uiModel.iconColors!.on = uiModel.iconColors!.pressedOn // Force-unwrap
                    return uiModel
                }(),
                state: .constant(.on),
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("Disabled", content: {
            VRectangularToggleButton(
                state: .constant(.off),
                icon: Image(systemName: "swift")
            )
            .disabled(true)
        })
    })
})

#endif

#endif
