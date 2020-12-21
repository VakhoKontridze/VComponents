//
//  VLazyListView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 29.09.20.
//

import SwiftUI

// MARK:- V Lazy List View
public struct VLazyListView<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyListModel
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VLazyListModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

public extension VLazyListView {
    init<Data, ID, RowContent>(
        model: VLazyListModel = .init(),
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            ID: Hashable,
            RowContent: View
    {
        self.init(
            model: model,
            content: {
                ForEach(data, id: id, content: { element in
                    rowContent(element)
                })
            }
        )
    }
}

public extension VLazyListView {
    init<Data, ID, RowContent>(
        model: VLazyListModel = .init(),
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection, Data.Element: Identifiable,
            ID == Data.Element.ID,
            RowContent: View
    {
        self.init(
            model: model,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }
}

// MARK:- Body
public extension VLazyListView {
    @ViewBuilder var body: some View {
        switch model.scrollDirection {
        case .vertical(let horizontalAlignment):
            ScrollView(.vertical, showsIndicators: model.showsIndicators, content: {
                LazyVStack(alignment: horizontalAlignment, spacing: 0, content: {
                    content()
                })
            })
            
        case .horizontal(let verticalAlignment):
            ScrollView(.horizontal, showsIndicators: model.showsIndicators, content: {
                LazyHStack(alignment: verticalAlignment, spacing: 0, content: {
                    content()
                })
            })
        }
    }
}

// MARK:- Preview
struct VLazyListView_Previews: PreviewProvider {
    private static let data: [Int] = (1...100).map { $0 }
    
    private static let horizontalVM: VLazyListModel = .init(
        scrollDirection: .horizontal(aligment: .center),
        showsIndicators: true
    )
    
    static var previews: some View {
        VStack(content: {
            HStack(content: {
                VLazyListView(data: data, id: \.self, rowContent: { number in
                    Text(String(number))
                })
                
                VLazyListView(content: {
                    ForEach(data, id: \.self, content: { number in
                        Text(String(number))
                    })
                })
            })
            
            HStack(content: {
                VLazyListView(model: horizontalVM, data: data, id: \.self, rowContent: { number in
                    Text(String(number))
                })
                
                VLazyListView(model: horizontalVM, content: {
                    ForEach(data, id: \.self, content: { number in
                        Text(String(number))
                    })
                })
            })
        })
    }
}
