//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box
/// State picker component that toggles between `off`, `on`, and `indeterminate` states, and displays label.
///
///     @State private var state: VCheckBoxState = .on
///
///     var body: some View {
///         VCheckBox(
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
///         VCheckBox(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // No `SwiftUIGestureBaseButton` support
@available(watchOS, unavailable) // No `SwiftUIGestureBaseButton` support
public struct VCheckBox<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VCheckBoxUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState {
        .init(
            isEnabled: isEnabled,
            state: state,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VCheckBoxLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VCheckBox` with state.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VCheckBox` with state and title.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VCheckBox` with state and label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label: @escaping (VCheckBoxInternalState) -> Label
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
                checkBox
                
            case .title(let title):
                labeledCheckBox(label: {
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
                labeledCheckBox(label: {
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
    
    private var checkBox: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .foregroundStyle(uiModel.fillColors.value(for: internalState))
                    
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                    
                    if let checkmarkIcon {
                        checkmarkIcon
                            .resizable()
                            .scaledToFit()
                            .frame(dimension: uiModel.checkmarkIconDimension)
                            .foregroundStyle(uiModel.checkmarkIconColors.value(for: internalState))
                    }
                })
                .frame(dimension: uiModel.dimension)
                .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                .padding(uiModel.checkboxHitBox)
            }
        )
    }

    private func labeledCheckBox<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: 0, content: {
            checkBox
            spacer
            label()
        })
    }

    private var spacer: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: uiModel.checkBoxAndLabelSpacing)
                    .foregroundStyle(.clear)
            }
        )
        .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
    }

    // MARK: Checkmark Icon
    private var checkmarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff:
            return nil

        case .on, .pressedOn:
            return uiModel.checkmarkIconOn.renderingMode(.template)

        case .indeterminate, .pressedIndeterminate:
            return uiModel.checkmarkIconIndeterminate.renderingMode(.template)

        case .disabled:
            return nil
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

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VCheckBoxState = .on

        var body: some View {
            PreviewContainer(content: {
                VCheckBox(
                    state: $state,
                    title: "Lorem ipsum"
                )
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Off", content: {
            VCheckBox(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed Off", content: {
            VCheckBox(
                uiModel: {
                    var uiModel: VCheckBoxUIModel = .init()
                    uiModel.fillColors.off = uiModel.fillColors.pressedOff
                    uiModel.borderColors.off = uiModel.borderColors.pressedOff
                    uiModel.checkmarkIconColors.off = uiModel.checkmarkIconColors.pressedOff
                    uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                    return uiModel
                }(),
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("On", content: {
            VCheckBox(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed On", content: {
            VCheckBox(
                uiModel: {
                    var uiModel: VCheckBoxUIModel = .init()
                    uiModel.fillColors.on = uiModel.fillColors.pressedOn
                    uiModel.borderColors.on = uiModel.borderColors.pressedOn
                    uiModel.checkmarkIconColors.on = uiModel.checkmarkIconColors.pressedOn
                    uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                    return uiModel
                }(),
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Indeterminate", content: {
            VCheckBox(
                state: .constant(.indeterminate),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed Indeterminate", content: {
            VCheckBox(
                uiModel: {
                    var uiModel: VCheckBoxUIModel = .init()
                    uiModel.fillColors.indeterminate = uiModel.fillColors.pressedIndeterminate
                    uiModel.borderColors.indeterminate = uiModel.borderColors.pressedIndeterminate
                    uiModel.checkmarkIconColors.indeterminate = uiModel.checkmarkIconColors.pressedIndeterminate
                    uiModel.titleTextColors.indeterminate = uiModel.titleTextColors.pressedIndeterminate
                    return uiModel
                }(),
                state: .constant(.indeterminate),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VCheckBox(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        })

#if os(macOS)
        PreviewHeader("Native")

        PreviewRow("Off", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .toggleStyle(.checkbox)
        })

        PreviewRow("On", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(true)
            )
            .toggleStyle(.checkbox)
        })

        PreviewRow("Disabled", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .toggleStyle(.checkbox)
            .disabled(true)
        })
#endif
    })
})

#endif

#endif
