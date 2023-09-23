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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
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
    
    /// Initializes `VStretchedButton` with action, icon, and title.
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
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
                
                buttonLabel(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .clipShape(RoundedRectangle(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { background(internalState: internalState) }) // Has own rounding
                    .overlay(content: { border(internalState: internalState) }) // Has own rounding
            }
        )
    }
    
    private func buttonLabel(
        internalState: VStretchedButtonInternalState
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
        .frame(maxWidth: .infinity)
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelComponent(
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
    
    private func iconLabelComponent(
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
    
    private func background(
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
    
    @ViewBuilder private func border(
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
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
struct VStretchedButton_Previews: PreviewProvider {
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
        .preferredColorScheme(colorScheme)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
    }
    
    // Data
    private static var title: String {
#if os(watchOS)
        return "Lorem".pseudoRTL(languageDirection)
#else
        "Lorem Ipsum".pseudoRTL(languageDirection)
#endif
    }
    private static var icon: Image { .init(systemName: "swift") }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VStretchedButton(
                    action: {},
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)

                VStretchedButton(
                    action: {},
                    icon: icon,
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.watchOS],
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            VStretchedButton(
                                action: {},
                                title: title
                            )
                            .modifier(StretchedButtonWidthModifier())
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Pressed",
                        content: {
                            VStretchedButton(
                                uiModel: {
                                    var uiModel: VStretchedButtonUIModel = .init()
                                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                                    return uiModel
                                }(),
                                action: {},
                                title: title
                            )
                            .modifier(StretchedButtonWidthModifier())
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Disabled",
                        content: {
                            VStretchedButton(
                                action: {},
                                title: title
                            )
                            .modifier(StretchedButtonWidthModifier())
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
                VStretchedButton(
                    uiModel: {
                        var uiModel: VStretchedButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VStretchedButtonUIModel.StateColors(
                            enabled: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            pressed: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    action: {},
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    private struct ShadowPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VStretchedButton(
                    uiModel: {
                        var uiModel: VStretchedButtonUIModel = .init()
                        uiModel.shadowColors = VStretchedButtonUIModel.StateColors(
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
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VStretchedButton(
                    uiModel: {
                        var uiModel: VStretchedButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VStretchedButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    action: {},
                    icon: Image(systemName: "swift"),
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)
            })
        }
    }

    // Helpers
    struct StretchedButtonWidthModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .applyModifier({
    #if os(iOS)
                    $0
    #elseif os(macOS)
                    $0.frame(width: 250)
    #elseif os(watchOS)
                    $0.frame(width: 100)
    #else
                    fatalError() // Not supported
    #endif
                })
        }
    }
}
