//
//  VWrappedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Wrapped Button
/// Wrapped button component that performs action when triggered.
///
///     var body: some View {
///         VWrappedButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VWrappedButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties
    private let uiModel: VWrappedButtonUIModel

    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VWrappedButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    private let action: () -> Void

    private let label: VWrappedButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VWrappedButton` with action and title.
    public init(
        uiModel: VWrappedButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VWrappedButton` with action and icon.
    public init(
        uiModel: VWrappedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }

    /// Initializes `VWrappedButton` with action, icon, and title.
    public init(
        uiModel: VWrappedButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .titleAndIcon(title: title, icon: icon)
    }
    
    /// Initializes `VWrappedButton` with action and custom label.
    public init(
        uiModel: VWrappedButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VWrappedButtonInternalState) -> CustomLabel
    ) {
        self.uiModel = uiModel
        self.action = action
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                action()
            },
            label: { baseButtonState in
                let internalState: VWrappedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView(internalState: internalState) }) // Has own rounding
                    .overlay(content: { borderView(internalState: internalState) }) // Has own rounding
                    .padding(uiModel.hitBox)
            }
        )
    }
    
    private func labelView(
        internalState: VWrappedButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch uiModel.titleTextAndIconPlacement {
                case .titleAndIcon:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        titleLabelViewComponent(internalState: internalState, title: title)
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                    })

                case .iconAndTitle:
                    HStack(spacing: uiModel.titleTextAndIconSpacing, content: {
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                        titleLabelViewComponent(internalState: internalState, title: title)
                    })
                }

            case .custom(let custom):
                custom(internalState)
            }
        })
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VWrappedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .applyIfLet(uiModel.iconDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
    }
    
    private func iconLabelViewComponent(
        internalState: VWrappedButtonInternalState,
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
        internalState: VWrappedButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.backgroundPressedScale : 1)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    @ViewBuilder
    private func borderView(
        internalState: VWrappedButtonInternalState
    ) -> some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.backgroundPressedScale : 1)
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

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(visionOS))

#Preview("*", body: {
    PreviewContainer(content: {
        VWrappedButton(
            action: {},
            title: "Lorem Ipsum"
        )
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VWrappedButton(
                action: {},
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Pressed", content: {
            VWrappedButton(
                uiModel: {
                    var uiModel: VWrappedButtonUIModel = .init()
                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                    return uiModel
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VWrappedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .disabled(true)
        })
    })
})

#endif

#endif
