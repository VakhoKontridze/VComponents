//
//  VAccordion.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion
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
}

// MARK:- Body
extension VAccordion {
    public var body: some View {
        VSheet(model: model.sheetModel, content: {
            VStack(spacing: 0, content: {
                header
                divider
                contentView
            })
                .padding(.leading, model.layout.marginLeading)
                //.padding(.trailing, model.layout.marginTrailing)  Is applied to header and divider, as content requries custom login
                .padding(.top, model.layout.marginTop)
                .padding(.bottom, state.isExpanded ? model.layout.marginBottomExpanded : model.layout.marginBottomCollapsed)
        })
    }
    
    private var header: some View {
        HStack(spacing: 0, content: {
            headerContent()
                .opacity(model.headerOpacity(for: state))
            
            Spacer()
            
            VChevronButton(
                model: .init(),
                direction: state.chevronButtonDirection,
                state: state.chevronButtonState,
                action: { withAnimation { state.nextState() } }
            )
        })
            .padding(.trailing, model.layout.marginTrailing)
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
                    .padding(.trailing, model.layout.contentMarginTrailing)
                    .padding(.top, model.layout.contentMarginTop)
                    .padding(.bottom, model.layout.contentMarginBottom)
                
            case .list(let data, let id, let rowContent):
                VBaseList(
                    model: model.genericListContentModel,
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

// MARK:- Previews
struct VAccordion_Previews: PreviewProvider {
    @State private static var accordionState: VAccordionState = .expanded
    
    static var previews: some View {
        ZStack(alignment:. top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)
            
            VAccordion(
                layout: .fixed,
                state: $accordionState,
                headerContent: { VAccordionDefaultHeader(title: "Title") },
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
