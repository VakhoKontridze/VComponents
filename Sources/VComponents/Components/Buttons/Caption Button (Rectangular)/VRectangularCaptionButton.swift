//
//  VRectangularCaptionButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Caption Button
/// Rectangular captioned button component that performs action when triggered.
///
///     var body: some View {
///         VRectangularCaptionButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift"),
///             titleCaption: "Lorem Ipsum"
///         )
///     }
///
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularCaptionButton<CustomCaption>: View where CustomCaption: View {
    // MARK: Properties
    private let uiModel: VRectangularCaptionButtonUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRectangularCaptionButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    private let action: () -> Void
    
    private let icon: Image

    private let caption: VRectangularCaptionButtonCaption<CustomCaption>

    // MARK: Initializers
    /// Initializes `VRectangularCaptionButton` with action, icon, and title caption.
    public init(
        uiModel: VRectangularCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleCaption: String
    )
        where CustomCaption == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .title(title: titleCaption)
    }

    /// Initializes `VRectangularCaptionButton` with action, icon, and icon caption.
    public init(
        uiModel: VRectangularCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        iconCaption: Image
    )
        where CustomCaption == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .icon(icon: iconCaption)
    }

    /// Initializes `VRectangularCaptionButton` with action, icon, icon caption, and title caption.
    public init(
        uiModel: VRectangularCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleCaption: String,
        iconCaption: Image
    )
        where CustomCaption == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .titleAndIcon(title: titleCaption, icon: iconCaption)
    }
    
    /// Initializes `VRectangularCaptionButton` with action, icon, and custom caption.
    public init(
        uiModel: VRectangularCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder caption customCaption: @escaping (VRectangularCaptionButtonInternalState) -> CustomCaption
    ) {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .custom(custom: customCaption)
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
                let internalState: VRectangularCaptionButtonInternalState = internalState(baseButtonState)
                
                VStack(spacing: uiModel.rectangleAndCaptionSpacing, content: {
                    rectangleView(internalState: internalState)
                    captionView(internalState: internalState)
                })
                .contentShape(.rect) // Registers gestures even when clear
            }
        )
    }
    
    private func rectangleView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Group(content: { // `Group` is used for adding multiple frames
            rectangleIcon(
                internalState: internalState
            )
        })
        .frame(size: uiModel.rectangleSize)
        .background(content: { rectangleBackgroundView(internalState: internalState) })
        .overlay(content: { rectangleBorderView(internalState: internalState) })
        .clipShape(.rect(cornerRadius: uiModel.rectangleCornerRadius))
    }

    private func rectangleIcon(
        internalState: VPlainButtonInternalState
    ) -> some View {
        icon
            .applyIf(uiModel.isIconResizable, transform: { $0.resizable() })
            .applyIfLet(uiModel.iconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
            .applyIfLet(uiModel.iconColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
            .applyIfLet(uiModel.iconOpacities, transform: { $0.opacity($1.value(for: internalState)) })
            .font(uiModel.iconFont)
            .applyIfLet(uiModel.iconDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
            .frame(size: uiModel.iconSize)
            .scaleEffect(internalState == .pressed ? uiModel.iconPressedScale : 1)
            .padding(uiModel.iconMargins)
    }

    private func rectangleBackgroundView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState == .pressed ? uiModel.rectanglePressedScale : 1)
            .foregroundStyle(uiModel.rectangleColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    @ViewBuilder 
    private func rectangleBorderView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = uiModel.rectangleBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.rectangleCornerRadius)
                .strokeBorder(uiModel.rectangleBorderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.rectanglePressedScale : 1)
        }
    }
    
    private func captionView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Group(content: {
            switch caption {
            case .title(let title):
                titleCaptionViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconCaptionViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch uiModel.titleCaptionTextAndIconCaptionPlacement {
                case .titleAndIcon:
                    HStack(spacing: uiModel.titleCaptionTextAndIconCaptionSpacing, content: {
                        titleCaptionViewComponent(internalState: internalState, title: title)
                        iconCaptionViewComponent(internalState: internalState, icon: icon)
                    })

                case .iconAndTitle:
                    HStack(spacing: uiModel.titleCaptionTextAndIconCaptionSpacing, content: {
                        iconCaptionViewComponent(internalState: internalState, icon: icon)
                        titleCaptionViewComponent(internalState: internalState, title: title)
                    })
                }

            case .custom(let custom):
                custom(internalState)
            }
        })
        .frame(
            maxWidth: uiModel.captionWidthMax,
            alignment: Alignment(
                horizontal: uiModel.captionFrameAlignment,
                vertical: .center
            )
        )
        .scaleEffect(internalState == .pressed ? uiModel.captionPressedScale : 1)
    }
    
    private func titleCaptionViewComponent(
        internalState: VRectangularCaptionButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .multilineTextAlignment(uiModel.titleCaptionTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.titleCaptionTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.titleCaptionTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleCaptionTextColors.value(for: internalState))
            .font(uiModel.titleCaptionTextFont)
            .applyIfLet(uiModel.titleCaptionTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
    }
    
    private func iconCaptionViewComponent(
        internalState: VRectangularCaptionButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(uiModel.isIconCaptionResizable, transform: { $0.resizable() })
            .applyIfLet(uiModel.iconCaptionContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
            .applyIfLet(uiModel.iconCaptionColors, transform: { $0.foregroundStyle($1.value(for: internalState)) })
            .applyIfLet(uiModel.iconCaptionOpacities, transform: { $0.opacity($1.value(for: internalState)) })
            .font(uiModel.iconCaptionFont)
            .applyIfLet(uiModel.iconCaptionDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
            .frame(size: uiModel.iconCaptionSize)
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

#if !(os(macOS) || os(tvOS) || os(visionOS))

#Preview("*", body: {
    PreviewContainer(content: {
        VRectangularCaptionButton(
            action: {},
            icon: Image(systemName: "swift"),
            titleCaption: "Lorem Ipsum"
        )
    })
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VRectangularCaptionButton(
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
        })

        PreviewRow("Pressed", content: {
            VRectangularCaptionButton(
                uiModel: {
                    var uiModel: VRectangularCaptionButtonUIModel = .init()
                    uiModel.rectangleColors.enabled = uiModel.rectangleColors.pressed
                    uiModel.iconColors!.enabled = uiModel.iconColors!.pressed // Force-unwrap
                    uiModel.titleCaptionTextColors.enabled = uiModel.titleCaptionTextColors.pressed
                    return uiModel
                }(),
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
        })

        PreviewRow("Disabled", content: {
            VRectangularCaptionButton(
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
            .disabled(true)
        })
    })
})

#endif

#endif
