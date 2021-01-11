//
//  VSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section
public struct VSection<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        Content: View
    {
    // MARK: Properties
    private let model: VSectionModel
    
    private let layout: VSectionLayout
    
    private let title: String?
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    // MARK: Initializers
    public init(
        model: VSectionModel = .init(),
        layout: VSectionLayout = .fixed,
        title: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self.layout = layout
        self.title = title
        self.data = data
        self.id = id
        self.content = content
    }

    public init(
        model: VSectionModel = .init(),
        layout: VSectionLayout = .fixed,
        title: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layout,
            title: title,
            data: data,
            id: \Data.Element.id,
            content: content
        )
    }
}

// MARK:- Body
public extension VSection {
    var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleMarginBottom, content: {
            if let title = title, !title.isEmpty {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, model.layout.titleMarginHor)
                    .font(model.titleFont)
                    .foregroundColor(model.colors.title)
            }
            
            VSheet(model: model.sheetModel, content: {
                VGenericListContent(
                    model: model.genericListContentModel,
                    layout: layout,
                    data: data,
                    id: id,
                    content: content
                )
                    .padding([.leading, .top, .bottom], model.layout.contentMargin)
            })
        })
    }
}

// MARK:- Preview
struct VSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VSection(layout: .fixed, title: "TITLE", data: VGenericListContent_Previews.rows, content: { row in
                VGenericListContent_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
