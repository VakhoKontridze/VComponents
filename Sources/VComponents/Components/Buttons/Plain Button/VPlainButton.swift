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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VPlainButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VPlainButtonUIModel

    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VPlainButtonInternalState {
        baseButtonState
    }

    private let action: () -> Void

    private let label: VPlainButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VPlainButton` with action and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
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
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VPlainButton` with action, icon, and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
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
    
    /// Initializes `VPlainButton` with action and label.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VPlainButtonInternalState) -> Label
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
                let internalState: VPlainButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
            }
        )
    }
    
    private func buttonLabel(
        internalState: VPlainButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelComponent(internalState: internalState, title: title)
                
            case .icon(let icon):
                iconLabelComponent(internalState: internalState, icon: icon)
                
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
        .padding(uiModel.hitBox)
    }
    
    private func titleLabelComponent(
        internalState: VPlainButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
    }
    
    private func iconLabelComponent(
        internalState: VPlainButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundColor(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
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
struct VPlainButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem Ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VStack(content: {
                    VPlainButton(
                        action: {},
                        title: title
                    )

                    VPlainButton(
                        action: {},
                        icon: Image(systemName: "swift")
                    )

                    VPlainButton(
                        uiModel: {
                            var uiModel: VPlainButtonUIModel = .init()
                            uiModel.iconSize = CGSize(dimension: 18)
                            return uiModel
                        }(),
                        action: {},
                        icon: Image(systemName: "swift"),
                        title: title
                    )
                })
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
                            VPlainButton(
                                action: {},
                                title: title
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Pressed",
                        content: {
                            VPlainButton(
                                uiModel: {
                                    var uiModel: VPlainButtonUIModel = .init()
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
                            VPlainButton(
                                action: {},
                                title: title
                            )
                            .disabled(true)
                        }
                    )
                    
                    PreviewSectionHeader("Native")
                    
                    PreviewRow(
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Enabled",
                        content: {
                            Button(
                                title,
                                action: {}
                            )
                            .buttonStyle(.plain)
                            .foregroundColor(ColorBook.accentBlue)
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal(butVerticalOnPlatforms: [.watchOS]),
                        title: "Disabled",
                        content: {
                            Button(
                                title,
                                action: {}
                            )
                            .buttonStyle(.plain)
                            .disabled(true)
                            .applyModifier({
#if os(watchOS)
                                $0.foregroundColor(ColorBook.controlLayerBlue)
#else
                                $0
#endif
                            })
                        }
                    )
                }
            )
        }
    }
}
