//
//  VBaseList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Base List
struct VBaseList<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        Content: View
{
    // MARK: Properties
    private let model: VBaseListModel
    
    private let layoutType: VBaseListLayoutType
    
    private let data: [Element]
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    typealias Element = VBaseListElement<ID, Data.Element>
    
    // MARK: Initializers
    init(
        model: VBaseListModel,
        layoutType: VBaseListLayoutType,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self.layoutType = layoutType
        self.data = data.map { .init(id: $0[keyPath: id], value: $0) }
        self.id = id
        self.content = content
    }
}

// MARK:- Body
extension VBaseList {
    @ViewBuilder var body: some View {
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
            VLazyList(
                model: .vertical(model.lazyListModel),
                data: data.enumeratedArray(),
                id: \.element.id,
                rowContent: { contentView(i: $0, element: $1) }
            )
        }
    }
    
    private func contentView(i: Int, element: Element) -> some View {
        VStack(spacing: 0, content: {
            content(element.value)

            if showSeparator(for: i) {
                Rectangle()
                    .frame(height: model.layout.separatorHeight)
                    .padding(.vertical, model.layout.separatorMarginVer)
                    .foregroundColor(model.colors.separator)
            }
        })
            .padding(.trailing, model.layout.marginTrailing)
    }
}

// MARK:- Helpers
private extension VBaseList {
    func showSeparator(for i: Int) -> Bool {
        model.layout.hasSeparator &&
        i <= data.count-2
    }
}

// MARK:- Preview
struct VBaseList_Previews: PreviewProvider {
    struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String

        static let count: Int = 10
    }
    
    static let rows: [Row] = (0..<Row.count).map { i in
        .init(
            id: i,
            color: [.red, .green, .blue][i % 3],
            title: spellOut(i + 1)
        )
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
        VBaseList(model: .init(), layoutType: .fixed, data: rows, id: \.id, content: { row in
            rowContent(title: row.title, color: row.color)
        })
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(20)
    }
}
