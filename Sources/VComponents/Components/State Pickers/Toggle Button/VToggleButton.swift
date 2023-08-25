//
//  VToggleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Toggle Button
/// Colored state picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VToggleButtonState = .on
///
///     var body: some View {
///         VToggleButton(
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
///         VToggleButton(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support.
public struct VToggleButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VToggleButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VToggleButtonState
    private var internalState: VToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VToggleButtonLabel<Label>

    // MARK: Initializers
    /// Initializes `VToggleButton` with state and title.
    public init(
        uiModel: VToggleButtonUIModel = .init(),
        state: Binding<VToggleButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }

    /// Initializes `VToggleButton` with state, icon, and title.
    public init(
        uiModel: VToggleButtonUIModel = .init(),
        state: Binding<VToggleButtonState>,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .iconTitle(icon: icon, title: title)
    }

    /// Initializes `VToggleButton` with state and label.
    public init(
        uiModel: VToggleButtonUIModel = .init(),
        state: Binding<VToggleButtonState>,
        @ViewBuilder label: @escaping (VToggleButtonInternalState) -> Label
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
                    .frame(height: uiModel.height)
                    .cornerRadius(uiModel.cornerRadius) // Prevents large content from overflowing
                    .background(background) // Has own rounding
                    .overlay(border) // Has own rounding
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

            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.iconAndTitleTextSpacing, content: {
                    iconLabelComponent(icon: icon)
                    titleLabelComponent(title: title)
                })

            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState.isPressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
        .applyModifier({
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                $0.dynamicTypeSize(...(.accessibility3))
            } else {
                $0
            }
        })
    }

    private func titleLabelComponent(
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor({
                if #available(iOS 15.0, *) {
                    return uiModel.titleTextMinimumScaleFactor
                } else {
                    return uiModel.titleTextMinimumScaleFactor/2 // Alternative to dynamic size upper limit
                }
            }())
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
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
extension VToggleButtonInternalState {
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
struct VToggleButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }

    // Data
    private static var icon: Image { .init(systemName: "swift") }
    private static var title: String { "Lorem ipsum".pseudoRTL(languageDirection) }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VToggleButton(
                    state: $state,
                    title: title
                )

                VToggleButton(
                    state: $state,
                    icon: icon,
                    title: title
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
                        VToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VToggleButton(
                            uiModel: {
                                var uiModel: VToggleButtonUIModel = .init()
                                uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                                uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                                return uiModel
                            }(),
                            state: .constant(.off),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "On",
                    content: {
                        VToggleButton(
                            state: .constant(.on),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VToggleButton(
                            uiModel: {
                                var uiModel: VToggleButtonUIModel = .init()
                                uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                                uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                                return uiModel
                            }(),
                            state: .constant(.on),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }
}
