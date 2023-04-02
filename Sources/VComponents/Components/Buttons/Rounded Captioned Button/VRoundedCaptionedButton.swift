//
//  VRoundedCaptionedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rounded Captioned Button
/// Rounded colored labeled button component with caption that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VRoundedCaptionedButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift"),
///             titleCaption: "Lorem Ipsum"
///         )
///     }
///
@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRoundedCaptionedButton<CaptionLabel>: View where CaptionLabel: View {
    // MARK: Properties
    private let uiModel: VRoundedCaptionedButtonUIModel
    
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRoundedCaptionedButtonInternalState { baseButtonState }
    
    private let action: () -> Void
    
    private let icon: Image
    private let caption: VRoundedCaptionedButtonCaption<CaptionLabel>
    
    // MARK: Initializers
    /// Initializes `VRoundedCaptionedButton` with action, icon, and title caption.
    public init(
        uiModel: VRoundedCaptionedButtonUIModel = .init(),
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
    
    /// Initializes `VRoundedCaptionedButton` with action, icon, icon caption, and title caption.
    public init(
        uiModel: VRoundedCaptionedButtonUIModel = .init(),
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
    
    /// Initializes `VRoundedCaptionedButton` with action, icon, and caption.
    public init(
        uiModel: VRoundedCaptionedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder caption: @escaping (VRoundedCaptionedButtonInternalState) -> CaptionLabel
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
            action: action,
            label: { baseButtonState in
                let internalState: VRoundedCaptionedButtonInternalState = internalState(baseButtonState)
                
                VStack(spacing: uiModel.layout.rectangleCaptionSpacing, content: {
                    rectangle(internalState: internalState)
                    buttonCaption(internalState: internalState)
                })
            }
        )
    }
    
    private func rectangle(
        internalState: VRoundedCaptionedButtonInternalState
    ) -> some View {
        Group(content: {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(size: uiModel.layout.iconSize)
                .scaleEffect(internalState == .pressed ? uiModel.animations.labelPressedScale : 1)
                .foregroundColor(uiModel.colors.icon.value(for: internalState))
                .opacity(uiModel.colors.iconOpacities.value(for: internalState))
        })
            .frame(dimension: uiModel.layout.roundedRectangleDimension)
            .background(rectangleBackground(internalState: internalState))
            .overlay(roundedRectangleBorder(internalState: internalState))
    }
    
    private func rectangleBackground(
        internalState: VRoundedCaptionedButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
    }
    
    @ViewBuilder private func roundedRectangleBorder(
        internalState: VRoundedCaptionedButtonInternalState
    ) -> some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
        }
    }
    
    private func buttonCaption(
        internalState: VRoundedCaptionedButtonInternalState
    ) -> some View {
        Group(content: {
            switch caption {
            case .title(let title):
                titleCaptionComponent(internalState: internalState, title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.captionSpacing, content: {
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
        internalState: VRoundedCaptionedButtonInternalState,
        title: String
    ) -> some View {
        VText(
            type: uiModel.layout.titleCaptionTextLineType,
            minimumScaleFactor: uiModel.layout.titleCaptionMinimumScaleFactor,
            color: uiModel.colors.titleCaption.value(for: internalState),
            font: uiModel.fonts.titleCaption,
            text: title
        )
    }
    
    private func iconCaptionComponent(
        internalState: VRoundedCaptionedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(size: uiModel.layout.iconCaptionSize)
            .foregroundColor(uiModel.colors.iconCaption.value(for: internalState))
            .opacity(uiModel.colors.iconCaptionOpacities.value(for: internalState))
    }
}

// MARK: - Preview
@available(macOS 11.0, *)@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRoundedCaptionedButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var icon: Image { .init(systemName: "swift") }
    private static var titleCaption: String { "Lorem Ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedCaptionedButton(
                    action: { print("Clicked") },
                    icon: icon,
                    titleCaption: titleCaption
                )
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .horizontal,
                    title: "Enabled",
                    content: {
                        VRoundedCaptionedButton(
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
                        VRoundedCaptionedButton(
                            uiModel: {
                                var uiModel: VRoundedCaptionedButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.icon.enabled = uiModel.colors.icon.pressed
                                uiModel.colors.titleCaption.enabled = uiModel.colors.titleCaption.pressed
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
                        VRoundedCaptionedButton(
                            action: {},
                            icon: icon,
                            titleCaption: titleCaption
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
