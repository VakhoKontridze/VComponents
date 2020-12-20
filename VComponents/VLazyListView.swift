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
    private let viewModel: VLazyListViewModel
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        viewModel: VLazyListViewModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
}

public extension VLazyListView {
    init<Data, ID, RowContent>(
        viewModel: VLazyListViewModel = .init(),
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
            viewModel: viewModel,
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
        viewModel: VLazyListViewModel = .init(),
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
            viewModel: viewModel,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }
}

// MARK:- Body
public extension VLazyListView {
    @ViewBuilder var body: some View {
        switch viewModel.scrollDirection {
        case .vertical(let horizontalAlignment):
            ScrollView(.vertical, showsIndicators: viewModel.showsIndicators, content: {
                LazyVStack(alignment: horizontalAlignment, spacing: 0, content: {
                    content()
                })
            })
            
        case .horizontal(let verticalAlignment):
            ScrollView(.horizontal, showsIndicators: viewModel.showsIndicators, content: {
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
    
    private static let horizontalVM: VLazyListViewModel = .init(
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
                VLazyListView(viewModel: horizontalVM, data: data, id: \.self, rowContent: { number in
                    Text(String(number))
                })
                
                VLazyListView(viewModel: horizontalVM, content: {
                    ForEach(data, id: \.self, content: { number in
                        Text(String(number))
                    })
                })
            })
        })
    }
}
