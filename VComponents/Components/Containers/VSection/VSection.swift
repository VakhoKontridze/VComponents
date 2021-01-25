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
/// Component can be initialized with data or free content
///
/// Model, layout, and header can be passed as parameters
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
///             header: "Lorem ipsum dolor sit amet",
///             data: data,
///             rowContent: { row in
///                 Text(row.title)
///                     .frame(maxWidth: .infinity, alignment: .leading)
///             }
///         )
///             .padding()
///     })
/// }
/// ```
///
public struct VSection<Data, ID, RowContent, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        RowContent: View,
        Content: View
    {
    // MARK: Properties
    private let model: VSectionModel
    
    private let layoutType: VSectionLayoutType
    
    private let header: String?
    
    private let contentType: ContentType
    private enum ContentType {
        case list(data: Data, id: KeyPath<Data.Element, ID>, rowContent: (Data.Element) -> RowContent)
        case freeForm(content: () -> Content)
    }
    
    // MARK: Initializers: View Builder
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .default,
        header: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where Content == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.header = header
        self.contentType = .list(
            data: data,
            id: id,
            rowContent: rowContent
        )
    }
    
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .default,
        header: String? = nil,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Content == Never,
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.init(
            model: model,
            layout: layoutType,
            header: header,
            data: data,
            id: \Data.Element.id,
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Free Content
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .default,
        header: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            Data == Array<Never>,
            ID == Never,
            RowContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.header = header
        self.contentType = .freeForm(
            content: content
        )
    }
}

// MARK:- Body
extension VSection {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.headerSpacing, content: {
            headerView
            VSheet(model: model.sheetSubModel, content: { contentView })
        })
    }
    
    @ViewBuilder private var headerView: some View {
        if let header = header, !header.isEmpty {
            VText(
                type: .oneLine,
                font: model.fonts.title,
                color: model.colors.title,
                title: header
            )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, model.layout.titleMarginHor)
        }
    }
    
    @ViewBuilder private var contentView: some View {
        switch contentType {
        case .list(let data, let id, let rowContent):
            VBaseList(
                model: model.baseListSubModel,
                layout: layoutType,
                data: data,
                id: id,
                rowContent: rowContent
            )
                .padding([.leading, .top, .bottom], model.layout.contentMargin)
                .frame(maxWidth: .infinity)
        
        case .freeForm(let content):
            content()
                .padding(model.layout.contentMargin)
        }
    }
}

// MARK:- Preview
struct VSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VSection(header: "Lorem ipsum dolor sit amet", data: VBaseList_Previews.rows, rowContent: { row in
                VBaseList_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
