//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button
/// State picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VRadioButtonState = .on
///
///     var body: some View {
///         VRadioButton(
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
///         VRadioButton(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // No `SwiftUIGestureBaseButton`
@available(watchOS, unavailable) // No `SwiftUIGestureBaseButton`
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRadioButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VRadioButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VRadioButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VRadioButton` with state.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VRadioButton` with state and title.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VRadioButton` with state and label.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder label: @escaping (VRadioButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .label(label: label)
    }
    
    // MARK: Body
    public var body: some View {
        Group(content: {
            switch label {
            case .empty:
                radioButton
                
            case .title(let title):
                labeledRadioButton(label: {
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            Text(title)
                                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                                .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                                .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
                                .font(uiModel.titleTextFont)
                        }
                    )
                    .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
                
            case .label(let label):
                labeledRadioButton(label: {
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            label(internalState)
                        }
                    )
                    .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
            }
        })
        .applyIf(uiModel.appliesStateChangeAnimation, transform: {
            $0.animation(uiModel.stateChangeAnimation, value: internalState)
        })
    }
    
    private var radioButton: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    Circle()
                        .frame(dimension: uiModel.dimension)
                        .foregroundStyle(uiModel.fillColors.value(for: internalState))

                    if uiModel.borderWidth > 0 {
                        Circle()
                            .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                            .frame(dimension: uiModel.dimension)
                    }

                    Circle()
                        .frame(dimension: uiModel.bulletDimension)
                        .foregroundStyle(uiModel.bulletColors.value(for: internalState))
                })
                .frame(dimension: uiModel.dimension)
                .padding(uiModel.radioButtonHitBox)
            }
        )
    }

    private func labeledRadioButton<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: 0, content: {
            radioButton
            spacerView
            label()
        })
    }

    private var spacerView: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: uiModel.radioButtonAndLabelSpacing)
                    .foregroundStyle(.clear)
            }
        )
        .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
    }
    
    // MARK: Actions
    private func stateChangeHandler(gestureState: GestureBaseButtonGestureState) {
        isPressed = gestureState.didRecognizePress
        
        if gestureState.didRecognizeClick {
            playHapticEffect()
            state.setNextStateRadio()
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
extension VRadioButtonState {
    mutating fileprivate func setNextStateRadio() {
        switch self {
        case .off: self = .on
        case .on: break
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VRadioButtonState = .on

        var body: some View {
            PreviewContainer(content: {
                VRadioButton(
                    state: $state,
                    title: "Lorem ipsum"
                )

                VPlainButton(
                    action: { state.setNextState() },
                    title: "Toggle State"
                )
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Off", content: {
            VRadioButton(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed Off", content: {
            VRadioButton(
                uiModel: {
                    var uiModel: VRadioButtonUIModel = .init()
                    uiModel.fillColors.off = uiModel.fillColors.pressedOff
                    uiModel.borderColors.off = uiModel.borderColors.pressedOff
                    uiModel.bulletColors.off = uiModel.bulletColors.pressedOff
                    uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                    return uiModel
                }(),
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("On", content: {
            VRadioButton(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed On", content: {
            VRadioButton(
                uiModel: {
                    var uiModel: VRadioButtonUIModel = .init()
                    uiModel.fillColors.on = uiModel.fillColors.pressedOn
                    uiModel.borderColors.on = uiModel.borderColors.pressedOn
                    uiModel.bulletColors.on = uiModel.bulletColors.pressedOn
                    uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                    return uiModel
                }(),
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VRadioButton(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        })
    })
})

#endif

#endif
