//
//  VDisclosureGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group
/// Expandable container component that draws a background, and hosts content.
///
/// UI Model and layout can be passed as parameters.
///
///     @State private var isExpanded: Bool = true
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.ignoresSafeArea()
///
///             VDisclosureGroup(
///                 isExpanded: $isExpanded,
///                 headerTitle: "Lorem Ipsum",
///                 content: {
///                     LazyVStack(spacing: 0, content: {
///                         ForEach(0..<10, content: { num in
///                             VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
///                                 Text(String(num))
///                                     .frame(maxWidth: .infinity, alignment: .leading)
///                             })
///                         })
///                     })
///                 }
///             )
///              .padding()
///         })
///     }
///
@available(iOS 14.0, *)
@available(macOS, unavailable) // No `PlainDisclosureGroup` support
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VDisclosureGroup<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    private let uiModel: VDisclosureGroupUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VDisclosureGroupState
    private var internalState: VDisclosureGroupInternalState { .init(isEnabled: isEnabled, isExpanded: state == .expanded) }
    
    private let headerLabel: VDisclosureGroupHeaderLabel<HeaderLabel>
    
    private let content: () -> Content

    // MARK: Initializers - State
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
    
    // MARK: Initializers - Bool
    /// Initializes `VDisclosureGroup` with header title and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        isExpanded: Binding<Bool>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.uiModel = uiModel
        self._state = .init(isExpanded: isExpanded)
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes `VDisclosureGroup` with header and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        isExpanded: Binding<Bool>,
        @ViewBuilder headerLabel: @escaping (VDisclosureGroupInternalState) -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._state = Binding(isExpanded: isExpanded)
        self.headerLabel = .label(label: headerLabel)
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        VSheet(uiModel: uiModel.sheetSubUIModel, content: {
            PlainDisclosureGroup(
                uiModel: uiModel.plainDisclosureGroupSubUIModel,
                isExpanded: Binding(
                    get: { internalState == .expanded },
                    set: { expandCollapseFromHeaderTap($0) }
                ),
                label: { header },
                content: {
                    VStack(spacing: 0, content: {
                        divider
                        contentView
                    })
                }
            )
        })
            .animation(uiModel.animations.expandCollapse, value: isEnabled)
            .animation(uiModel.animations.expandCollapse, value: state) // +withAnimation
    }
    
    private var header: some View {
        HStack(spacing: 0, content: {
            Group(content: {
                switch headerLabel {
                case .title(let title):
                    VText(
                        color: uiModel.colors.headerTitle.value(for: internalState),
                        font: uiModel.fonts.headerTitle,
                        text: title
                    )
                    
                case .label(let label):
                    label(internalState)
                }
            })
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsHitTesting(false)
            
            Spacer()
            
            VRoundedButton(
                uiModel: uiModel.chevronButtonSubUIModel,
                action: expandCollapse,
                icon: ImageBook.chevronUp
            )
                .rotationEffect(Angle(degrees: internalState.chevronButtonDirection.angle))
        })
            .padding(uiModel.layout.headerMargins)
    }
    
    @ViewBuilder private var divider: some View {
        if uiModel.layout.dividerHeight > 0 {
            Rectangle()
                .frame(height: uiModel.layout.dividerHeight)
                .padding(uiModel.layout.dividerMargins)
                .foregroundColor(uiModel.colors.divider)
        }
    }
    
    private var contentView: some View {
        content()
            .padding(uiModel.layout.contentMargins)
            .frame(maxWidth: .infinity)
    }

    // MARK: Actions
    private func expandCollapse() {
        withAnimation(uiModel.animations.expandCollapse, { state.setNextState() })
    }
    
    private func expandCollapseFromHeaderTap(_ isExpanded: Bool) {
        guard
            uiModel.misc.expandsAndCollapsesOnHeaderTap,
            isExpanded ^^ (internalState == .expanded)
        else {
            return
        }
        
        expandCollapse()
    }
}

// MARK: - Helpers
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupInternalState {
    fileprivate var chevronButtonDirection: ChevronButtonDirection {
        switch self {
        case .collapsed: return .right
        case .expanded: return .down
        case .disabled: return .right
        }
    }
}

// MARK: - Previews
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VDisclosureGroup_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            InsettedContentPreview().previewDisplayName("Insetted Content")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem Ipsum" }

    private static func content() -> some View {
        ColorBook.accentBlue
            .frame(height: 100)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VDisclosureGroupState = .expanded
        
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VDisclosureGroup(
                    state: $state,
                    headerTitle: headerTitle,
                    content: content
                )
                    .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Collapsed",
                    content: {
                        VDisclosureGroup(
                            state: .constant(.collapsed),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Expanded",
                    content: {
                        VDisclosureGroup(
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Pressed (Button)",
                    content: {
                        VDisclosureGroup(
                            uiModel: {
                                var uiModel: VDisclosureGroupUIModel = .init()
                                uiModel.colors.chevronButtonSubUIModel.background.enabled = uiModel.colors.chevronButtonSubUIModel.background.pressed
                                uiModel.colors.chevronButtonSubUIModel.icon.enabled = uiModel.colors.chevronButtonSubUIModel.icon.pressed
                                return uiModel
                            }(),
                            state: .constant(.collapsed),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VDisclosureGroup(
                            uiModel: { // Needed for some reason
                                var uiModel: VDisclosureGroupUIModel = .init()
                                uiModel.colors.chevronButtonSubUIModel.background.enabled = uiModel.colors.chevronButtonSubUIModel.background.disabled
                                uiModel.colors.chevronButtonSubUIModel.icon.enabled = uiModel.colors.chevronButtonSubUIModel.icon.disabled
                                return uiModel
                            }(),
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Insetted Content",
                    content: {
                        VDisclosureGroup(
                            uiModel: .insettedContent,
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
            })
        }
    }
}
