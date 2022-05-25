//
//  VLazyScrollView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 29.09.20.
//

import SwiftUI

// MARK: - V Lazy Scroll View
/// Core component that is used throughout the library as a lazy structure that either hosts content, or computes views on demad from an underlying collection of identified data.
///
/// Component can be initialized with data or free content.
///
/// Model can be passed as parameter.
///
/// Component is a wrapped behind `ScrollView` and `LazyVStack`/`LazyHStack`, and supports lazy initialization.
///
/// Usage example:
///
///     struct ListRow: Identifiable {
///         let id: UUID = .init()
///         let title: String
///     }
///
///     @State var data: [ListRow] = [
///         .init(title: "Red"),
///         .init(title: "Green"),
///         .init(title: "Blue")
///     ]
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.ignoresSafeArea()
///
///             VLazyScrollView(data: data, content: { row in
///                 Text(row.title)
///                     .frame(maxWidth: .infinity, alignment: .leading)
///             })
///                 .padding()
///         })
///     }
/// 
/// Component can also be initialized with content.
public struct VLazyScrollView<Content>: View where Content: View {
    // MARK: Properties
    private let listType: VLazyScrollViewType
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with data, id, and row content.
    public init<Data, ID, RowContent>(
        type listType: VLazyScrollViewType = .default,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            ID: Hashable,
            RowContent: View
    {
        self.listType = listType
        self.content = {
            ForEach(
                data,
                id: id,
                content: { element in content(element) }
            )
        }
    }
    
    /// Initializes component with data and row content.
    public init<Data, ID, RowContent>(
        type listType: VLazyScrollViewType = .default,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            RowContent: View
    {
        self.listType = listType
        self.content = {
            ForEach(
                data,
                id: \.id,
                content: { element in content(element) }
            )
        }
    }

    /// Initializes component with constant range and row content.
    public init<RowContent>(
        type listType: VLazyScrollViewType = .default,
        data: Range<Int>,
        content: @escaping (Int) -> RowContent
    )
        where
            Content == ForEach<Range<Int>, Int, RowContent>
    {
        self.listType = listType
        self.content = {
            ForEach(
                data,
                id: \.self,
                content: { element in content(element) }
            )
        }
    }
    
    /// Initializes component with free content.
    public init(
        type listType: VLazyScrollViewType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.listType = listType
        self.content = content
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch listType._lazyScrollViewType {
        case .vertical(let model): VLazyScrollViewVertical(model: model, content: content)
        case .horizontal(let model): VLazyScrollViewHorizontal(model: model, content: content)
        }
    }
}

// MARK: - Preview
struct VLazyScrollViewView_Previews: PreviewProvider {
    private static var range: Range<Int> { 0..<100 }

    static var previews: some View {
        VStack(content: {
            VLazyScrollView(type: .vertical(), data: range, content: { number in
                Text(String(number)).padding(5)
            })

            VLazyScrollView(type: .horizontal(), data: range, content: { number in
                Text(String(number)).padding(5)
            })
        })
            .padding()
    }
}
