//
//  VStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched Button
/// Stretched button component that performs action when triggered.
///
///     var body: some View {
///         VStretchedButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///         .padding(.horizontal)
///     }
///
/// On `macOS` and `watchOS`, an explicit width should be provided.
@available(tvOS, unavailable) // Doesn't follow HIG
public struct VStretchedButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VStretchedButtonUIModel

    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VStretchedButtonInternalState {
        baseButtonState
    }

    private let action: () -> Void

    private let label: VStretchedButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VStretchedButton` with action and title.
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VStretchedButton` with action and icon.
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }

    /// Initializes `VStretchedButton` with action, icon, and title.
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .titleAndIcon(title: title, icon: icon)
    }
    
    /// Initializes `VStretchedButton` with action and label.
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VStretchedButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self.action = action
        self.label = .label(label: label)
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
                let internalState: VStretchedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView(internalState: internalState) }) // Has own rounding
                    .overlay(content: { borderView(internalState: internalState) }) // Has own rounding
            }
        )
    }
    
    private func labelView(
        internalState: VStretchedButtonInternalState
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

            case .label(let label):
                label(internalState)
            }
        })
        .frame(maxWidth: .infinity)
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .dynamicTypeSize(...uiModel.titleTextDynamicTypeSizeMax)
    }
    
    private func iconLabelViewComponent(
        internalState: VStretchedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundStyle(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
    }
    
    private func backgroundView(
        internalState: VStretchedButtonInternalState
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
    
    @ViewBuilder private func borderView(
        internalState: VStretchedButtonInternalState
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

#if !os(tvOS)

#Preview("*", body: {
    PreviewContainer(content: {
        VStretchedButton(
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(Preview_StretchedButtonFrameModifier())
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VStretchedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
        })

        PreviewRow("Pressed", content: {
            VStretchedButton(
                uiModel: {
                    var uiModel: VStretchedButtonUIModel = .init()
                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                    return uiModel
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
        })

        PreviewRow("Disabled", content: {
            VStretchedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
            .disabled(true)
        })
    })
})

#endif

#endif
