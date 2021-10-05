//
//  VList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK: - V List
/// Container component that draws a background, and computes views on demad from an underlying collection of identified data.
///
/// Model and layout can be passed as parameters.
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
/// Unlike `VBaseList`, `VList` has spacing between rows and scrolling indicaator.
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
///             ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///             VList(data: data, rowContent: { row in
///                 Text(row.title)
///                     .frame(maxWidth: .infinity, alignment: .leading)
///             })
///                 .padding()
///         })
///     }
///
public struct VList<Data, ID, RowContent>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        RowContent: View
    {
    // MARK: Properties
    private let model: VListModel
    private let layoutType: VListLayoutType
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let rowContent: (Data.Element) -> RowContent
    
    // MARK: Initializers - View Builder
    /// Initializes component with data, id, and row content.
    public init(
        model: VListModel = .init(),
        layout layoutType: VListLayoutType = .default,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self.layoutType = layoutType
        self.data = data
        self.id = id
        self.rowContent = rowContent
    }
    
    // MARK: Initializers - Identified View Builder
    /// Initializes component with data and row content.
    public init(
        model: VListModel = .init(),
        layout layoutType: VListLayoutType = .default,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layoutType,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }

    // MARK: Body
    public var body: some View {
        VSheet(model: model.sheetSubModel, content: { contentView })
    }
    
    private var contentView: some View {
        VBaseList(
            model: model.baseListSubModel,
            layout: layoutType,
            data: data,
            id: id,
            rowContent: rowContent
        )
            .padding([.leading, .top, .bottom], model.layout.contentMargin)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
struct VList_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VList(data: VBaseList_Previews.rows, rowContent: { row in
                VBaseList_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
