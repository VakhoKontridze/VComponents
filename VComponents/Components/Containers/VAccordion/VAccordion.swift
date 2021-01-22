//
//  VAccordion.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion
/// Expandable container component that draws a background, and either hosts content, or computes views on demad from an underlying collection of identified data
///
/// Component ca be initialized with data, VPickableItem, VPickableTitledItem, or free content
///
/// Model and layout can be passed as parameters
///
/// There are three posible layouts:
/// 1. Fixed. Passed as parameter. Component stretches vertically to take required space. Scrolling may be enabled on page.
/// 2. Flexible. Passed as parameter. Component stretches vertically to occupy maximum space, but is constrainted in space given by container. Scrolling may be enabled inside component.
/// 3. Constrained. `.frame()` modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component.
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
///             header: {
///                 VAccordionDefaultHeader(title: "Lorem ipsum dolor sit amet")
///             },
///             data: data,
///             content: { row in
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
public struct VAccordion<HeaderContent, Content, Data, ID, RowContent>: View
    where
        HeaderContent: View,
        Content: View,
        Data: RandomAccessCollection,
        ID: Hashable,
        RowContent: View
{
    // MARK: Properties
    private let model: VAccordionModel
    private let layoutType: VAccordionLayoutType
    
    @Binding private var state: VAccordionState
    
    private let headerContent: () -> HeaderContent
    
    private let contentType: ContentType
    private enum ContentType {
        case freeForm(content: () -> Content)
        case list(data: Data, id: KeyPath<Data.Element, ID>, rowContent: (Data.Element) -> RowContent)
    }
    
    // MARK: Initializers
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder header headerContent: @escaping () -> HeaderContent,
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
    
    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder header headerContent: @escaping () -> HeaderContent,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content rowContent: @escaping (Data.Element) -> RowContent
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

    public init(
        model: VAccordionModel = .init(),
        layout layoutType: VAccordionLayoutType = .fixed,
        state: Binding<VAccordionState>,
        @ViewBuilder header headerContent: @escaping () -> HeaderContent,
        data: Data,
        @ViewBuilder content rowContent: @escaping (Data.Element) -> RowContent
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
            header: headerContent,
            data: data,
            id: \Data.Element.id,
            content: rowContent
        )
    }
}

// MARK:- Body
extension VAccordion {
    public var body: some View {
        VSheet(model: model.sheetSubModel, content: {
            VStack(spacing: 0, content: {
                header
                divider
                contentView
            })
                .padding(.leading, model.layout.marginLeading)
                //.padding(.trailing, model.layout.marginTrailing)  Only applied to header and divider, as content requries custom logic
                .padding(.top, model.layout.marginTop)
                .padding(.bottom, state.isExpanded ? model.layout.marginBottomExpanded : model.layout.marginBottomCollapsed)
        })
    }
    
    private var header: some View {
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
                .allowsHitTesting(!model.expandCollapseOnHeaderTap) // No need for two-layer tap area
        })
            .padding(.trailing, model.layout.marginTrailing)
            .contentShape(Rectangle())
            .onTapGesture(perform: expandCollapseFromHeaderTap)
    }
    
    @ViewBuilder private var divider: some View {
        if state.isExpanded {
            Rectangle()
                .frame(height: model.layout.headerDividerHeight)
                .padding(.top, model.layout.headerDividerMarginTop)
                .padding(.bottom, model.layout.headerDividerMarginBottom)
                .padding(.trailing, model.layout.marginTrailing)
                .foregroundColor(model.colors.headerDivider)
        }
    }
    
    @ViewBuilder private var contentView: some View {
        if state.isExpanded {
            switch contentType {
            case .freeForm(let content):
                content()
                    .padding(.leading, model.layout.contentMarginLeading)
                    .padding(.trailing, model.layout.marginTrailing + model.layout.contentMarginTrailing)
                    .padding(.top, model.layout.contentMarginTop)
                    .padding(.bottom, model.layout.contentMarginBottom)
                
            case .list(let data, let id, let rowContent):
                VBaseList(
                    model: model.baseListSubModel,
                    layout: layoutType,
                    data: data,
                    id: id,
                    content: rowContent
                )
                    .padding(.leading, model.layout.contentMarginLeading)
                    .padding(.top, model.layout.contentMarginTop)
                    .padding(.bottom, model.layout.contentMarginBottom)
            }
        }
    }
}

// MARK:- Expand & Collapse
private extension VAccordion {
    func expandCollapse() {
        withAnimation { state.nextState() }
    }
    
    func expandCollapseFromHeaderTap() {
        if model.expandCollapseOnHeaderTap { expandCollapse() }
    }
}

// MARK:- Previews
struct VAccordion_Previews: PreviewProvider {
    @State private static var accordionState: VAccordionState = .expanded
    
    static var previews: some View {
        ZStack(alignment:. top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)
            
            VAccordion(
                state: $accordionState,
                header: { VAccordionDefaultHeader(title: "Lorem ipsum dolor sit amet") },
                data: ["One", "Two", "Three"],
                id: \.self,
                content: {
                    Text($0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            )
                .padding(16)
        })
    }
}
