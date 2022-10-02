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
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.ignoresSafeArea()
///
///         VDisclosureGroup(
///             isExpanded: $isExpanded,
///             headerTitle: "Lorem Ipsum",
///             content: {
///                 LazyVStack(spacing: 0, content: {
///                     ForEach(0..<10, content: { num in
///                         VListRow(separator: .noFirstAndLastSeparators(isFirst: num == 0), content: {
///                             Text(String(num))
///                                 .frame(maxWidth: .infinity, alignment: .leading)
///                         })
///                     })
///                 })
///             }
///         )
///             .padding()
///     })
///
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
    
    private let headerLabel: VDisclosureGroupLabel<HeaderLabel>
    
    private let content: () -> Content
    
    private var hasDivider: Bool { uiModel.layout.dividerHeight > 0 }

    // MARK: Initializers - State
    /// Initializes component with header title and content.
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
    
    /// Initializes component with header and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        state: Binding<VDisclosureGroupState>,
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._state = state
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with header title and content.
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
    
    /// Initializes component with header and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        isExpanded: Binding<Bool>,
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._state = .init(isExpanded: isExpanded)
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        VSheet(uiModel: uiModel.sheetSubUIModel, content: {
            PlainDisclosureGroup(
                uiModel: uiModel.plainDisclosureGroupSubUIModel,
                isExpanded: .init(
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
                    
                case .custom(let label):
                    label()
                        .opacity(uiModel.colors.customHeaderLabelOpacities.value(for: internalState))
                }
            })
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsHitTesting(false)
            
            Spacer()
            
            VRoundedButton.chevron(
                uiModel: uiModel.chevronButtonSubUIModel,
                direction: internalState.chevronButtonDirection,
                action: expandCollapse
            )
                .disabled(!internalState.isEnabled)
        })
            .padding(uiModel.layout.headerMargins)
    }
    
    @ViewBuilder private var divider: some View {
        if hasDivider {
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
extension VDisclosureGroupInternalState {
    fileprivate var chevronButtonDirection: VChevronButtonDirection {
        switch self {
        case .collapsed: return .right
        case .expanded: return .down
        case .disabled: return .right
        }
    }
}

// MARK: - Previews
struct VDisclosureGroup_Previews: PreviewProvider {
    @State private static var isExpanded: Bool = true
    
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas.ignoresSafeArea()

            VDisclosureGroup(
                isExpanded: $isExpanded,
                headerTitle: "Lorem Ipsum",
                content: {
                    LazyVStack(spacing: 0, content: {
                        ForEach(0..<10, content: { num in
                            VListRow(separator: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                                Text(String(num))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            })
                        })
                    })
                }
            )
                .padding()
        })
    }
}
