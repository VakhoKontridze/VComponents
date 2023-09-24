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

    /// Initializes `VStretchedToggleButton` with state, icon, and title.
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .iconTitle(icon: icon, title: title)
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
                toggleLabel
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(RoundedRectangle(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { background }) // Has own rounding
                    .overlay(content: { border }) // Has own rounding
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
        .frame(maxWidth: .infinity)
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

    private var background: some View {
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
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VStretchedToggleButton_Previews: PreviewProvider {
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
        @State private var state: VStretchedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VStretchedToggleButton(
                    state: $state,
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)

                VStretchedToggleButton(
                    state: $state,
                    icon: icon,
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Off",
                    content: {
                        VStretchedToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "Pressed Off",
                    content: {
                        VStretchedToggleButton(
                            uiModel: {
                                var uiModel: VStretchedToggleButtonUIModel = .init()
                                uiModel.backgroundColors.off = uiModel.backgroundColors.pressedOff
                                uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                                return uiModel
                            }(),
                            state: .constant(.off),
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "On",
                    content: {
                        VStretchedToggleButton(
                            state: .constant(.on),
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "Pressed On",
                    content: {
                        VStretchedToggleButton(
                            uiModel: {
                                var uiModel: VStretchedToggleButtonUIModel = .init()
                                uiModel.backgroundColors.on = uiModel.backgroundColors.pressedOn
                                uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                                return uiModel
                            }(),
                            state: .constant(.on),
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                    }
                )

                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VStretchedToggleButton(
                            state: .constant(.off),
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct BorderPreview: View {
        @State private var state: VStretchedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VStretchedToggleButton(
                    uiModel: {
                        var uiModel: VStretchedToggleButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VStretchedToggleButtonUIModel.StateColors(
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
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    private struct ShadowPreview: View {
        @State private var state: VStretchedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VStretchedToggleButton(
                    uiModel: {
                        var uiModel: VStretchedToggleButtonUIModel = .init()
                        uiModel.shadowColors = VStretchedToggleButtonUIModel.StateColors(
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
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        @State private var state: VStretchedToggleButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VStretchedToggleButton(
                    uiModel: {
                        var uiModel: VStretchedToggleButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VStretchedToggleButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    state: $state,
                    icon: icon,
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    // Helpers
    typealias StretchedButtonWidthModifier = VStretchedButton_Previews.StretchedButtonWidthModifier
}
