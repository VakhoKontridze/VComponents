//
//  VLazyScrollView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 29.09.20.
//

import SwiftUI

// MARK:- V Lazy Scroll View
/// Core component that is used throughout the framework as a lazy structure that either hosts content, or computes views on demad from an underlying collection of identified data
///
/// Component can be initialized with data or free content
///
/// Model can be passed as parameter
///
/// Component is a wrapped behind `ScrollView` and `LazyVStack`/`LazyHStack`, and supports lazy initialization
///
/// # Usage Example #
///
/// ```
/// struct ListRow: Identifiable {
///     let id: UUID = .init()
///     let title: String
/// }
///
/// @State var data: [ListRow] = [
///     .init(title: "Red"),
///     .init(title: "Green"),
///     .init(title: "Blue")
/// ]
///
/// var body: some View {
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///         VLazyScrollView(data: data, content: { row in
///             Text(row.title)
///                 .frame(maxWidth: .infinity, alignment: .leading)
///         })
///             .padding()
///     })
/// }
/// ```
/// 
/// Component can also be initialized with content
///
public struct VLazyScrollView<Content>: View where Content: View {
    // MARK: Properties
    private let listType: VLazyScrollViewType
    private let content: () -> Content
    
    // MARK: Initializers: View Builder
    /// Initializes component with data, id, and row content
    public init<Data, ID, RowContent>(
        type listType: VLazyScrollViewType = .default,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            ID: Hashable,
            RowContent: View
    {
        self.init(
            type: listType,
            content: {
                ForEach(data, id: id, content: { element in
                    rowContent(element)
                })
            }
        )
    }
    
    // MARK: Initializers: Identified View Builder
    /// Initializes component with data and row content
    public init<Data, ID, RowContent>(
        type listType: VLazyScrollViewType = .default,
        data: Data,
        @ViewBuilder content rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == ForEach<Data, ID, RowContent>,
            Data: RandomAccessCollection,
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            RowContent: View
    {
        self.init(
            type: listType,
            data: data,
            id: \Data.Element.id,
            content: rowContent
        )
    }

    // MARK: Initializers: Range
    /// Initializes component with range and row content
    public init <RowContent>(
        type listType: VLazyScrollViewType = .default,
        range: Range<Int>,
        content rowContent: @escaping (Int) -> RowContent
    )
        where Content == ForEach<Range<Int>, Int, RowContent>
    {
        self.init(
            type: listType,
            content: {
                ForEach(range, content: rowContent)
            }
        )
    }
    
    // MARK: Initializers: Free Content
    /// Initializes component with free content
    public init(
        type listType: VLazyScrollViewType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.listType = listType
        self.content = content
    }
}

// MARK:- Body
extension VLazyScrollView {
    @ViewBuilder public var body: some View {
        switch listType {
        case .vertical(let model): VLazyScrollViewVertical(model: model, content: content)
        case .horizontal(let model): VLazyScrollViewHorizontal(model: model, content: content)
        }
    }
}

// MARK:- Preview
struct VLazyScrollViewView_Previews: PreviewProvider {
    private static let range: Range<Int> = 1..<101

    static var previews: some View {
        VStack(content: {
            VLazyScrollView(type: .vertical(), range: range, content: { number in
                Text(String(number)).padding(5)
            })

            VLazyScrollView(type: .horizontal(), range: range, content: { number in
                Text(String(number)).padding(5)
            })
        })
            .padding()
    }
}
