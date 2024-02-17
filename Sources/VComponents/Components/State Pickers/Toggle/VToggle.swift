//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Toggle
/// State picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VToggleState = .on
///
///     var body: some View {
///         VToggle(
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
///         VToggle(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // ???
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VToggle<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VToggleUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VToggleState
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VToggleInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Label
    private let label: VToggleLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VToggle` with state.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VToggle` with state and title.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VToggle` with state and label.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder label: @escaping (VToggleInternalState) -> Label
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
                toggleView

            case .title(let title):
                labeledToggleView(label: {
                    baseButtonView(label: { internalState in
                        Text(title)
                            .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                            .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
                            .font(uiModel.titleTextFont)
                    })
                    .blocksHitTesting(!uiModel.labelIsClickable)
                })

            case .label(let label):
                labeledToggleView(label: {
                    baseButtonView(label: label)
                        .blocksHitTesting(!uiModel.labelIsClickable)
                })
            }
        })
    }
    
    private var toggleView: some View {
        baseButtonView(label: { internalState in
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                    .foregroundStyle(uiModel.fillColors.value(for: internalState))

                let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)
                if borderWidth > 0 {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
                }

                Circle()
                    .frame(dimension: uiModel.thumbDimension)
                    .foregroundStyle(uiModel.thumbColors.value(for: internalState))
                    .offset(x: thumbOffset(internalState: internalState))
            })
            .frame(size: uiModel.size)
        })
    }

    private func labeledToggleView<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: uiModel.toggleAndLabelSpacing, content: {
            toggleView
            label()
        })
    }

    private func baseButtonView(
        label: @escaping (VToggleInternalState) -> some View
    ) -> some View {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VToggleInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(uiModel.appliesStateChangeAnimation, transform: {
                        $0
                            .animation(uiModel.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    })
            }
        )
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#endif
    }
    
    // MARK: Thumb Position
    private func thumbOffset(
        internalState: VToggleInternalState
    ) -> CGFloat {
        let offset: CGFloat = uiModel.thumbOffset
        
        switch internalState {
        case .off: return -offset
        case .on: return offset
        case .pressedOff: return -offset
        case .pressedOn: return offset
        case .disabled: return -offset
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VToggleState = .on

        var body: some View {
            PreviewContainer(content: {
                VToggle(
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
            VToggle(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed Off", content: {
            VToggle(
                uiModel: {
                    var uiModel: VToggleUIModel = .init()
                    uiModel.fillColors.off = uiModel.fillColors.pressedOff
                    uiModel.borderColors.off = uiModel.borderColors.pressedOff
                    uiModel.thumbColors.off = uiModel.thumbColors.pressedOff
                    uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
                    return uiModel
                }(),
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("On", content: {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Pressed On", content: {
            VToggle(
                uiModel: {
                    var uiModel: VToggleUIModel = .init()
                    uiModel.fillColors.on = uiModel.fillColors.pressedOn
                    uiModel.borderColors.on = uiModel.borderColors.pressedOn
                    uiModel.thumbColors.on = uiModel.thumbColors.pressedOn
                    uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                    return uiModel
                }(),
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        })

        PreviewHeader("Native")

        PreviewRow("Off", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        })

        PreviewRow("On", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(true)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        })

        PreviewRow("Disabled", content: {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .disabled(true)
        })
    })
})

#endif

#endif
