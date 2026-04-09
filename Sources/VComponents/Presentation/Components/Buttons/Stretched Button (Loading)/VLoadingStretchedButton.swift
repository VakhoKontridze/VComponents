//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

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
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VLoadingStretchedButtonInternalState {
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
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

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

    /// Initializes `VLoadingStretchedButton` with loading state, action, and image.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .image(image: image)
    }

    /// Initializes `VLoadingStretchedButton` with loading state, action, title, and image.
    public init(
        appearance: VLoadingStretchedButtonAppearance = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.isLoading = isLoading
        self.action = action
        self.label = .titleAndImage(title: title, image: image)
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
                action()
                sensoryFeedbackTrigger()
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
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
        .disabled(isLoading)
    }
    
    private func labelView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        HStack(spacing: 0) {
            if !appearance.labelAndSpinnerSpacingType.hasFlexibleSpacing {
                Spacer()
            }
            
            if internalState == .loading {
                switch appearance.spinnerPlacement {
                case .leading: spinnerView(internalState: internalState)
                case .center: EmptyView()
                case .trailing: spinnerCompensatorView
                }
            }
            
            Spacer().frame(width: appearance.labelAndSpinnerSpacingType.spacing)

            ZStack {
                if
                    internalState == .loading,
                    appearance.spinnerPlacement == .center
                {
                    
                    spinnerView(internalState: internalState)
                    
                } else {
                    switch label {
                    case .title(let title):
                        labelTextElement(internalState: internalState, title: title)
                        
                    case .image(let image):
                        labelImageElement(internalState: internalState, image: image)
                        
                    case .titleAndImage(let title, let image):
                        switch appearance.labelTextAndLabelImagePlacement {
                        case .textAndImage:
                            HStack(spacing: appearance.labelSpacing) {
                                labelTextElement(internalState: internalState, title: title)
                                labelImageElement(internalState: internalState, image: image)
                            }
                            
                        case .imageAndText:
                            HStack(spacing: appearance.labelSpacing) {
                                labelImageElement(internalState: internalState, image: image)
                                labelTextElement(internalState: internalState, title: title)
                            }
                        }
                        
                    case .custom(let builder):
                        builder(internalState)
                    }
                }
            }
            .frame(maxWidth: appearance.labelAndSpinnerSpacingType.hasFlexibleSpacing ? .infinity : nil)
            
            Spacer().frame(width: appearance.labelAndSpinnerSpacingType.spacing)
            
            if internalState == .loading {
                switch appearance.spinnerPlacement {
                case .leading: spinnerCompensatorView
                case .center: EmptyView()
                case .trailing: spinnerView(internalState: internalState)
                }
            }
            
            if !appearance.labelAndSpinnerSpacingType.hasFlexibleSpacing {
                Spacer()
            }
        }
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }
    
    private func labelTextElement(
        internalState: VLoadingStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .textConfiguration(appearance.labelTextConfiguration, state: internalState)
    }
    
    private func labelImageElement(
        internalState: VLoadingStretchedButtonInternalState,
        image: Image
    ) -> some View {
        image
            .imageConfiguration(appearance.labelImageConfiguration, state: internalState)
    }
    
    private func spinnerView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        VContinuousSpinner(appearance: appearance.spinnerAppearance)
    }
    
    private var spinnerCompensatorView: some View {
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
}

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
                    appearance.labelTextConfiguration.colors!.enabled = appearance.labelTextConfiguration.colors!.pressed // Unsafe (DEBUG)
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

#Preview("Spinner Configurations") {
    @Previewable @State var labelAndSpinnerSpacingType: VLoadingStretchedButtonAppearance.LabelAndSpinnerSpacingType = .stretched(spacing: 20)
    @Previewable @State var placement: VLoadingStretchedButtonAppearance.SpinnerPlacement = .leading

    PreviewContainer {
        VLoadingStretchedButton(
            appearance: {
                var appearance: VLoadingStretchedButtonAppearance = .init()
                appearance.labelAndSpinnerSpacingType = labelAndSpinnerSpacingType
                appearance.spinnerPlacement = placement
                return appearance
            }(),
            isLoading: true,
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(StretchedButtonFrameModifier())
        .onAppear { isFirst in
            if isFirst {
                Task {
                    while true {
                        do {
                            try await Task.sleep(for: .seconds(1))
                        } catch {
                            return
                        }
                        
                        labelAndSpinnerSpacingType = .stretched(spacing: 20)
                        placement = .leading
                        
                        do {
                            try await Task.sleep(for: .seconds(1))
                        } catch {
                            return
                        }
                        
                        labelAndSpinnerSpacingType = .fixed(spacing: 20)
                        placement = .leading

                        do {
                            try await Task.sleep(for: .seconds(1))
                        } catch {
                            return
                        }
                        
                        placement = .center

                        do {
                            try await Task.sleep(for: .seconds(1))
                        } catch {
                            return
                        }
                        
                        labelAndSpinnerSpacingType = .fixed(spacing: 20)
                        placement = .trailing
                        
                        do {
                            try await Task.sleep(for: .seconds(1))
                        } catch {
                            return
                        }
                        
                        labelAndSpinnerSpacingType = .stretched(spacing: 20)
                        placement = .trailing
                    }
                }
            }
        }
    }
}

#endif

#endif
