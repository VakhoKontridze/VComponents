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
///             title: "Lorem Ipsum"
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
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support.
@available(watchOS, unavailable) // No `SwiftUIGestureBaseButton` support.
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
                toggleLabel
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(size: uiModel.size)
                    .cornerRadius(uiModel.cornerRadius) // Prevents large content from overflowing
                    .background(content: { background }) // Has own rounding
                    .overlay(content: { border }) // Has own rounding
                    .padding(uiModel.hitBox)
            }
        )
        .applyIf(uiModel.appliesStateChangeAnimation, transform: {
            $0.animation(uiModel.stateChangeAnimation, value: internalState)
        })
    }

    private var toggleLabel: some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelComponent(title: title)

            case .icon(let icon):
                iconLabelComponent(icon: icon)

            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState.isPressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }

    private func titleLabelComponent(
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .dynamicTypeSize(...uiModel.titleTextDynamicTypeSizeMax)
    }

    private func iconLabelComponent(
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundColor(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .scaleEffect(internalState.isPressed ? uiModel.backgroundPressedScale : 1)
            .foregroundColor(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }

    @ViewBuilder private var border: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                .scaleEffect(internalState.isPressed ? uiModel.backgroundPressedScale : 1)
        }
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: GestureBaseButtonGestureState) {
        isPressed = gestureState.isPressed

        if gestureState.isClicked {
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
extension VRectangularToggleButtonInternalState {
    fileprivate var isPressed: Bool {
        switch self {
        case .off: return false
        case .on: return false
        case .pressedOff: return true
        case .pressedOn: return true
        case .disabled: return false
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRectangularToggleButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            BorderPreview().previewDisplayName("Border")
            ShadowPreview().previewDisplayName("Shadow")
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }

    // Data
    private static var title: String { "ABC".pseudoRTL(languageDirection) }
    private static var icon: Image { .init(systemName: "swift") }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VRectangularToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRectangularToggleButton(
                    state: $state,
                    title: title
                )

                VRectangularToggleButton(
                    state: $state,
                    icon: icon
                )
            })
        }
    }

    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .horizontal,
                    title: "Off",
                    content: {
                        VRectangularToggleButton(
                            state: .constant(.off),
                            icon: icon
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VRectangularToggleButton(
                            uiModel: {
                                var uiModel: VRectangularToggleButtonUIModel = .init()
                                uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                                uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                                return uiModel
                            }(),
                            state: .constant(.off),
                            icon: icon
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "On",
                    content: {
                        VRectangularToggleButton(
                            state: .constant(.on),
                            icon: icon
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VRectangularToggleButton(
                            uiModel: {
                                var uiModel: VRectangularToggleButtonUIModel = .init()
                                uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                                uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                                return uiModel
                            }(),
                            state: .constant(.on),
                            icon: icon
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VRectangularToggleButton(
                            state: .constant(.off),
                            icon: icon
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct BorderPreview: View {
        @State private var state: VRectangularToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRectangularToggleButton(
                    uiModel: {
                        var uiModel: VRectangularToggleButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VRectangularToggleButtonUIModel.StateColors(
                            off: uiModel.backgroundColors.off.darken(by: 0.3),
                            on: uiModel.backgroundColors.on.darken(by: 0.3),
                            pressedOff: uiModel.backgroundColors.pressedOff.darken(by: 0.3),
                            pressedOn: uiModel.backgroundColors.pressedOn.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    state: $state,
                    icon: icon
                )
            })
        }
    }

    private struct ShadowPreview: View {
        @State private var state: VRectangularToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRectangularToggleButton(
                    uiModel: {
                        var uiModel: VRectangularToggleButtonUIModel = .init()
                        uiModel.shadowColors = VRectangularToggleButtonUIModel.StateColors(
                            off: GlobalUIModel.Common.shadowColorEnabled,
                            on: GlobalUIModel.Common.shadowColorEnabled,
                            pressedOff: GlobalUIModel.Common.shadowColorEnabled,
                            pressedOn: GlobalUIModel.Common.shadowColorEnabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.shadowRadius = 3
                        uiModel.shadowOffset = CGPoint(x: 0, y: 3)
                        return uiModel
                    }(),
                    state: $state,
                    icon: icon
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        @State private var state: VRectangularToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRectangularToggleButton(
                    uiModel: {
                        var uiModel: VRectangularToggleButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VRectangularToggleButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    state: $state,
                    icon: icon
                )
            })
        }
    }
}
