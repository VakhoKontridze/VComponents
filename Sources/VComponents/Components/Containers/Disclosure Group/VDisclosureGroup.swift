//
//  VDisclosureGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group
/// Expandable container component that hosts content.
///
///     @State private var state: VDisclosureGroupState = .expanded
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             Color(uiColor: UIColor.secondarySystemBackground)
///                 .ignoresSafeArea()
///
///             VDisclosureGroup(
///                 uiModel: .systemBackgroundColor,
///                 state: $state,
///                 headerTitle: "Lorem Ipsum",
///                 content: {
///                     Color.blue
///                         .frame(height: 150)
///                 }
///             )
///             .padding()
///         })
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
public struct VDisclosureGroup<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VDisclosureGroupUIModel
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
    private let headerLabel: VDisclosureGroupHeaderLabel<HeaderLabel>

    // MARK: Properties - Content
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes `VDisclosureGroup` with header title and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        state: Binding<VDisclosureGroupState>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes `VDisclosureGroup` with header and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        state: Binding<VDisclosureGroupState>,
        @ViewBuilder headerLabel: @escaping (VDisclosureGroupInternalState) -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._state = state
        self.headerLabel = .label(label: headerLabel)
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel, content: {
            PlainDisclosureGroup(
                uiModel: uiModel.plainDisclosureGroupSubUIModel,
                isExpanded: Binding(
                    get: { internalState == .expanded },
                    set: { expandCollapseFromHeaderTap($0) }
                ),
                label: { headerView },
                content: {
                    VStack(spacing: 0, content: {
                        dividerView
                        contentView
                    })
                }
            )
        })
        .applyIf(uiModel.appliesExpandCollapseAnimation, transform: {
            $0
                .animation(uiModel.expandCollapseAnimation, value: isEnabled)
                .animation(uiModel.expandCollapseAnimation, value: state) // +withAnimation
        })
    }
    
    private var headerView: some View {
        HStack(spacing: 0, content: {
            Group(content: {
                switch headerLabel {
                case .title(let title):
                    Text(title)
                        .lineLimit(1)
                        .foregroundStyle(uiModel.headerTitleTextColors.value(for: internalState))
                        .font(uiModel.headerTitleTextFont)
                        .applyIfLet(uiModel.headerTitleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

                case .label(let label):
                    label(internalState)
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
            
            Spacer(minLength: 0)
            
            VRectangularButton(
                uiModel: uiModel.disclosureButtonSubUIModel,
                action: expandCollapse,
                icon: uiModel.disclosureButtonIcon
            )
            .rotationEffect(Angle(radians: uiModel.disclosureButtonAngles.value(for: internalState)))
        })
        .padding(uiModel.headerMargins)
    }
    
    @ViewBuilder
    private var dividerView: some View {
        if uiModel.dividerHeight.toPoints(scale: displayScale) > 0 {
            Rectangle()
                .frame(height: uiModel.dividerHeight.toPoints(scale: displayScale))
                .padding(uiModel.dividerMargins)
                .foregroundStyle(uiModel.dividerColor)
        }
    }
    
    private var contentView: some View {
        content()
            .frame(maxWidth: .infinity)
            .padding(uiModel.contentMargins)
    }
    
    // MARK: Actions
    private func expandCollapse() {
        // Not affected by animation flag
        withAnimation(uiModel.expandCollapseAnimation, { state.setNextState() })
    }
    
    private func expandCollapseFromHeaderTap(_ isExpanded: Bool) {
        guard
            uiModel.expandsAndCollapsesOnHeaderTap,
            isExpanded ^^ (internalState == .expanded)
        else {
            return
        }
        
        expandCollapse()
    }
}

// MARK: - Previews
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var state: VDisclosureGroupState = .expanded

        var body: some View {
            PreviewContainer(content: {
                VDisclosureGroup(
                    state: $state,
                    headerTitle: "Lorem Ipsum",
                    content: { Color.blue.frame(height: 100) }
                )
                .padding(.horizontal)
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    Preview_StatesContentView()
})

#if !os(macOS)

#Preview("States (System Background Color)", body: {
    Preview_StatesContentView(layer: .secondary, uiModel: .systemBackgroundColor)
})

#endif

private struct Preview_StatesContentView: View {
    private let layer: PreviewContainerLayer
    private let uiModel: VDisclosureGroupUIModel

    init(
        layer: PreviewContainerLayer = .primary,
        uiModel: VDisclosureGroupUIModel = .init()
    ) {
        self.layer = layer
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer(layer: layer, content: {
            PreviewRow("Collapsed", content: {
                VDisclosureGroup(
                    uiModel: uiModel,
                    state: .constant(.collapsed),
                    headerTitle: "Lorem Ipsum",
                    content: { Color.blue.frame(height: 100) }
                )
                .padding(.horizontal)
            })

            PreviewRow("Expanded", content: {
                VDisclosureGroup(
                    uiModel: uiModel,
                    state: .constant(.expanded),
                    headerTitle: "Lorem Ipsum",
                    content: { Color.blue.frame(height: 100) }
                )
                .padding(.horizontal)
            })

            PreviewRow("Pressed (Button)", content: {
                VDisclosureGroup(
                    uiModel: {
                        var uiModel: VDisclosureGroupUIModel = uiModel
                        uiModel.disclosureButtonSubUIModel.backgroundColors.enabled = uiModel.disclosureButtonSubUIModel.backgroundColors.pressed
                        uiModel.disclosureButtonSubUIModel.iconColors!.enabled = uiModel.disclosureButtonSubUIModel.iconColors!.pressed // Force-unwrap
                        return uiModel
                    }(),
                    state: .constant(.collapsed),
                    headerTitle: "Lorem Ipsum",
                    content: { Color.blue.frame(height: 100) }
                )
                .padding(.horizontal)
            })

            PreviewRow("Disabled", content: {
                VDisclosureGroup(
                    uiModel: {
                        var uiModel: VDisclosureGroupUIModel = uiModel
                        uiModel.disclosureButtonSubUIModel.backgroundColors.enabled = uiModel.disclosureButtonSubUIModel.backgroundColors.disabled
                        uiModel.disclosureButtonSubUIModel.iconColors!.enabled = uiModel.disclosureButtonSubUIModel.iconColors!.disabled // Force-unwrap
                        return uiModel
                    }(),
                    state: .constant(.expanded),
                    headerTitle: "Lorem Ipsum",
                    content: { Color.blue.frame(height: 100) }
                )
                .disabled(true)
                .padding(.horizontal)
            })
        })
    }
}

#endif

#endif
