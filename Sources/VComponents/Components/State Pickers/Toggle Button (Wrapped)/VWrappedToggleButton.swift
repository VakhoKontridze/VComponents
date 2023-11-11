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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support
@available(watchOS, unavailable) // No `SwiftUIGestureBaseButton` support
public struct VWrappedToggleButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VWrappedToggleButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VWrappedToggleButtonState
    private var internalState: VWrappedToggleButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
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
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .iconTitle(icon: icon, title: title)
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
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                toggleLabel
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView }) // Has own rounding
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

            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.iconAndTitleTextSpacing, content: {
                    iconLabelComponent(icon: icon)
                    titleLabelComponent(title: title)
                })

            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState.isPressedOffPressedOn ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }

    private func titleLabelComponent(
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
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

    @ViewBuilder private var border: some View {
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
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VWrappedToggleButton_Previews: PreviewProvider {
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
    private static var title: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    private static var icon: Image { .init(systemName: "swift") }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VWrappedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VWrappedToggleButton(
                    state: $state,
                    title: title
                )

                VWrappedToggleButton(
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
                        VWrappedToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VWrappedToggleButton(
                            uiModel: {
                                var uiModel: VWrappedToggleButtonUIModel = .init()
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
                        VWrappedToggleButton(
                            state: .constant(.on),
                            title: title
                        )
                    }
                )

                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VWrappedToggleButton(
                            uiModel: {
                                var uiModel: VWrappedToggleButtonUIModel = .init()
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
                        VWrappedToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct BorderPreview: View {
        @State private var state: VWrappedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VWrappedToggleButton(
                    uiModel: {
                        var uiModel: VWrappedToggleButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VWrappedToggleButtonUIModel.StateColors(
                            off: uiModel.backgroundColors.off.darken(by: 0.3),
                            on: uiModel.backgroundColors.on.darken(by: 0.3),
                            pressedOff: uiModel.backgroundColors.pressedOff.darken(by: 0.3),
                            pressedOn: uiModel.backgroundColors.pressedOn.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    state: $state,
                    title: title
                )
            })
        }
    }

    private struct ShadowPreview: View {
        @State private var state: VWrappedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VWrappedToggleButton(
                    uiModel: {
                        var uiModel: VWrappedToggleButtonUIModel = .init()
                        uiModel.shadowColors = VWrappedToggleButtonUIModel.StateColors(
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
                    title: title
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        @State private var state: VWrappedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VWrappedToggleButton(
                    uiModel: {
                        var uiModel: VWrappedToggleButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VWrappedToggleButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    state: $state,
                    icon: icon,
                    title: title
                )
            })
        }
    }
}
