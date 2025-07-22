//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button
/// Stretched button component that indicates loading activity, and performs action when triggered.
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
/// On `macOS`, an explicit width should be provided.
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VLoadingStretchedButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VLoadingStretchedButtonAppearance

    @Environment(\.displayScale) private var displayScale: CGFloat

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
    private let label: VLoadingStretchedButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VLoadingStretchedButton` with loading state, action, and title.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VLoadingStretchedButton` with loading state, action, and icon.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .icon(icon: icon)
    }

    /// Initializes `VLoadingStretchedButton` with loading state, action, icon, and title.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .titleAndIcon(title: title, icon: icon)
    }
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, and custom label.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VLoadingStretchedButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .custom(builder: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                playHapticEffect()
                action()
            },
            label: { baseButtonState in
                let internalState: VLoadingStretchedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: appearance.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
            }
        )
        .disabled(isLoading)
    }
    
    private func labelView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        HStack(spacing: appearance.labelAndSpinnerSpacing) {
            if internalState == .loading {
                switch appearance.spinnerPlacement {
                case .leading: spinnerView(internalState: internalState)
                case .center: EmptyView()
                case .trailing: spinnerCompensatorView(internalState: internalState)
                }
            }

            if
                internalState == .loading,
                appearance.spinnerPlacement == .center
            {
                ZStack {
                    spinnerView(internalState: internalState)
                }
                .frame(maxWidth: .infinity)
                
            } else {
                Group {
                    switch label {
                    case .title(let title):
                        titleLabelViewComponent(internalState: internalState, title: title)

                    case .icon(let icon):
                        iconLabelViewComponent(internalState: internalState, icon: icon)

                    case .titleAndIcon(let title, let icon):
                        switch appearance.titleTextAndIconPlacement {
                        case .titleAndIcon:
                            HStack(spacing: appearance.titleTextAndIconSpacing) {
                                titleLabelViewComponent(internalState: internalState, title: title)
                                iconLabelViewComponent(internalState: internalState, icon: icon)
                            }

                        case .iconAndTitle:
                            HStack(spacing: appearance.titleTextAndIconSpacing) {
                                iconLabelViewComponent(internalState: internalState, icon: icon)
                                titleLabelViewComponent(internalState: internalState, title: title)
                            }
                        }

                    case .custom(let builder):
                        builder(internalState)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            if internalState == .loading {
                switch appearance.spinnerPlacement {
                case .leading: spinnerCompensatorView(internalState: internalState)
                case .center: EmptyView()
                case .trailing: spinnerView(internalState: internalState)
                }
            }
        }
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VLoadingStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
            .foregroundStyle(appearance.titleTextColors.value(for: internalState))
            .font(appearance.titleTextFont)
            .applyIfLet(appearance.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func iconLabelViewComponent(
        internalState: VLoadingStretchedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(appearance.isIconResizable) { $0.resizable() }
            .applyIfLet(appearance.iconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.iconColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.iconOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.iconFont)
            .applyIfLet(appearance.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.iconSize)
    }
    
    private func spinnerView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        VContinuousSpinner(appearance: appearance.spinnerAppearance)
    }
    
    private func spinnerCompensatorView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        Spacer()
            .frame(width: appearance.spinnerAppearance.dimension)
    }
    
    private func backgroundView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState == .pressed ? appearance.backgroundPressedScale : 1)
            .foregroundStyle(appearance.backgroundColors.value(for: internalState))
            .shadow(
                color: appearance.shadowColors.value(for: internalState),
                radius: appearance.shadowRadius,
                offset: appearance.shadowOffset
            )
    }
    
    @ViewBuilder 
    private func borderView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? appearance.backgroundPressedScale : 1)
        }
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(appearance.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VLoadingStretchedButton(
            isLoading: false,
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(StretchedButtonFrameModifier())
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VLoadingStretchedButton(
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Pressed") {
            VLoadingStretchedButton(
                appearance: {
                    var appearance: VLoadingStretchedButtonAppearance = .init()
                    appearance.backgroundColors.enabled = appearance.backgroundColors.pressed
                    appearance.titleTextColors.enabled = appearance.titleTextColors.pressed
                    return appearance
                }(),
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Loading") {
            VLoadingStretchedButton(
                isLoading: true,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Disabled") {
            VLoadingStretchedButton(
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
            .disabled(true)
        }
    }
}

#Preview("Spinner Placements") {
    @Previewable @State var placement: VLoadingStretchedButtonAppearance.SpinnerPlacement = .leading

    PreviewContainer {
        VLoadingStretchedButton(
            appearance: {
                var appearance: VLoadingStretchedButtonAppearance = .init()
                appearance.spinnerPlacement = placement
                return appearance
            }(),
            isLoading: true,
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(StretchedButtonFrameModifier())
        .onFirstAppear {
            Task { @MainActor in
                try await Task.sleep(for: .seconds(1))
                
                while true {
                    placement = .leading
                    try await Task.sleep(for: .seconds(1))
                    
                    placement = .center
                    try await Task.sleep(for: .seconds(1))
                    
                    placement = .trailing
                    try await Task.sleep(for: .seconds(1))
                }
            }
        }
    }
}

#endif

#endif
