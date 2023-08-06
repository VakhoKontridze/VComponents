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
    
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRoundedCaptionButtonInternalState {
        baseButtonState
    }
    
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
                
                VStack(spacing: uiModel.rectangleAndCaptionSpacing, content: {
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
                .frame(size: uiModel.iconSize)
                .scaleEffect(internalState == .pressed ? uiModel.iconPressedScale : 1)
                .padding(uiModel.iconMargins)
                .foregroundColor(uiModel.iconColors.value(for: internalState))
                .opacity(uiModel.iconOpacities.value(for: internalState))
        })
        .frame(size: uiModel.rectangleSize)
        .cornerRadius(uiModel.rectangleCornerRadius) // Prevents large content from going out of bounds
        .background(rectangleBackground(internalState: internalState))
        .overlay(roundedRectangleBorder(internalState: internalState))
    }
    
    private func rectangleBackground(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.rectangleCornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.rectanglePressedScale : 1)
            .foregroundColor(uiModel.rectangleColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    @ViewBuilder private func roundedRectangleBorder(
        internalState: VRoundedCaptionButtonInternalState
    ) -> some View {
        if uiModel.rectangleBorderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.rectangleCornerRadius)
                .strokeBorder(uiModel.rectangleBorderColors.value(for: internalState), lineWidth: uiModel.rectangleBorderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.rectanglePressedScale : 1)
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
                HStack(spacing: uiModel.iconCaptionAndTitleCaptionTextSpacing, content: {
                    iconCaptionComponent(internalState: internalState, icon: icon)
                    titleCaptionComponent(internalState: internalState, title: title)
                })
                
            case .caption(let caption):
                caption(internalState)
            }
        })
        .frame(maxWidth: uiModel.captionWidthMax)
        .scaleEffect(internalState == .pressed ? uiModel.captionPressedScale : 1)
    }
    
    private func titleCaptionComponent(
        internalState: VRoundedCaptionButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .multilineTextAlignment(uiModel.titleCaptionTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.titleCaptionTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.titleCaptionTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleCaptionTextColors.value(for: internalState))
            .font(uiModel.titleCaptionTextFont)
    }
    
    private func iconCaptionComponent(
        internalState: VRoundedCaptionButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconCaptionSize)
            .foregroundColor(uiModel.iconCaptionColors.value(for: internalState))
            .opacity(uiModel.iconCaptionOpacities.value(for: internalState))
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
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
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
                                    uiModel.rectangleColors.enabled = uiModel.rectangleColors.pressed
                                    uiModel.iconColors.enabled = uiModel.iconColors.pressed
                                    uiModel.titleCaptionTextColors.enabled = uiModel.titleCaptionTextColors.pressed
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
                        uiModel.rectangleBorderWidth = 2
                        uiModel.rectangleBorderColors = VRoundedCaptionButtonUIModel.StateColors(
                            enabled: uiModel.rectangleColors.enabled.darken(by: 0.3),
                            pressed: uiModel.rectangleColors.enabled.darken(by: 0.3),
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
                        uiModel.rectangleColors = VRoundedCaptionButtonUIModel.StateColors(
                            enabled: ColorBook.controlLayerBlue,
                            pressed: ColorBook.controlLayerBluePressed,
                            disabled: ColorBook.controlLayerBlueDisabled
                        )
                        uiModel.iconColors = VRoundedCaptionButtonUIModel.StateColors(
                            enabled: ColorBook.primaryWhite,
                            pressed: ColorBook.primaryWhitePressedDisabled,
                            disabled: ColorBook.primaryWhitePressedDisabled
                        )
                        uiModel.shadowColors = VRoundedCaptionButtonUIModel.StateColors(
                            enabled: GlobalUIModel.Common.shadowColorEnabled,
                            pressed: GlobalUIModel.Common.shadowColorEnabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.shadowRadius = 3
                        uiModel.shadowOffset = CGPoint(x: 0, y: 3)
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
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VRoundedCaptionButtonUIModel.StateColors(ColorBook.accentRed)
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
