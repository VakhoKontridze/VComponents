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
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularToggleButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - UI Model
    private let uiModel: VRectangularToggleButtonUIModel

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VRectangularToggleButtonState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRectangularToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VRectangularToggleButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VRectangularToggleButton` with state and title.
    public init(
        uiModel: VRectangularToggleButtonUIModel = .init(),
        state: Binding<VRectangularToggleButtonState>,
        title: String
    )
        where CustomLabel == Never
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
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .icon(icon: icon)
    }

    /// Initializes `VRectangularToggleButton` with state and custom label.
    public init(
        uiModel: VRectangularToggleButtonUIModel = .init(),
        state: Binding<VRectangularToggleButtonState>,
        @ViewBuilder label customLabel: @escaping (VRectangularToggleButtonInternalState) -> CustomLabel
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(custom: customLabel)
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
                let internalState: VRectangularToggleButtonInternalState = internalState(baseButtonState)

                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(size: uiModel.size)
                    .background(content: { backgroundView(internalState: internalState) })
                    .overlay(content: { borderView(internalState: internalState) })
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius))
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
        internalState: VRectangularToggleButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)

            case .custom(let custom):
                custom(internalState)
            }
        })
        .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }

    private func titleLabelViewComponent(
        internalState: VRectangularToggleButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .applyIfLet(uiModel.titleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
    }

    private func iconLabelViewComponent(
        internalState: VRectangularToggleButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(uiModel.isIconResizable, transform: { $0.resizable() })
            .applyIfLet(uiModel.iconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
            .applyIfLet(uiModel.iconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
            .applyIfLet(uiModel.iconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
            .font(uiModel.iconFont)
            .applyIfLet(uiModel.iconDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
            .frame(size: uiModel.iconSize)
    }

    private func backgroundView(
        internalState: VRectangularToggleButtonInternalState
    ) -> some View {
        Rectangle()
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
        internalState: VRectangularToggleButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
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

#if !(os(tvOS) || os(visionOS))

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
