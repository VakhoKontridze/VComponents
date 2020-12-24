//
//  VLazyList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 29.09.20.
//

import SwiftUI

// MARK:- V Lazy List
public struct VLazyList<Content>: View where Content: View {
    // MARK: Properties
    private let listType: VLazyListType
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        _ listType: VLazyListType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.listType = listType
        self.content = content
    }
}

public extension VLazyList {
    init<Data, ID, RowContent>(
        _ listType: VLazyListType = .default,
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
            listType,
            content: {
                ForEach(data, id: id, content: { element in
                    rowContent(element)
                })
            }
        )
    }
}

public extension VLazyList {
    init<Data, ID, RowContent>(
        _ listType: VLazyListType = .default,
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
            listType,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }
}

public extension VLazyList {
    init<RowContent>(
        _ listType: VLazyListType = .default,
        range: Range<Int>,
        rowContent: @escaping (Int) -> RowContent
    )
        where
            Content == ForEach<Range<Int>, Int, RowContent>
    {
        self.init(
            listType,
            content: {
                ForEach(range, content: rowContent)
            }
        )
    }
}

// MARK:- Body
public extension VLazyList {
    @ViewBuilder var body: some View {
        switch listType {
        case .vertical(let model): VLazyListVertical(model: model, content: content)
        case .horizontal(let model): VLazyListHorizontal(model: model, content: content)
        }
    }
}

// MARK:- Preview
struct VLazyListView_Previews: PreviewProvider {
    private static let range: Range<Int> = 1..<101

    static var previews: some View {
        VStack(content: {
            VLazyList(.vertical(), range: range, rowContent: { number in
                Text(String(number)).padding(5)
            })

            VLazyList(.horizontal(), range: range, rowContent: { number in
                Text(String(number)).padding(5)
            })
        })
            .padding()
    }
}
