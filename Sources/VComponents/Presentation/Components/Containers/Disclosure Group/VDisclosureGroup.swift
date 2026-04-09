//
//  VDisclosureGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

/// Expandable container component that hosts content.
///
///     @State private var state: VDisclosureGroupState = .expanded
///
///     var body: some View {
///         ZStack(alignment: .top) {
///             Color(uiColor: UIColor.secondarySystemBackground)
///                 .ignoresSafeArea()
///
///             VDisclosureGroup(
///                 appearance: .systemBackgroundColor,
///                 state: $state,
///                 headerTitle: "Lorem Ipsum"
///             ) {
///                 Color.blue
///                     .frame(height: 150)
///             }
///             .padding()
///         }
///     }
///
/// Component can be also initialized with `Bool`.
///
///     @State private var isExpanded: Bool = true
///
///     var body: some View {
///         VDisclosureGroup(
///             ...
///             state: Binding(isExpanded: $isExpanded),
///             ...
///         )
///     }
///
@available(tvOS, unavailable) // No `PlainDisclosureGroup`
@available(watchOS, unavailable) // No `PlainDisclosureGroup`
@available(visionOS, unavailable) // No `PlainDisclosureGroup`
public struct VDisclosureGroup<CustomHeaderLabel, Content>: View
    where
        CustomHeaderLabel: View,
        Content: View
{
    // MARK: Properties - Appearance
    
    private let appearance: VDisclosureGroupAppearance
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VDisclosureGroupState
    private var internalState: VDisclosureGroupInternalState {
        .init(
            isEnabled: isEnabled,
            isExpanded: state == .expanded
        )
    }

    // MARK: Properties - Header
    private let headerLabel: VDisclosureGroupHeaderLabel<CustomHeaderLabel>

    // MARK: Properties - Content
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes `VDisclosureGroup` with header title and content.
    public init(
        appearance: VDisclosureGroupAppearance = .init(),
        state: Binding<VDisclosureGroupState>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where CustomHeaderLabel == Never
    {
        self.appearance = appearance
        self._state = state
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes `VDisclosureGroup` with custom header label and content.
    public init(
        appearance: VDisclosureGroupAppearance = .init(),
        state: Binding<VDisclosureGroupState>,
        @ViewBuilder headerLabel customHeaderLabel: @escaping (VDisclosureGroupInternalState) -> CustomHeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.appearance = appearance
        self._state = state
        self.headerLabel = .custom(builder: customHeaderLabel)
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        VGroupBox(
            appearance: appearance.groupBoxAppearance(
                internalState: internalState
            )
        ) {
            PlainDisclosureGroup(
                appearance: appearance.plainDisclosureGroupAppearance,
                isExpanded: Binding(
                    get: { internalState == .expanded },
                    set: { expandCollapseFromHeaderTap($0) }
                ),
                label: { headerView },
                content: {
                    VStack(spacing: 0) {
                        dividerView
                        contentView
                    }
                }
            )
        }
        .applyIf(appearance.appliesExpandCollapseAnimation) {
            $0
                .animation(appearance.expandCollapseAnimation, value: isEnabled)
                .animation(appearance.expandCollapseAnimation, value: state) // +withAnimation
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 0) {
            Group {
                switch headerLabel {
                case .title(let title):
                    Text(title)
                        .textConfiguration(appearance.headerTextConfiguration, state: internalState)

                case .custom(let builder):
                    builder(internalState)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
            
            Spacer(minLength: 0)
            
            VRectangularButton(
                appearance: appearance.disclosureButtonAppearance,
                action: expandCollapse,
                image: appearance.disclosureButtonImage
            )
            .rotationEffect(Angle(radians: appearance.disclosureButtonAngles.value(for: internalState)))
        }
        .padding(appearance.headerMargins)
    }
    
    @ViewBuilder
    private var dividerView: some View {
        if appearance.dividerHeight.toPoints(scale: displayScale) > 0 {
            Rectangle()
                .frame(height: appearance.dividerHeight.toPoints(scale: displayScale))
                .padding(appearance.dividerMargins)
                .foregroundStyle(appearance.dividerColor)
        }
    }
    
    private var contentView: some View {
        content()
            .frame(maxWidth: .infinity)
            .padding(appearance.contentMargins)
    }
    
    // MARK: Actions
    private func expandCollapse() {
        // Not affected by animation flag
        withAnimation(appearance.expandCollapseAnimation) {
            state.setNextState()
        }
    }
    
    private func expandCollapseFromHeaderTap(_ isExpanded: Bool) {
        guard
            appearance.expandsAndCollapsesOnHeaderTap,
            exclusiveOr(isExpanded, internalState == .expanded)
        else {
            return
        }
        
        expandCollapse()
    }
}

private func exclusiveOr(_ lhs: Bool, _ rhs: Bool) -> Bool {
    lhs != rhs
}

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var state: VDisclosureGroupState = .expanded
    
    PreviewContainer {
        VDisclosureGroup(
            state: $state,
            headerTitle: "Lorem Ipsum",
        ) {
            Color.blue.frame(height: 100)
        }
        .padding(.horizontal)
    }
}

#Preview("States") {
    StatesContentView()
}

#if !os(macOS) // Redundant

#Preview("States (System Background Color)") {
    StatesContentView(layer: .secondary, appearance: .systemBackgroundColor)
}

#endif

private struct StatesContentView: View {
    // MARK: Properties
    private let layer: PreviewContainerLayer
    private let appearance: VDisclosureGroupAppearance

    // MARK: Initializers
    init(
        layer: PreviewContainerLayer = .primary,
        appearance: VDisclosureGroupAppearance = .init()
    ) {
        self.layer = layer
        self.appearance = appearance
    }

    // MARK: Body
    var body: some View {
        PreviewContainer(layer: layer) {
            PreviewRow("Collapsed") {
                VDisclosureGroup(
                    appearance: appearance,
                    state: .constant(.collapsed),
                    headerTitle: "Lorem Ipsum"
                ) {
                    Color.blue.frame(height: 100)
                }
                .padding(.horizontal)
            }

            PreviewRow("Expanded") {
                VDisclosureGroup(
                    appearance: appearance,
                    state: .constant(.expanded),
                    headerTitle: "Lorem Ipsum"
                ) {
                    Color.blue.frame(height: 100)
                }
                .padding(.horizontal)
            }

            PreviewRow("Pressed (Button)") {
                VDisclosureGroup(
                    appearance: {
                        var appearance: VDisclosureGroupAppearance = appearance
                        appearance.disclosureButtonAppearance.backgroundColors.enabled = appearance.disclosureButtonAppearance.backgroundColors.pressed
                        appearance.disclosureButtonAppearance.labelImageConfiguration.colors!.enabled = appearance.disclosureButtonAppearance.labelImageConfiguration.colors!.pressed // Unsafe (DEBUG)
                        return appearance
                    }(),
                    state: .constant(.collapsed),
                    headerTitle: "Lorem Ipsum"
                ) {
                    Color.blue.frame(height: 100)
                }
                .padding(.horizontal)
            }

            PreviewRow("Disabled") {
                VDisclosureGroup(
                    appearance: {
                        var appearance: VDisclosureGroupAppearance = appearance
                        appearance.disclosureButtonAppearance.backgroundColors.enabled = appearance.disclosureButtonAppearance.backgroundColors.disabled
                        appearance.disclosureButtonAppearance.labelImageConfiguration.colors!.enabled = appearance.disclosureButtonAppearance.labelImageConfiguration.colors!.disabled // Unsafe (DEBUG)
                        return appearance
                    }(),
                    state: .constant(.expanded),
                    headerTitle: "Lorem Ipsum"
                ) {
                    Color.blue.frame(height: 100)
                }
                .disabled(true)
                .padding(.horizontal)
            }
        }
    }
}

#endif

#endif
