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
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VCheckBox<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - UI Model
    private let uiModel: VCheckBoxUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VCheckBoxState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VCheckBoxInternalState {
        .init(
            isEnabled: isEnabled,
            state: state,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VCheckBoxLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VCheckBox` with state.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where CustomLabel == Never
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
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VCheckBox` with state and custom label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label customLabel: @escaping (VCheckBoxInternalState) -> CustomLabel
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        Group(content: {
            switch label {
            case .empty:
                checkBoxView
                
            case .title(let title):
                labeledCheckBoxView(label: {
                    baseButtonView(label: { internalState in
                        Text(title)
                            .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                            .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
                            .font(uiModel.titleTextFont)
                            .applyIfLet(uiModel.titleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                    })
                    .blocksHitTesting(!uiModel.labelIsClickable)
                })

            case .custom(let custom):
                labeledCheckBoxView(label: {
                    baseButtonView(label: custom)
                        .blocksHitTesting(!uiModel.labelIsClickable)
                })
            }
        })
    }
    
    private var checkBoxView: some View {
        baseButtonView(label: { internalState in
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                    .foregroundStyle(uiModel.fillColors.value(for: internalState))

                if uiModel.borderWidth > 0 {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                }

                if let checkmarkIcon: Image = checkmarkIcon(internalState: internalState) {
                    checkmarkIcon
                        .applyIf(uiModel.isCheckmarkIconResizable, transform: { $0.resizable() })
                        .applyIfLet(uiModel.checkmarkIconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
                        .applyIfLet(uiModel.checkmarkIconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
                        .applyIfLet(uiModel.checkmarkIconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
                        .font(uiModel.checkmarkIconFont)
                        .applyIfLet(uiModel.checkmarkIconDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                        .frame(size: uiModel.checkmarkIconSize)
                }
            })
            .frame(size: uiModel.size)
            .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
            .padding(uiModel.checkboxHitBox)
        })
    }

    private func labeledCheckBoxView<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: uiModel.checkBoxAndLabelSpacing, content: {
            checkBoxView
            label()
        })
    }

    private func baseButtonView(
        label: @escaping (VCheckBoxInternalState) -> some View
    ) -> some View {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VCheckBoxInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(uiModel.appliesStateChangeAnimation, transform: {
                        $0
                            .animation(uiModel.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    })
            }
        )
    }

    // MARK: Checkmark Icon
    private func checkmarkIcon(
        internalState: VCheckBoxInternalState
    ) -> Image? {
        switch internalState {
        case .off, .pressedOff: nil
        case .on, .pressedOn: uiModel.checkmarkIconOn
        case .indeterminate, .pressedIndeterminate: uiModel.checkmarkIconIndeterminate
        case .disabled: nil
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

#if !(os(tvOS) || os(watchOS) || os(visionOS))

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
                    uiModel.checkmarkIconColors!.off = uiModel.checkmarkIconColors!.pressedOff // Force-unwrap
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
                    uiModel.checkmarkIconColors!.on = uiModel.checkmarkIconColors!.pressedOn // Force-unwrap
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
                    uiModel.checkmarkIconColors!.indeterminate = uiModel.checkmarkIconColors!.pressedIndeterminate // Force-unwrap
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
