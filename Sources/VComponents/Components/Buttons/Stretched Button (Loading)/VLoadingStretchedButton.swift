//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button
/// Stretched button component that performs action when triggered.
///
///     var body: some View {
///         VLoadingStretchedButton(
///             isLoading: false,
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///         .padding(.horizontal)
///     }
///
/// On `macOS` and `watchOS`, an explicit width should be provided.
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VLoadingStretchedButton<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VLoadingStretchedButtonUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private let isLoading: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VLoadingStretchedButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed,
            isLoading: isLoading
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VLoadingStretchedButtonLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VLoadingStretchedButton` with loading state, action, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, icon, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, and label.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VLoadingStretchedButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self.isLoading = isLoading
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
                let internalState: VLoadingStretchedButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .contentShape(Rectangle()) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .cornerRadius(uiModel.cornerRadius) // Prevents large content from overflowing
                    .background(background(internalState: internalState)) // Has own rounding
                    .overlay(border(internalState: internalState)) // Has own rounding
            }
        )
        .disabled(isLoading)
    }
    
    private func buttonLabel(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        HStack(spacing: uiModel.labelAndSpinnerSpacing, content: {
            spinnerCompensator(internalState: internalState)
            
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
            
            spinner(internalState: internalState)
        })
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelComponent(
        internalState: VLoadingStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
    }
    
    private func iconLabelComponent(
        internalState: VLoadingStretchedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundColor(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
    }
    
    @ViewBuilder private func spinnerCompensator(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        if internalState == .loading {
            Spacer()
                .frame(width: uiModel.spinnerSubUIModel.dimension)
        }
    }
    
    @ViewBuilder private func spinner(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        if internalState == .loading {
            VContinuousSpinner(uiModel: uiModel.spinnerSubUIModel)
        }
    }
    
    private func background(
        internalState: VLoadingStretchedButtonInternalState
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
        internalState: VLoadingStretchedButtonInternalState
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
#endif
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VLoadingStretchedButton_Previews: PreviewProvider {
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
        .colorScheme(colorScheme)
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
                VLoadingStretchedButton(
                    isLoading: false,
                    action: {},
                    title: title
                )
                .modifier(StretchedButtonWidthModifier())
                .padding(.horizontal)

                VLoadingStretchedButton(
                    isLoading: false,
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
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VLoadingStretchedButton(
                            isLoading: false,
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
                        VLoadingStretchedButton(
                            uiModel: {
                                var uiModel: VLoadingStretchedButtonUIModel = .init()
                                uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                                uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                                return uiModel
                            }(),
                            isLoading: false,
                            action: {},
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Loading",
                    content: {
                        VLoadingStretchedButton(
                            isLoading: true,
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
                        VLoadingStretchedButton(
                            isLoading: false,
                            action: {},
                            title: title
                        )
                        .modifier(StretchedButtonWidthModifier())
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct BorderPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VLoadingStretchedButton(
                    uiModel: {
                        var uiModel: VLoadingStretchedButtonUIModel = .init()
                        uiModel.borderWidth = 2
                        uiModel.borderColors = VLoadingStretchedButtonUIModel.StateColors(
                            enabled: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            pressed: uiModel.backgroundColors.enabled.darken(by: 0.3),
                            loading: .clear,
                            disabled: .clear
                        )
                        return uiModel
                    }(),
                    isLoading: false,
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
                VLoadingStretchedButton(
                    uiModel: {
                        var uiModel: VLoadingStretchedButtonUIModel = .init()
                        uiModel.shadowColors = VLoadingStretchedButtonUIModel.StateColors(
                            enabled: GlobalUIModel.Common.shadowColorEnabled,
                            pressed: GlobalUIModel.Common.shadowColorEnabled,
                            loading: GlobalUIModel.Common.shadowColorDisabled,
                            disabled: GlobalUIModel.Common.shadowColorDisabled
                        )
                        uiModel.shadowRadius = 3
                        uiModel.shadowOffset = CGPoint(x: 0, y: 3)
                        return uiModel
                    }(),
                    isLoading: false,
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
                VLoadingStretchedButton(
                    uiModel: {
                        var uiModel: VLoadingStretchedButtonUIModel = .init()
                        uiModel.iconSize = CGSize(dimension: 100)
                        uiModel.iconColors = VLoadingStretchedButtonUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    isLoading: false,
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
    typealias StretchedButtonWidthModifier = VStretchedButton_Previews.StretchedButtonWidthModifier
}
