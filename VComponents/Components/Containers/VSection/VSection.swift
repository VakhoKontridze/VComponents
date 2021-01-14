//
//  VSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section
/// Container component that draws a background, and computes views on demad from an underlying collection of identified data
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
    /// Initializes component with data, id, and row content
    /// 
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var data: [String] = ["Red", "Green", "Blue"]
    ///
    /// var body: some View {
    ///     ZStack(alignment: .top, content: {
    ///         ColorBook.canvas
    ///
    ///         VSection(data: data, id: \.self, content: { title in
    ///             Text(title)
    ///                 .frame(maxWidth: .infinity, alignment: .leading)
    ///         })
    ///             .padding()
    ///     })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VSectionModel = .init()
    /// @State var data: [String] = ["Red", "Green", "Blue"]
    ///
    /// var body: some View {
    ///     ZStack(alignment: .top, content: {
    ///         ColorBook.canvas
    ///
    ///         VSection(
    ///             model: model,
    ///             layout: .fixed,
    ///             title: "Lorem ipsum dolor sit amet",
    ///             data: data,
    ///             id: \.self,
    ///             content: { title in
    ///                 Text(title)
    ///                     .frame(
    ///                         maxWidth: .infinity,
    ///                         alignment: . leading
    ///                     )
    ///             }
    ///         )
    ///             .padding()
    ///     })
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - layoutType: Enum that describes layout type, such as fixed or flexible
    ///   - title: Title that describes container
    ///   - data: Data used to create views dynamically
    ///   - id: Key path to the provided data's identifier
    ///   - content: View builder that creates views dynamically
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .fixed,
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

    // MARK: Initializers
    /// Initializes component with data and row content
    ///
    /// # Usage Example #
    /// Short initialization
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
    ///         ColorBook.canvas
    ///
    ///         VSection(data: data, content: { row in
    ///             Text(row.title)
    ///                 .frame(maxWidth: .infinity, alignment: .leading)
    ///         })
    ///             .padding()
    ///     })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// struct SectionRow: Identifiable {
    ///     let id: UUID = .init()
    ///     let title: String
    /// }
    ///
    /// let model: VSectionModel = .init()
    /// @State var data: [SectionRow] = [
    ///     .init(title: "Red"),
    ///     .init(title: "Green"),
    ///     .init(title: "Blue")
    /// ]
    ///
    /// var body: some View {
    ///     ZStack(alignment: .top, content: {
    ///         ColorBook.canvas
    ///
    ///         VSection(
    ///             model: model,
    ///             layout: .fixed,
    ///             title: "Lorem ipsum dolor sit amet",
    ///             data: data,
    ///             content: { row in
    ///                 Text(row.title)
    ///                     .frame(
    ///                         maxWidth: .infinity,
    ///                         alignment: .leading
    ///                     )
    ///             }
    ///         )
    ///             .padding()
    ///     })
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - layoutType: Enum that describes layout type, such as fixed or flexible
    ///   - title: Title that describes container
    ///   - data: Identified data used to create views dynamically
    ///   - content: View builder that creates views dynamically
    public init(
        model: VSectionModel = .init(),
        layout layoutType: VSectionLayoutType = .fixed,
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
                VBaseTitle(
                    title: title,
                    color: model.colors.title,
                    font: model.titleFont,
                    type: .oneLine
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, model.layout.titleMarginHor)
            }
            
            VSheet(model: model.sheetModel, content: {
                VBaseList(
                    model: model.genericListContentModel,
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
            
            VSection(layout: .fixed, title: "TITLE", data: VBaseList_Previews.rows, content: { row in
                VBaseList_Previews.rowContent(title: row.title, color: row.color)
            })
                .padding(20)
        })
    }
}
