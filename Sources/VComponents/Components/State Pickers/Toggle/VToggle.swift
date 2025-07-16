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
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VToggle<CustomLabel>: View where CustomLabel: View {
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
    private let label: VToggleLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VToggle` with state.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>
    )
        where CustomLabel == Never
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
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VToggle` with state and custom label.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder label customLabel: @escaping (VToggleInternalState) -> CustomLabel
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        Group {
            switch label {
            case .empty:
                toggleView

            case .title(let title):
                labeledToggleView {
                    baseButtonView { internalState in
                        Text(title)
                            .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                            .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
                            .font(uiModel.titleTextFont)
                            .applyIfLet(uiModel.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                    }
                    .blocksHitTesting(!uiModel.labelIsClickable)
                }

            case .custom(let custom):
                labeledToggleView {
                    baseButtonView(label: custom)
                        .blocksHitTesting(!uiModel.labelIsClickable)
                }
            }
        }
    }
    
    private var toggleView: some View {
        baseButtonView { internalState in
            ZStack {
                RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                    .foregroundStyle(uiModel.fillColors.value(for: internalState))

                let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)
                if borderWidth > 0 {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
                }

                RoundedRectangle(cornerRadius: uiModel.thumbCornerRadius)
                    .frame(size: uiModel.thumbSize)
                    .foregroundStyle(uiModel.thumbColors.value(for: internalState))
                    .offset(x: thumbOffset(internalState: internalState))
            }
            .frame(size: uiModel.size)
        }
    }

    private func labeledToggleView<Content>(
        label: () -> Content
    ) -> some View
        where Content: View
    {
        HStack(spacing: uiModel.toggleAndLabelSpacing) {
            toggleView
            label()
        }
    }

    private func baseButtonView<Content>(
        label: @escaping (VToggleInternalState) -> Content
    ) -> some View
        where Content: View
    {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                state.setNextState()
            },
            label: { baseButtonState in
                let internalState: VToggleInternalState = internalState(baseButtonState)

                label(internalState)
                    .applyIf(uiModel.appliesStateChangeAnimation) {
                        $0
                            .animation(uiModel.stateChangeAnimation, value: state)
                            .animation(nil, value: baseButtonState == .pressed) // Pressed state isn't shared between children
                    }
            }
        )
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#elseif os(watchOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#endif
    }
    
    // MARK: Thumb Position
    private func thumbOffset(
        internalState: VToggleInternalState
    ) -> CGFloat {
        let offset: CGFloat = {
            let thumbWidth: CGFloat = uiModel.thumbSize.width
            let spacing: CGFloat = (uiModel.size.height - thumbWidth)/2
            let thumbStartPoint: CGFloat = (uiModel.size.width - thumbWidth)/2
            let offset: CGFloat = thumbStartPoint - spacing
            
            return offset
        }()

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

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VToggleState = .on

    PreviewContainer {
        VToggle(
            state: $state,
            title: "Lorem ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Off") {
            VToggle(
                state: .constant(.off),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed Off") {
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
        }

        PreviewRow("On") {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
        }

        PreviewRow("Pressed On") {
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
        }

        PreviewRow("Disabled") {
            VToggle(
                state: .constant(.on),
                title: "Lorem ipsum"
            )
            .disabled(true)
        }

        PreviewHeader("Native")

        PreviewRow("Off") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        }

        PreviewRow("On") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(true)
            )
            .labelsHidden()
            .toggleStyle(.switch)
        }

        PreviewRow("Disabled") {
            Toggle(
                "Lorem ipsum",
                isOn: .constant(false)
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .disabled(true)
        }
    }
}

#endif

#endif
