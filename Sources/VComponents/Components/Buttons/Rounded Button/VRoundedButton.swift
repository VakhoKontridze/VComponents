//
//  VRoundedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rounded Button
/// Rounded colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VRoundedButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRoundedButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VRoundedButtonUIModel
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRoundedButtonInternalState { baseButtonState }
    private let action: () -> Void
    private let label: VRoundedButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VRoundedButton` with action and title.
    public init(
        uiModel: VRoundedButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VRoundedButton` with action and icon.
    public init(
        uiModel: VRoundedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VRoundedButton` with action and label.
    public init(
        uiModel: VRoundedButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VRoundedButtonInternalState) -> Label
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
                let internalState: VRoundedButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .frame(size: uiModel.layout.size)
                    .cornerRadius(uiModel.layout.cornerRadius) // Prevents large content from going out of bounds
                    .background(background(internalState: internalState))
                    .overlay(border(internalState: internalState))
                    .padding(uiModel.layout.hitBox)
            }
        )
    }
    
    private func buttonLabel(
        internalState: VRoundedButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelComponent(internalState: internalState, title: title)
                
            case .icon(let icon):
                iconLabelComponent(internalState: internalState, icon: icon)
                
            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState == .pressed ? uiModel.animations.labelPressedScale : 1)
        .padding(uiModel.layout.labelMargins)
        .applyModifier({
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                $0.dynamicTypeSize(...(.accessibility3))
            } else {
                $0
            }
        })
    }
    
    private func titleLabelComponent(
        internalState: VRoundedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor({
                if #available(iOS 15.0, *) {
                    return uiModel.layout.titleTextMinimumScaleFactor
                } else {
                    return uiModel.layout.titleTextMinimumScaleFactor/2 // Alternative to dynamic size upper limit
                }
            }())
            .foregroundColor(uiModel.colors.titleText.value(for: internalState))
            .font(uiModel.fonts.titleText)
    }
    
    private func iconLabelComponent(
        internalState: VRoundedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.layout.iconSize)
            .foregroundColor(uiModel.colors.icon.value(for: internalState))
            .opacity(uiModel.colors.iconOpacities.value(for: internalState))
    }
    
    private func background(
        internalState: VRoundedButtonInternalState
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
    
    @ViewBuilder private func border(
        internalState: VRoundedButtonInternalState
    ) -> some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
        }
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
@available(tvOS, unavailable)
struct VRoundedButton_Previews: PreviewProvider {
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
    private static var title: String { "ABC".pseudoRTL(languageDirection) }
    private static var icon: Image { .init(systemName: "swift") }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedButton(
                    action: {},
                    title: title
                )

                VRoundedButton(
                    action: {},
                    icon: icon
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
                            VRoundedButton(
                                action: {},
                                icon: icon
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Pressed",
                        content: {
                            VRoundedButton(
                                uiModel: {
                                    var uiModel: VRoundedButtonUIModel = .init()
                                    uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                    uiModel.colors.icon.enabled = uiModel.colors.icon.pressed
                                    return uiModel
                                }(),
                                action: {},
                                icon: icon
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Disabled",
                        content: {
                            VRoundedButton(
                                action: {},
                                icon: icon
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
                VRoundedButton(
                    uiModel: {
                        var uiModel: VRoundedButtonUIModel = .init()
                        uiModel.layout.borderWidth = 2
                        uiModel.colors.border = VRoundedButtonUIModel.Colors.StateColors(
                            enabled: uiModel.colors.background.enabled.darken(by: 0.3),
                            pressed: uiModel.colors.background.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    action: {},
                    icon: icon
                )
            })
        }
    }

    private struct ShadowPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedButton(
                    uiModel: {
                        var uiModel: VRoundedButtonUIModel = .init()
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
                    icon: icon
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedButton(
                    uiModel: {
                        var uiModel: VRoundedButtonUIModel = .init()
                        uiModel.layout.iconSize = CGSize(dimension: 100)
                        uiModel.colors.icon = VRoundedButtonUIModel.Colors.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    action: {},
                    icon: icon
                )
            })
        }
    }
}
