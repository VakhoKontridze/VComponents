//
//  VRoundedCaptionButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rounded Caption Button
/// Rounded colored labeled button component with caption that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VRoundedCaptionButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift"),
///             titleCaption: "Lorem Ipsum"
///         )
///     }
///
@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRoundedCaptionButton<CaptionLabel>: View where CaptionLabel: View {
    // MARK: Properties
    private let uiModel: VRoundedCaptionButtonUIModel
    
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRoundedCaptionButtonInternalState { baseButtonState }
    
    private let action: () -> Void
    
    private let icon: Image
    private let caption: VRoundedCaptionButtonCaption<CaptionLabel>
    
    // MARK: Initializers
    /// Initializes `VRoundedCaptionButton` with action, icon, and title caption.
    public init(
        uiModel: VRoundedCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleCaption: String
    )
        where CaptionLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .title(title: titleCaption)
    }
    
    /// Initializes `VRoundedCaptionButton` with action, icon, icon caption, and title caption.
    public init(
        uiModel: VRoundedCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        iconCaption: Image,
        titleCaption: String
    )
        where CaptionLabel == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .iconTitle(icon: iconCaption, title: titleCaption)
    }
    
    /// Initializes `VRoundedCaptionButton` with action, icon, and caption.
    public init(
        uiModel: VRoundedCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder caption: @escaping (VRoundedCaptionButtonInternalState) -> CaptionLabel
    ) {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.caption = .caption(caption: caption)
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
                let internalState: VRoundedCaptionButtonInternalState = internalState(baseButtonState)
                
                VStack(spacing: uiModel.layout.rectangleAndCaptionSpacing, content: {
                    rectangle(internalState: internalState)
                    buttonCaption(internalState: internalState)
                })
            }
        )
    }
    
    private func rectangle(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        Group(content: {
            icon
                .resizable()
                .scaledToFit()
                .frame(size: uiModel.layout.iconSize)
                .scaleEffect(internalState == .pressed ? uiModel.animations.labelPressedScale : 1)
                .foregroundColor(uiModel.colors.icon.value(for: internalState))
                .opacity(uiModel.colors.iconOpacities.value(for: internalState))
        })
        .frame(size: uiModel.layout.roundedRectangleSize)
        .cornerRadius(uiModel.layout.cornerRadius) // Prevents large content from going out of bounds
        .background(rectangleBackground(internalState: internalState))
        .overlay(roundedRectangleBorder(internalState: internalState))
    }
    
    private func rectangleBackground(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
            .shadow(
                color: uiModel.colors.shadow.value(for: internalState),
                radius: uiModel.colors.shadowRadius,
                offset: uiModel.colors.shadowOffset
            )
    }
    
    @ViewBuilder private func roundedRectangleBorder(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
        }
    }
    
    private func buttonCaption(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        Group(content: {
            switch caption {
            case .title(let title):
                titleCaptionComponent(internalState: internalState, title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.iconCaptionAndTitleCaptionTextSpacing, content: {
                    iconCaptionComponent(internalState: internalState, icon: icon)
                    titleCaptionComponent(internalState: internalState, title: title)
                })
                
            case .caption(let caption):
                caption(internalState)
            }
        })
        .frame(maxWidth: uiModel.layout.captionWidthMax)
        .scaleEffect(internalState == .pressed ? uiModel.animations.captionPressedScale : 1)
    }
    
    private func titleCaptionComponent(
        internalState: VRoundedCaptionButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .multilineTextAlignment(uiModel.layout.titleCaptionTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.layout.titleCaptionTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.layout.titleCaptionTextMinimumScaleFactor)
            .foregroundColor(uiModel.colors.titleCaptionText.value(for: internalState))
            .font(uiModel.fonts.titleCaptionText)
    }
    
    private func iconCaptionComponent(
        internalState: VRoundedCaptionButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.layout.iconCaptionSize)
            .foregroundColor(uiModel.colors.iconCaption.value(for: internalState))
            .opacity(uiModel.colors.iconCaptionOpacities.value(for: internalState))
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.animations.haptic)
#elseif os(watchOS)
        HapticManager.shared.playImpact(uiModel.animations.haptic)
