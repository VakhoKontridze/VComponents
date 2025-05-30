//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Plain Button
/// Plain button component that performs action when triggered.
///
///     var body: some View {
///         VPlain(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VPlainButton<CustomLabel>: View, Sendable where CustomLabel: View {
    // MARK: Properties - UI Model
    private let uiModel: VPlainButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VPlainButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VPlainButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VPlainButton` with action and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VPlainButton` with action and icon.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VPlainButton` with action, icon, and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
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
    
    /// Initializes `VPlainButton` with action and custom label.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VPlainButtonInternalState) -> CustomLabel
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
                let internalState: VPlainButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
            }
        )
    }
    
    private func labelView(
        internalState: VPlainButtonInternalState
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
        .padding(uiModel.hitBox)
    }
    
    private func titleLabelViewComponent(
        internalState: VPlainButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .applyIfLet(uiModel.titleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
    }
    
    private func iconLabelViewComponent(
        internalState: VPlainButtonInternalState,
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

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*", body: {
    PreviewContainer(content: {
        VPlainButton(
            action: {},
            title: "Lorem Ipsum"
        )

        VPlainButton(
            action: {},
            icon: Image(systemName: "swift")
        )
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VPlainButton(
                action: {},
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Pressed", content: {
            VPlainButton(
                uiModel: {
                    var uiModel: VPlainButtonUIModel = .init()
                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                    return uiModel
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VPlainButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .disabled(true)
        })

        PreviewHeader("Native")

        PreviewRow("Enabled", content: {
            Button(
                "Lorem Ipsum",
                action: {}
            )
            .buttonStyle(.plain)
            .foregroundStyle(Color.blue)
        })

        PreviewRow("Disabled", content: {
            Button(
                "Lorem Ipsum",
                action: {}
            )
            .buttonStyle(.plain)
            .foregroundStyle(Color.blue)
            .disabled(true)
        })
    })
})

#endif

#endif
