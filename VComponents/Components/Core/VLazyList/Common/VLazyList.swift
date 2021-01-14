//
//  VLazyList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 29.09.20.
//

import SwiftUI

// MARK:- V Lazy List
/// Core component that is used throughout the framework as a lazy structure that either hosts content, or computes views on demad from an underlying collection of identified data
public struct VLazyList<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyListModel
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with content
    /// 
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - content: List content
    public init(
        model: VLazyListModel = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
    
    /// Initializes component with data, id, and row content
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - data: Data used to create views dynamically
    ///   - id: Key path to the provided data's identifier
    ///   - rowContent: View builder that creates views dynamically
    public init<Data, ID, RowContent>(
        model: VLazyListModel = .default,
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
    
    /// Initializes component with data and row content
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - data: Identified data used to create views dynamically
    ///   - rowContent: View builder that creates views dynamically
    public init<Data, ID, RowContent>(
        model: VLazyListModel = .default,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            Data.Element: Identifiable,
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
    
    /// Initializes component with range and row content
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - range: Constant range
    ///   - rowContent: View builder that creates views dynamically
    public init <RowContent>(
        model: VLazyListModel = .default,
        range: Range<Int>,
        rowContent: @escaping (Int) -> RowContent
    )
        where Content == ForEach<Range<Int>, Int, RowContent>
    {
        self.init(
            model: model,
            content: {
                ForEach(range, content: rowContent)
            }
        )
    }
}

// MARK:- Body
extension VLazyList {
    @ViewBuilder public var body: some View {
        switch model {
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
            VLazyList(model: .vertical(), range: range, rowContent: { number in
                Text(String(number)).padding(5)
            })

            VLazyList(model: .horizontal(), range: range, rowContent: { number in
                Text(String(number)).padding(5)
            })
        })
            .padding()
    }
}