#endif
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct VRoundedCaptionButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            BorderPreview().previewDisplayName("Border")
            ShadowPreview().previewDisplayName("Shadow")
            OutOfBoundsContentPreventionPreview().previewDevice("Large Content")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var icon: Image { .init(systemName: "swift") }
    private static var iconCaption: Image { .init(systemName: "swift") }

    private static var titleCaption: String {
#if os(watchOS)
        return "Lorem".pseudoRTL(languageDirection)
#else
        return "Lorem Ipsum".pseudoRTL(languageDirection)
#endif
    }
    private static var titleCaptionShort: String { "Lorem".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedCaptionButton(
                    action: {},
                    icon: icon,
                    titleCaption: titleCaption
                )

                VRoundedCaptionButton(
                    action: {},
                    icon: icon,
                    iconCaption: iconCaption,
                    titleCaption: titleCaptionShort
                )
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.watchOS],
                content: {
                    PreviewRow(
                        axis: .horizontal,
                        title: "Enabled",
                        content: {
                            VRoundedCaptionButton(
                                action: {},
                                icon: icon,
                                titleCaption: titleCaption
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Pressed",
                        content: {
                            VRoundedCaptionButton(
                                uiModel: {
                                    var uiModel: VRoundedCaptionButtonUIModel = .init()
                                    uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                    uiModel.colors.icon.enabled = uiModel.colors.icon.pressed
                                    uiModel.colors.titleCaptionText.enabled = uiModel.colors.titleCaptionText.pressed
                                    return uiModel
                                }(),
                                action: {},
                                icon: icon,
                                titleCaption: titleCaption
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Disabled",
                        content: {
                            VRoundedCaptionButton(
                                action: {},
                                icon: icon,
                                titleCaption: titleCaption
                            )
                            .disabled(true)
                        }
                    )
                }
            )
        }
    }

    private struct BorderPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedCaptionButton(
                    uiModel: {
                        var uiModel: VRoundedCaptionButtonUIModel = .init()
                        uiModel.layout.borderWidth = 2
                        uiModel.colors.border = VRoundedButtonUIModel.Colors.StateColors(
                            enabled: uiModel.colors.background.enabled.darken(by: 0.3),
                            pressed: uiModel.colors.background.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    action: {},
                    icon: icon,
                    titleCaption: titleCaption
                )
            })
        }
    }

    private struct ShadowPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedCaptionButton(
                    uiModel: {
                        var uiModel: VRoundedCaptionButtonUIModel = .init()
                        uiModel.colors.background = VRoundedCaptionButtonUIModel.Colors.StateColors(
                            enabled: ColorBook.controlLayerBlue,
                            pressed: ColorBook.controlLayerBluePressed,
                            disabled: ColorBook.controlLayerBlueDisabled
                        )
                        uiModel.colors.icon = VRoundedCaptionButtonUIModel.Colors.StateColors(
                            enabled: ColorBook.primaryWhite,
                            pressed: ColorBook.primaryWhitePressedDisabled,
                            disabled: ColorBook.primaryWhitePressedDisabled
                        )
                        uiModel.colors.shadow = VRoundedButtonUIModel.Colors.StateColors(
                            enabled: GlobalUIModel.Common.shadowColorEnabled,
                            pressed: GlobalUIModel.Common.shadowColorEnabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.colors.shadowRadius = 3
                        uiModel.colors.shadowOffset = CGPoint(x: 0, y: 3)
                        return uiModel
                    }(),
                    action: {},
                    icon: icon,
                    titleCaption: titleCaption
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedCaptionButton(
                    uiModel: {
                        var uiModel: VRoundedCaptionButtonUIModel = .init()
                        uiModel.layout.iconSize = CGSize(dimension: 100)
                        uiModel.colors.icon = VRoundedCaptionButtonUIModel.Colors.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    action: {},
                    icon: icon,
                    titleCaption: titleCaption
                )
            })
        }
    }
}
