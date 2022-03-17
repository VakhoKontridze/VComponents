//
//  VBaseList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK: - V Base List
/// Core component that is used throughout the library as a structure that either hosts content, or computes views on demad from an underlying collection of identified data.
///
/// Model, and layout can be passed as parameters.
///
/// There are three posible layouts:
///
/// 1. `Fixed`.
/// Passed as parameter. Component stretches vertically to take required space. Scrolling may be enabled on page.
///
/// 2. `Flexible`.
/// Passed as parameter. Component stretches vertically to occupy maximum space, but is constrainted in space given by container.Scrolling may be enabled inside component.
///
/// 3. `Constrained`.
/// `.frame()` modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component.
///
/// Usage example:
///
///     struct ListRow: Identifiable {
///         let id: UUID = .init()
///         let title: String
///     }
///
///     let data: [ListRow] = [
///         .init(title: "Red"),
///         .init(title: "Green"),
///         init(title: "Blue")
///     ]
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///             VBaseList(data: data, rowContent: { row in
///                 Text(row.title)
///                     .frame(maxWidth: .infinity, alignment: .leading)
///             })
///                 .padding()
///         })
///     }
///
public struct VBaseList<Data, ID, RowContent>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        RowContent: View
{
    // MARK: Properties
    private let model: VBaseListModel
    
    private let layoutType: VBaseListLayoutType
    
    private let data: [Element]
    private let rowContent: (Data.Element) -> RowContent
    
    typealias Element = VBaseListElement<ID, Data.Element>
    
    // MARK: Initializers - View Builder
    /// Initializes component with data, id, and row content.
    public init(
        model: VBaseListModel = .init(),
        layout layoutType: VBaseListLayoutType = .default,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self.layoutType = layoutType
        self.data = data.map { .init(id: $0[keyPath: id], value: $0) }
        self.rowContent = rowContent
    }
    
    // MARK: Initializers - Identified View Builder
    /// Initializes component with data and row content.
    public init(
        model: VBaseListModel = .init(),
        layout layoutType: VBaseListLayoutType = .default,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.model = model
        self.layoutType = layoutType
        self.data = data.map { .init(id: $0[keyPath: \Data.Element.id], value: $0) }
        self.rowContent = rowContent
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch layoutType {
        case .fixed:
            VStack(spacing: 0, content: {
                ForEach(
                    data.enumeratedArray(),
                    id: \.element.id,
                    content: { contentView(i: $0, element: $1) }
                )
            })
            
        case .flexible:
            VLazyScrollView(
                type: .vertical(model.lazyScrollViewSubModel),
                data: data.enumeratedArray(),
                id: \.element.id,
                content: { contentView(i: $0, element: $1) }
            )
        }
    }
    
    private func contentView(i: Int, element: Element) -> some View {
        VStack(spacing: 0, content: {
            rowContent(element.value)

            if showDivider(for: i) {
                Rectangle()
                    .frame(height: model.layout.dividerHeight)
                    .padding(.leading, model.layout.dividerMargins.leading)
                    .padding(.trailing, model.layout.dividerMargins.trailing)
                    .padding(.vertical, model.layout.dividerMarginVertical)
                    .foregroundColor(model.colors.divider)
            }
        })
            .padding(.trailing, model.layout.marginTrailing)
    }

    // MARK: Helpers
    private func showDivider(for i: Int) -> Bool {
        model.layout.hasDivider &&
        i <= data.count-2
    }
}

// MARK: - Preview
struct VBaseList_Previews: PreviewProvider {
    struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String

        static var count: Int { 10 }
    }
    
    static var rows: [Row] {
        (0..<Row.count).map { i in
            .init(
                id: i,
                color: [.red, .green, .blue][i % 3],
                title: spellOut(i + 1)
            )
        }
    }
    
    private static func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
    
    static func rowContent(title: String, color: Color) -> some View {
        HStack(spacing: 10, content: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(color.opacity(0.8))
                .frame(dimension: 32)

            Text(title)
                .font(.body)
                .foregroundColor(ColorBook.primary)
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    static var previews: some View {
        VBaseList(data: rows, rowContent: { row in
            rowContent(title: row.title, color: row.color)
        })
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(20)
    }
}
