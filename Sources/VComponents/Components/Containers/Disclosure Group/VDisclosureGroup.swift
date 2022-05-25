//
//  VDisclosureGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group
/// Expandable container component that draws a background, and either hosts content, or computes views on demad from an underlying collection of identified data.
///
/// Component can be initialized with data or free content.
///
/// Model and layout can be passed as parameters.
///
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.ignoresSafeArea()
///
///         VDisclosureGroup(
///             isExpanded: $isExpanded,
///             headerTitle: "Lorem Ipsum",
///             content: {
///                 VList(data: 0..<20, content: { num in
///                     Text(String(num))
///                         .frame(maxWidth: .infinity, alignment: .leading)
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
    private let model: VDisclosureGroupModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VDisclosureGroupState
    private var internalState: VDisclosureGroupInternalState { .init(isEnabled: isEnabled, state: state) }
    
    private let headerLabel: VDisclosureGroupLabel<HeaderLabel>
    
    private let content: () -> Content
    
    private var hasDivider: Bool { model.layout.dividerHeight > 0 }

    // MARK: Initializers - State
    /// Initializes component with header title and content.
    public init(
        model: VDisclosureGroupModel = .init(),
        state: Binding<VDisclosureGroupState>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self._state = state
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes component with header and content.
    public init(
        model: VDisclosureGroupModel = .init(),
        state: Binding<VDisclosureGroupState>,
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with header title and content.
    public init(
        model: VDisclosureGroupModel = .init(),
        isExpanded: Binding<Bool>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self._state = .init(bool: isExpanded)
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes component with header and content.
    public init(
        model: VDisclosureGroupModel = .init(),
        isExpanded: Binding<Bool>,
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = .init(bool: isExpanded)
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        PlainDiclosureGroup(
            backgroundColor: model.colors.background,
            isExpanded: .init(
                get: { internalState.isExpanded },
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
            .background(VSheet(model: model.sheetSubModel))
            .cornerRadius(model.layout.cornerRadius)
            .animation(model.animations.expandCollapse, value: isEnabled)
            .animation(model.animations.expandCollapse, value: state) // +withAnimation
    }
    
    private var header: some View {
        HStack(spacing: 0, content: {
            Group(content: {
                switch headerLabel {
                case .title(let title):
                    VText(
                        color: model.colors.headerTitle.for(internalState),
                        font: model.fonts.headerTitle,
                        text: title
                    )
                    
                case .custom(let label):
                    label()
                        .opacity(model.colors.customHeaderLabelOpacities.for(internalState))
                }
            })
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VSquareButton.chevron(
                model: model.chevronButonSubModel,
                direction: internalState.chevronButtonDirection,
                action: expandCollapse
            )
                .disabled(!internalState.isEnabled)
        })
            .padding(model.layout.headerMargins)
    }
    
    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: model.layout.dividerHeight)
                .padding(model.layout.dividerMargins)
                .foregroundColor(model.colors.divider)
        }
    }
    
    private var contentView: some View {
        content()
            .padding(model.layout.contentMargins)
            .frame(maxWidth: .infinity)
    }

    // MARK: Actions
    private func expandCollapse() {
        withAnimation(model.animations.expandCollapse, { state.setNextState() })
    }
    
    private func expandCollapseFromHeaderTap(_ isExpanded: Bool) {
        guard
            model.misc.expandsAndCollapsesOnHeaderTap,
            isExpanded ^^ internalState.isExpanded
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
        case .collapsed: return .down
        case .expanded: return .up
        case .disabled: return .down
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
                    VList(data: 0..<10, content: { num in
                        Text(String(num))
                            .padding(.vertical, 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            )
                .padding()
        })
    }
}
