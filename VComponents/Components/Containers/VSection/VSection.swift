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
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    // MARK: Initializers
    public init(
        model: VSectionModel = .init(),
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self.data = data
        self.id = id
        self.content = content
    }

    public init(
        model: VSectionModel = .init(),
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            data: data,
            id: \Data.Element.id,
            content: content
        )
    }
}

// MARK:- Body
public extension VSection {
    var body: some View {
        VSheet(model: model.sheetModel, content: {
            VGenericListContent(model: model.tableModel, data: data, id: id, content: { row in
                content(row)
                    //.padding(.trailing, model.layout.contentPadding) Passed to Table via model
            })
                .padding([.top, .bottom, .leading], model.layout.contentPadding)
        })
    }
}

// MARK:- Preview
struct VSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VSection(data: VGenericListContent_Previews.rows, content: { row in
                VGenericListContent_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
