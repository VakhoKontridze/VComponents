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
    
    private let layoutType: VSectionLayoutType
    
    private let title: String?
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    // MARK: Initializers
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .fixed,
        title: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self.layoutType = layoutType
        self.title = title
        self.data = data
        self.id = id
        self.content = content
    }

    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .fixed,
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
            layout: layoutType,
            title: title,
            data: data,
            id: \Data.Element.id,
            content: content
        )
    }
}

// MARK:- Body
extension VSection {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleMarginBottom, content: {
            if let title = title, !title.isEmpty {
                VBaseTitle(
                    title: title,
                    color: model.colors.title,
                    font: model.titleFont,
                    type: .oneLine
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, model.layout.titleMarginHor)
            }
            
            VSheet(model: model.sheetModel, content: {
                VBaseList(
                    model: model.genericListContentModel,
                    layout: layoutType,
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
            
            VSection(layout: .fixed, title: "TITLE", data: VBaseList_Previews.rows, content: { row in
                VBaseList_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
