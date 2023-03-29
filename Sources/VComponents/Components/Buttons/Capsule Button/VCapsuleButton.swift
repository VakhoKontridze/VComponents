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
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VCapsuleButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VCapsuleButtonUIModel
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VCapsuleButtonInternalState { baseButtonState }
    private let action: () -> Void
    private let label: VCapsuleButtonLabel<Label>
    
    private var hasBorder: Bool { uiModel.layout.borderWidth > 0 }

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
            action: action,
            label: { baseButtonState in
                let internalState: VCapsuleButtonInternalState = internalState(baseButtonState)
                
                buttonLabel(internalState: internalState)
                    .frame(height: uiModel.layout.height)
                    .background(background(internalState: internalState))
                    .overlay(border(internalState: internalState))
                    .padding(uiModel.layout.hitBox)
            }
        )
    }
    
    private func buttonLabel(
        internalState: VCapsuleButtonInternalState
    ) -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                labelTitleComponent(internalState: internalState, title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.iconTitleSpacing, content: {
                    labelIconComponent(internalState: internalState, icon: icon)
                    labelTitleComponent(internalState: internalState, title: title)
                })
                
            case .label(let label):
                label(internalState)
            }
        })
            .padding(uiModel.layout.labelMargins)
    }
    
    private func labelTitleComponent(
        internalState: VCapsuleButtonInternalState,
        title: String
    ) -> some View {
        VText(
            minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
            color: uiModel.colors.title.value(for: internalState),
            font: uiModel.fonts.title,
            text: title
        )
    }
    
    private func labelIconComponent(
        internalState: VCapsuleButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(size: uiModel.layout.iconSize)
            .foregroundColor(uiModel.colors.icon.value(for: internalState))
            .opacity(uiModel.colors.iconOpacities.value(for: internalState))
    }
    
    private func background(
        internalState: VCapsuleButtonInternalState
    ) -> some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
    }
    
    @ViewBuilder private func border(
        internalState: VCapsuleButtonInternalState
    ) -> some View {
        if hasBorder {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        }
    }
}

// MARK: - Preview
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VCapsuleButton_Previews: PreviewProvider {
    // Configuration
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem Ipsum" }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VCapsuleButton(
                    action: { print("Clicked") },
                    title: title
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
                        VCapsuleButton(
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed",
                    content: {
                        VCapsuleButton(
                            uiModel: {
                                var uiModel: VCapsuleButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.title.enabled = uiModel.colors.title.pressed
                                return uiModel
                            }(),
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VCapsuleButton(
                            action: {},
                            title: title
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
