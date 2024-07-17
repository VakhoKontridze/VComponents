//
//  VRectangularButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Button
/// Rectangular button component that performs action when triggered.
///
///     var body: some View {
///         VRectangularButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties
    private let uiModel: VRectangularButtonUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRectangularButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    private let action: () -> Void

    private let label: VRectangularButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VRectangularButton` with action and title.
    public init(
        uiModel: VRectangularButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VRectangularButton` with action and icon.
    public init(
        uiModel: VRectangularButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VRectangularButton` with action and custom label.
    public init(
        uiModel: VRectangularButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VRectangularButtonInternalState) -> CustomLabel
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
                let internalState: VRectangularButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(size: uiModel.size)
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { backgroundView(internalState: internalState) }) // Has own rounding
                    .overlay(content: { borderView(internalState: internalState) }) // Has own rounding
                    .padding(uiModel.hitBox)
            }
        )
    }
    
    private func labelView(
        internalState: VRectangularButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)
                
            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)
                
            case .custom(let custom):
                custom(internalState)
            }
        })
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VRectangularButtonInternalState,
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
        internalState: VRectangularButtonInternalState,
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
        internalState: VRectangularButtonInternalState
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
        internalState: VRectangularButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
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
        VRectangularButton(
            action: {},
            title: "ABC"
        )

        VRectangularButton(
            action: {},
            icon: Image(systemName: "swift")
        )
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VRectangularButton(
                action: {},
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("Pressed", content: {
            VRectangularButton(
                uiModel: {
                    var uiModel: VRectangularButtonUIModel = .init()
                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                    uiModel.iconColors!.enabled = uiModel.iconColors!.pressed // Force-unwrap
                    return uiModel
                }(),
                action: {},
                icon: Image(systemName: "swift")
            )
        })

        PreviewRow("Disabled", content: {
            VRectangularButton(
                action: {},
                icon: Image(systemName: "swift")
            )
            .disabled(true)
        })
    })
})

#endif

#endif
