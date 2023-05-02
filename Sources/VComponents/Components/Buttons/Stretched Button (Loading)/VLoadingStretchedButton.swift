//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button
/// Large colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model and `isLoading` can be passed as parameters.
///
///     var body: some View {
///         VLoadingStretchedButton(
///             isLoading: false,
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///         .padding()
///     }
///
/// On `macOS`, you would typically provide an explicit width.
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VLoadingStretchedButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VLoadingStretchedButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private let isLoading: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VLoadingStretchedButtonInternalState {
        .init(isEnabled: isEnabled, isPressed: baseButtonState == .pressed, isLoading: isLoading)
    }
    
    private let action: () -> Void
    
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
                    .frame(height: uiModel.layout.height)
                    .cornerRadius(uiModel.layout.cornerRadius) // Prevents large content from going out of bounds
                    .background(background(internalState: internalState))
                    .overlay(border(internalState: internalState))
            }
        )
        .disabled(isLoading)
    }
    
    private func buttonLabel(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        HStack(spacing: uiModel.layout.labelAndSpinnerSpacing, content: {
            spinnerCompensator(internalState: internalState)
            
            Group(content: {
                switch label {
                case .title(let title):
                    titleLabelComponent(internalState: internalState, title: title)
                    
                case .iconTitle(let icon, let title):
                    HStack(spacing: uiModel.layout.iconAndTitleTextSpacing, content: {
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
        .scaleEffect(internalState == .pressed ? uiModel.animations.labelPressedScale : 1)
        .padding(uiModel.layout.labelMargins)
    }
    
    private func titleLabelComponent(
        internalState: VLoadingStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.layout.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.colors.titleText.value(for: internalState))
            .font(uiModel.fonts.titleText)
    }
    
    private func iconLabelComponent(
        internalState: VLoadingStretchedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.layout.iconSize)
            .foregroundColor(uiModel.colors.icon.value(for: internalState))
            .opacity(uiModel.colors.iconOpacities.value(for: internalState))
    }
    
    @ViewBuilder private func spinnerCompensator(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        if internalState == .loading {
            Spacer()
                .frame(width: uiModel.layout.spinnerSubUIModel.dimension)
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
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .scaleEffect(internalState == .pressed ? uiModel.animations.backgroundPressedScale : 1)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
    }
    
    @ViewBuilder private func border(
        internalState: VLoadingStretchedButtonInternalState
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
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
        })
        .colorScheme(colorScheme)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
    }
    
    // Data
    private static var icon: Image { .init(systemName: "swift") }
    private static var title: String {
#if os(watchOS)
        return "Lorem".pseudoRTL(languageDirection)
#else
        "Lorem Ipsum".pseudoRTL(languageDirection)
#endif
    }

    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                Group(content: {
                    VLoadingStretchedButton(
                        isLoading: false,
                        action: { print("Clicked") },
                        title: title
                    )

                    VLoadingStretchedButton(
                        isLoading: false,
                        action: { print("Clicked") },
                        icon: icon,
                        title: title
                    )
                })
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
                        .applyModifier({
#if os(macOS)
                            $0.frame(width: 250)
#else
                            $0
#endif
                        })
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Pressed",
                    content: {
                        VLoadingStretchedButton(
                            uiModel: {
                                var uiModel: VLoadingStretchedButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.titleText.enabled = uiModel.colors.titleText.pressed
                                return uiModel
                            }(),
                            isLoading: false,
                            action: {},
                            title: title
                        )
                        .applyModifier({
#if os(macOS)
                            $0.frame(width: 250)
#else
                            $0
#endif
                        })
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
                        .applyModifier({
#if os(macOS)
                            $0.frame(width: 250)
#else
                            $0
#endif
                        })
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
                        .applyModifier({
#if os(macOS)
                            $0.frame(width: 250)
#else
                            $0
#endif
                        })
                        .disabled(true)
                    }
                )
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VLoadingStretchedButton(
                    uiModel: {
                        var uiModel: VLoadingStretchedButtonUIModel = .init()
                        uiModel.layout.iconSize = CGSize(dimension: 100)
                        uiModel.colors.icon = VLoadingStretchedButtonUIModel.Colors.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    isLoading: false,
                    action: {},
                    icon: Image(systemName: "swift"),
                    title: title
                )
                .padding()
            })
        }
    }
}
