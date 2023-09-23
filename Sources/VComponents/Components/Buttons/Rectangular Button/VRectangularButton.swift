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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VRectangularButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VRectangularButtonUIModel

    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRectangularButtonInternalState {
        baseButtonState
    }

    private let action: () -> Void

    private let label: VRectangularButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VRectangularButton` with action and title.
    public init(
        uiModel: VRectangularButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
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
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VRectangularButton` with action and label.
    public init(
        uiModel: VRectangularButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VRectangularButtonInternalState) -> Label
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
                let internalState: VRectangularButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(size: uiModel.size)
                    .clipShape(RoundedRectangle(cornerRadius: uiModel.cornerRadius)) // Prevents large content from overflowing
                    .background(content: { background(internalState: internalState) }) // Has own rounding
                    .overlay(content: { border(internalState: internalState) }) // Has own rounding
                    .padding(uiModel.hitBox)
            }
        )
    }
    
    private func buttonLabel(
        internalState: VRectangularButtonInternalState
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
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelComponent(
        internalState: VRectangularButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .dynamicTypeSize(...uiModel.titleTextDynamicTypeSizeMax)
    }
    
    private func iconLabelComponent(
        internalState: VRectangularButtonInternalState,
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
        internalState: VRectangularButtonInternalState
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
        internalState: VRectangularButtonInternalState
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
struct VRectangularButton_Previews: PreviewProvider {
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
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "ABC".pseudoRTL(languageDirection) }
    private static var icon: Image { .init(systemName: "swift") }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VRectangularButton(
                    action: {},
                    title: title
                )

                VRectangularButton(
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
                            VRectangularButton(
                                action: {},
                                icon: icon
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Pressed",
                        content: {
                            VRectangularButton(
                                uiModel: {
                                    var uiModel: VRectangularButtonUIModel = .init()
                                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                                    uiModel.iconColors.enabled = uiModel.iconColors.pressed
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
                            VRectangularButton(
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
                VRectangularButton(
                    uiModel: {
                        var uiModel: VRectangularButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VRectangularButtonUIModel.StateColors(
                            enabled: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            pressed: uiModel.backgroundColors.enabled.darken(by: 0.3),
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
                VRectangularButton(
                    uiModel: {
                        var uiModel: VRectangularButtonUIModel = .init()
                        uiModel.shadowColors = VRectangularButtonUIModel.StateColors(
                            enabled: GlobalUIModel.Common.shadowColorEnabled,
                            pressed: GlobalUIModel.Common.shadowColorEnabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.shadowRadius = 3
                        uiModel.shadowOffset = CGPoint(x: 0, y: 3)
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
                VRectangularButton(
                    uiModel: {
                        var uiModel: VRectangularButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VRectangularButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    action: {},
                    icon: icon
                )
            })
        }
    }
}
