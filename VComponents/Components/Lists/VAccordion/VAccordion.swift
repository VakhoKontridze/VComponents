//
//  VAccordion.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - V Accordion
/// Expandable container component that draws a background, and either hosts content, or computes views on demad from an underlying collection of identified data
///
/// Component can be initialized with data or free content
///
/// Model and layout can be passed as parameters
///
/// There are three posible layouts:
///
/// 1. `Fixed`.
/// Passed as parameter. Component stretches vertically to take required space. Scrolling may be enabled on page.
///
/// 2. `Flexible`.
/// Passed as parameter. Component stretches vertically to occupy maximum space, but is constrainted in space given by container.Scrolling may be enabled inside component.
///
/// 3. `Constrained`.
/// `.frame()` modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component.
///
/// # Usage Example #
///
/// ```
/// struct AccordionRow: Identifiable {
///     let id: UUID = .init()
///     let title: String
/// }
///
/// @State var state: VAccordionState = .expanded
/// @State var data: [AccordionRow] = [
///     .init(title: "Red"),
///     .init(title: "Green"),
///     .init(title: "Blue")
/// ]
///
/// var body: some View {
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///         VAccordion(
///             state: $state,
///             headerTitle: "Lorem ipsum dolor sit amet",
///             data: data,
///             rowContent: { row in
///                 Text(row.title)
///                     .frame(
///                         maxWidth: .infinity,
///                         alignment: .leading
///                     )
///             }
///         )
///             .padding()
///     })
/// }
/// ```
///
public struct VAccordion<HeaderContent, Data, ID, RowContent, Content>: View
    where
        HeaderContent: View,
        Data: RandomAccessCollection,
        ID: Hashable,
        RowContent: View,
        Content: View
{
    // MARK: Properties
    private let model: VAccordionModel
    private let layoutType: VAccordionLayoutType
    
    @Binding private var state: VAccordionState
    @State private var animatableState: VAccordionState?
    
    private let headerContent: () -> HeaderContent
    
    private let contentType: ContentType
    private enum ContentType {
        case list(data: Data, id: KeyPath<Data.Element, ID>, rowContent: (Data.Element) -> RowContent)
        case freeForm(content: () -> Content)
    }
    
    // MARK: Initializers: View Builder
    /// Initializes component with state, header, data, id, and row content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where Content == Never
    {
        self.model = model
        self.layoutType = layoutType
        self._state = state
        self.headerContent = headerContent
        self.contentType = .list(
            data: data,
            id: id,
            rowContent: rowContent
        )
    }
    
    /// Initializes component with state, header title, data, id, and row content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        headerTitle: String,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            HeaderContent == VBaseHeaderFooter,
            Content == Never
    {
        self.init(
            model: model,
            layout: layoutType,
            state: state,
            headerContent: {
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle
                )
            },
            data: data,
            id: id,
            rowContent: rowContent
        )
    }

    // MARK: Initializers: Identified View Builder
    /// Initializes component with state, header, data, and row content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == Never,
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layoutType,
            state: state,
            headerContent: headerContent,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }
    
    /// Initializes component with state, header title, data, and row content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        headerTitle: String,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            HeaderContent == VBaseHeaderFooter,
            Content == Never,
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layoutType,
            state: state,
            headerContent: {
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle
                )
            },
            data: data,
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Free Content
    /// Initializes component with state, header, and free content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            Data == Array<Never>,
            ID == Never,
            RowContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self._state = state
        self.headerContent = headerContent
        self.contentType = .freeForm(
            content: content
        )
    }
    
    /// Initializes component with state, header title, and free content
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            HeaderContent == VBaseHeaderFooter,
            Data == Array<Never>,
            ID == Never,
            RowContent == Never
    {
        self.init(
            model: model,
            layout: layoutType,
            state: state,
            headerContent: {
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle
                )
            },
            content: content
        )
    }
}

// MARK: - Body
extension VAccordion {
    public var body: some View {
        performStateSets()
        
        return VSheet(model: model.sheetSubModel, content: {
            VStack(spacing: 0, content: {
                headerView
                divider
                contentView
            })
        })
    }
    
    private var headerView: some View {
        HStack(spacing: 0, content: {
            headerContent()
                .opacity(model.colors.header.for(state))
            
            Spacer()
            
            VChevronButton(
                model: model.chevronButonSubModel,
                direction: state.chevronButtonDirection,
                state: state.chevronButtonState,
                action: expandCollapse
            )
                .allowsHitTesting(!model.misc.expandCollapseOnHeaderTap) // No need for two-layer tap area
        })
            .padding(.leading, model.layout.headerMargins.leading)
            .padding(.trailing, model.layout.headerMargins.trailing)
            .padding(.top, model.layout.headerMargins.top)
            .padding(.bottom, (animatableState ?? state).isExpanded ? model.layout.headerMargins.bottomExpanded : model.layout.headerMargins.bottomCollapsed)
            .contentShape(Rectangle())
            .onTapGesture(perform: expandCollapseFromHeaderTap)
    }
    
    @ViewBuilder private var divider: some View {
        if (animatableState ?? state).isExpanded, model.layout.hasHeaderDivider {
            Rectangle()
                .frame(height: model.layout.headerDividerHeight)
                .padding(.leading, model.layout.headerDividerMargins.leading)
                .padding(.trailing, model.layout.headerDividerMargins.trailing)
                .padding(.top, model.layout.headerDividerMargins.top)
                .padding(.bottom, model.layout.headerDividerMargins.bottom)
                .foregroundColor(model.colors.headerDivider)
        }
    }
    
    @ViewBuilder private var contentView: some View {
        if (animatableState ?? state).isExpanded {
            Group(content: {
                switch contentType {
                case .list(let data, let id, let rowContent):
                    VBaseList(
                        model: model.baseListSubModel,
                        layout: layoutType,
                        data: data,
                        id: id,
                        rowContent: rowContent
                    )
                        .padding(.leading, model.layout.contentMargins.leading)
                        //.padding(.trailing, model.layout.contentMargin.trailing)
                        .padding(.top, model.layout.contentMargins.top)
                        .padding(.bottom, model.layout.contentMargins.bottom)
                    
                case .freeForm(let content):
                    content()
                        .padding(.leading, model.layout.contentMargins.leading)
                        .padding(.trailing, model.layout.contentMargins.trailing)
                        .padding(.top, model.layout.contentMargins.top)
                        .padding(.bottom, model.layout.contentMargins.bottom)
                }
            })
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - State Sets
extension VAccordion {
    private func performStateSets() {
        DispatchQueue.main.async(execute: {
            setAnimatableState()
        })
    }
}

// MARK: - Actions
extension VAccordion {
    private func expandCollapse() {
        withAnimation(model.animations.expandCollapse, { animatableState?.nextState() })
        state.nextState()
    }
    
    private func expandCollapseFromHeaderTap() {
        guard model.misc.expandCollapseOnHeaderTap else { return }
        expandCollapse()
    }
    
    private func setAnimatableState() {
        if animatableState == nil || animatableState != state {
            withAnimation(model.animations.expandCollapse, { animatableState = state })
        }
    }
}

// MARK: - Previews
struct VAccordion_Previews: PreviewProvider {
    @State private static var accordionState: VAccordionState = .expanded
    
    static var previews: some View {
        ZStack(alignment:. top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)
            
            VAccordion(
                state: $accordionState,
                headerTitle: "Lorem ipsum dolor sit amet",
                data: ["One", "Two", "Three"],
                id: \.self,
                rowContent: {
                    Text($0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            )
                .padding(16)
        })
    }
}
