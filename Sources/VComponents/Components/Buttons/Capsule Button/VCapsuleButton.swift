//
//  VCapsuleButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Capsule Button
/// Small colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VCapsuleButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VCapsuleButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VCapsuleButtonUIModel

    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VCapsuleButtonInternalState {
        baseButtonState
    }

    private let action: () -> Void

    private let label: VCapsuleButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VCapsuleButton` with action and title.
    public init(
        uiModel: VCapsuleButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VCapsuleButton` with action, icon, and title.
    public init(
        uiModel: VCapsuleButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes `VCapsuleButton` with action and label.
    public init(
        uiModel: VCapsuleButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VCapsuleButtonInternalState) -> Label
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
                let internalState: VCapsuleButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .frame(height: uiModel.height)
                    .cornerRadius(uiModel.cornerRadius) // Prevents large content from overflowing
                    .background(background(internalState: internalState)) // Has own rounding
                    .overlay(border(internalState: internalState)) // Has own rounding
                    .padding(uiModel.hitBox)
            }
        )
    }
    
    private func buttonLabel(
        internalState: VCapsuleButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelComponent(internalState: internalState, title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.iconAndTitleTextSpacing, content: {
                    iconLabelComponent(internalState: internalState, icon: icon)
                    titleLabelComponent(internalState: internalState, title: title)
                })
                
            case .label(let label):
                label(internalState)
            }
        })
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
        .applyModifier({
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                $0.dynamicTypeSize(...(.accessibility3))
            } else {
                $0
            }
        })
    }
    
    private func titleLabelComponent(
        internalState: VCapsuleButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor({
                if #available(iOS 15.0, *) {
                    return uiModel.titleTextMinimumScaleFactor
                } else {
                    return uiModel.titleTextMinimumScaleFactor/2 // Alternative to dynamic size upper limit
                }
            }())
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
    }
    
    private func iconLabelComponent(
        internalState: VCapsuleButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundColor(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
    }
    
    private func background(
        internalState: VCapsuleButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.backgroundPressedScale : 1)
            .foregroundColor(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    @ViewBuilder private func border(
        internalState: VCapsuleButtonInternalState
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
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
struct VCapsuleButton_Previews: PreviewProvider {
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
    private static var title: String { "Lorem Ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VCapsuleButton(
                    action: {},
                    title: title
                )

                VCapsuleButton(
                    action: {},
                    icon: icon,
                    title: title
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
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Enabled",
                        content: {
                            VCapsuleButton(
                                action: {},
                                title: title
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Pressed",
                        content: {
                            VCapsuleButton(
                                uiModel: {
                                    var uiModel: VCapsuleButtonUIModel = .init()
                                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                                    return uiModel
                                }(),
                                action: {},
                                title: title
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Disabled",
                        content: {
                            VCapsuleButton(
                                action: {},
                                title: title
                            )
                            .disabled(true)
                        }
                    )
                    
#if os(watchOS)
                    
                    PreviewSectionHeader("Native (Sort Of)")
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            Button(title, action: {})
                                .background(Color.gray)
                        }
                    )
#endif
                }
            )
        }
    }

    private struct BorderPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VCapsuleButton(
                    uiModel: {
                        var uiModel: VCapsuleButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VCapsuleButtonUIModel.StateColors(
                            enabled: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            pressed: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    action: {},
                    title: title
                )
            })
        }
    }

    private struct ShadowPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VCapsuleButton(
                    uiModel: {
                        var uiModel: VCapsuleButtonUIModel = .init()
                        uiModel.shadowColors = VCapsuleButtonUIModel.StateColors(
                            enabled: GlobalUIModel.Common.shadowColorEnabled,
                            pressed: GlobalUIModel.Common.shadowColorEnabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.shadowRadius = 3
                        uiModel.shadowOffset = CGPoint(x: 0, y: 3)
                        return uiModel
                    }(),
                    action: {},
                    title: title
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VCapsuleButton(
                    uiModel: {
                        var uiModel: VCapsuleButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VCapsuleButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    action: {},
                    icon: icon,
                    title: title
                )
            })
        }
    }
}
