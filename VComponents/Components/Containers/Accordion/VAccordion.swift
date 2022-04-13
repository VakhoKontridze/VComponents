//
//  VAccordion.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - V Accordion
/// Expandable container component that draws a background, and either hosts content, or computes views on demad from an underlying collection of identified data.
///
/// Component can be initialized with data or free content.
///
/// Model and layout can be passed as parameters.
///
/// Usage example:
///
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///     VAccordion(
///             isExpanded: $isExpanded,
///             headerTitle: "Lorem Ipsum",
///             content: {
///                 VList(
///                     layout: .fixed,
///                     data: 1..<10,
///                     id: \.self,
///                     rowContent: { num in
///                         Text(String(num))
///                             .padding(.vertical, 2)
///                             .frame(maxWidth: .infinity, alignment: .leading)
///                     }
///                 )
///             }
///         )
///             .padding()
///     })
///
public struct VAccordion<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    private let model: VAccordionModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VAccordionState
    private var internalState: VAccordionInternalState { .init(isEnabled: isEnabled, state: state) }
    
    private let headerLabel: VAccordionHeaderLabel<HeaderLabel>
    
    private let content: () -> Content
    
    @State private var headerHeight: CGFloat = 0
    @State private var accordionHeight: CGFloat = 0

    // MARK: Initializers - State
    /// Initializes component with header title and content.
    public init(
        model: VAccordionModel = .init(),
        state: Binding<VAccordionState>,
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
        model: VAccordionModel = .init(),
        state: Binding<VAccordionState>,
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
        model: VAccordionModel = .init(),
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
        model: VAccordionModel = .init(),
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
        VStack(spacing: 0, content: {
            headerView
            divider
            contentView
        })
            .readSize(onChange: { accordionHeight = $0.height })
            .frame(height: internalState.isExpanded ? accordionHeight : headerHeight, alignment: .top)
            .clipped()
            .transition(.move(edge: .bottom))
            .background(VSheet(model: model.sheetSubModel))
            .animation(model.animations.expandCollapse, value: isEnabled)
            .animation(model.animations.expandCollapse, value: state) // +withAnimation
    }
    
    private var headerView: some View {
        ZStack(content: {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(perform: expandCollapseFromHeaderTap)
            
            HStack(spacing: 0, content: {
                Group(content: {
                    switch headerLabel {
                    case .title(let title):
                        VText(
                            color: model.colors.headerTitle.for(internalState),
                            font: model.fonts.headerTitle,
                            title: title
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
        })
            .padding(.leading, model.layout.headerMargins.leading)
            .padding(.trailing, model.layout.headerMargins.trailing)
            .padding(.top, model.layout.headerMargins.top)
            .padding(.bottom, model.layout.headerMargins.bottom)
            .contentShape(Rectangle())
            .readSize(onChange: { headerHeight = $0.height })
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: model.layout.headerDividerHeight)
            .padding(.leading, model.layout.headerDividerMargins.leading)
            .padding(.trailing, model.layout.headerDividerMargins.trailing)
            .padding(.top, model.layout.headerDividerMargins.top)
            .padding(.bottom, model.layout.headerDividerMargins.bottom)
            .foregroundColor(model.colors.headerDivider)
    }
    
    private var contentView: some View {
        content()
            .padding(.leading, model.layout.contentMargins.leading)
            .padding(.trailing, model.layout.contentMargins.trailing)
            .padding(.top, model.layout.contentMargins.top)
            .padding(.bottom, model.layout.contentMargins.bottom)
            .frame(maxWidth: .infinity)
    }

    // MARK: Actions
    private func expandCollapse() {
        withAnimation(model.animations.expandCollapse, { state.setNextState() })
    }
    
    private func expandCollapseFromHeaderTap() {
        guard model.misc.expandCollapseOnHeaderTap else { return }
        expandCollapse()
    }
}

// MARK: - Helpers
extension VAccordionInternalState {
    fileprivate var chevronButtonDirection: VChevronButtonDirection {
        switch self {
        case .collapsed: return .down
        case .expanded: return .up
        case .disabled: return .down
        }
    }
}

// MARK: - Previews
struct VAccordion_Previews: PreviewProvider {
    @State private static var isExpanded: Bool = true
    
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)

            VAccordion(
                isExpanded: $isExpanded,
                headerTitle: "Lorem Ipsum",
                content: {
                    VList(
                        layout: .fixed,
                        data: 1..<10,
                        id: \.self,
                        rowContent: { num in
                            Text(String(num))
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                }
            )
                .padding()
        })
    }
}
