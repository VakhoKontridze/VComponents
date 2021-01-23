//
//  VSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section
/// Container component that draws a background, and computes views on demad from an underlying collection of identified data
///
/// Model, layout, and title can be passed as parameters
///
/// There are three posible layouts:
/// 1. Fixed. Passed as parameter. Component stretches vertically to take required space. Scrolling may be enabled on page.
/// 2. Flexible. Passed as parameter. Component stretches vertically to occupy maximum space, but is constrainted in space given by container. Scrolling may be enabled inside component.
/// 3. Constrained. `.frame()` modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component.
///
/// # Usage Example #
///
/// ```
/// struct SectionRow: Identifiable {
///     let id: UUID = .init()
///     let title: String
/// }
///
/// @State var data: [SectionRow] = [
///     .init(title: "Red"),
///     .init(title: "Green"),
///     .init(title: "Blue")
/// ]
///
/// var body: some View {
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///         VSection(
///             title: "Lorem ipsum dolor sit amet",
///             data: data,
///             content: { row in
///                 Text(row.title)
///                     .frame(maxWidth: .infinity, alignment: .leading)
///             }
///         )
///             .padding()
///     })
/// }
/// ```
///
public struct VSection<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        Content: View
    {
    // MARK: Properties
    private let model: VSectionModel
    
    private let layoutType: VSectionLayoutType
    
    private let title: String?
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    // MARK: Initializers
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .default,
        title: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self.layoutType = layoutType
        self.title = title
        self.data = data
        self.id = id
        self.content = content
    }
    
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .default,
        title: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layoutType,
            title: title,
            data: data,
            id: \Data.Element.id,
            content: content
        )
    }
}

// MARK:- Body
extension VSection {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleMarginBottom, content: {
            if let title = title, !title.isEmpty {
                VText(
                    title: title,
                    color: model.colors.title,
                    font: model.fonts.title,
                    type: .oneLine
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, model.layout.titleMarginHor)
            }
            
            VSheet(model: model.sheetSubModel, content: {
                VBaseList(
                    model: model.baseListSubModel,
                    layout: layoutType,
                    data: data,
                    id: id,
                    content: content
                )
                    .padding([.leading, .top, .bottom], model.layout.contentMargin)
            })
        })
    }
}

// MARK:- Preview
struct VSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VSection(title: "Lorem ipsum dolor sit amet", data: VBaseList_Previews.rows, content: { row in
                VBaseList_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
