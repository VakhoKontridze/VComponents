//
//  VSectionList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section List
/// Sectioned container component that draws a background, and computes views on demad from an underlying collection of identified data
///
/// Model, layout, and header, and footer can be passed as parameters
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
/// Unlike `VBaseList`, `VSectionList` has spacing between rows and scrolling indicaator
///
/// # Usage Example #
///
/// ```
/// struct Section: Identifiable, VSectionListSectionViewModelable {
///     let id: UUID = .init()
///     let title: String
///     let rows: [TableRow]
/// }
///
/// struct Row: VSectionListRowViewModelable {
///     let id: UUID = .init()
///     let title: String
/// }
///
/// @State var sections: [Section] = [
///     .init(title: "First", rows: [
///         .init(title: "Red"),
///         .init(title: "Green"),
///         .init(title: "Blue")
///     ]),
///     .init(title: "Second", rows: [
///         .init(title: "Red"),
///         .init(title: "Green"),
///         .init(title: "Blue")
///     ])
/// ]
///
/// var body: some View {
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///         VSectionList(
///             sections: sections,
///             headerTitle: { $0.title },
///             footerTitle: { $0.title },
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
public struct VSectionList<Section, Row, HeaderContent, FooterContent, RowContent>: View
    where
        Section: VSectionListSectionViewModelable,
        Row == Section.VSectionListRowViewModelable,
        HeaderContent: View,
        FooterContent: View,
        RowContent: View
{
    // MARK: Properties
    private let model: VSectionListModel
    
    private let layoutType: VSectionListLayoutType
    
    private let sections: [Section]
    
    private let headerContent: ((Section) -> HeaderContent)?
    private let footerContent: ((Section) -> FooterContent)?
    
    private let rowContent: (Row) -> RowContent
    
    // MARK: Initializers: Header and Footer
    /// Initializes component with sections, header, footer, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerContent: @escaping (Section) -> HeaderContent,
        footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    ) {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = headerContent
        self.footerContent = footerContent
        self.rowContent = rowContent
    }
    
    /// Initializes component with sections, header title, footer, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerTitle: @escaping (Section) -> String,
        footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where HeaderContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            layout: layoutType,
            sections: sections,
            headerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle(section)
                )
            },
            footerContent: footerContent,
            rowContent: rowContent
        )
    }
    
    /// Initializes component with sections, header, footer title, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerContent: @escaping (Section) -> HeaderContent,
        footerTitle: @escaping (Section) -> String,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where FooterContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            layout: layoutType,
            sections: sections,
            headerContent: headerContent,
            footerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: footerTitle(section)
                )
            },
            rowContent: rowContent
        )
    }
    
    /// Initializes component with sections, header title, footer title, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerTitle: @escaping (Section) -> String,
        footerTitle: @escaping (Section) -> String,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where
            HeaderContent == VBaseHeaderFooter,
            FooterContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            layout: layoutType,
            sections: sections,
            headerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle(section)
                )
            },
            footerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: footerTitle(section)
                )
            },
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Header
    /// Initializes component with sections, header, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerContent: @escaping (Section) -> HeaderContent,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where FooterContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = headerContent
        self.footerContent = nil
        self.rowContent = rowContent
    }
    
    /// Initializes component with sections, header title, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        headerTitle: @escaping (Section) -> String,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where
            HeaderContent == VBaseHeaderFooter,
            FooterContent == Never
    {
        self.init(
            model: model,
            layout: layoutType,
            sections: sections,
            headerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: headerTitle(section)
                )
            },
            rowContent: rowContent
        )
    }

    // MARK: Initializers: Footer
    /// Initializes component with sections, footer, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where HeaderContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = nil
        self.footerContent = footerContent
        self.rowContent = rowContent
    }
    
    /// Initializes component with sections, footer title, and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        footerTitle: @escaping (Section) -> String,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where
            HeaderContent == Never,
            FooterContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            layout: layoutType,
            sections: sections,
            footerContent: { section in
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerText,
                    title: footerTitle(section)
                )
            },
            rowContent: rowContent
        )
    }

    // MARK: Initializers: _
    /// Initializes component with sections and row content
    public init(
        model: VSectionListModel = .init(),
        layout layoutType: VSectionListLayoutType = .default,
        sections: [Section],
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    )
        where
            HeaderContent == Never,
            FooterContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = nil
        self.footerContent = nil
        self.rowContent = rowContent
    }
}

// MARK:- Body
extension VSectionList {
    public var body: some View {
        VSheet(model: model.sheetSubModel, content: {
            Group(content: {
                switch layoutType {
                case .fixed: VStack(spacing: 0, content: { contentView })
                case .flexible: VLazyScrollView(content: { contentView })
                }
            })
                .padding([.leading, .top, .bottom], model.layout.contentMargin)
                .frame(maxWidth: .infinity)
        })
    }
    
    private var contentView: some View {
        ForEach(sections.enumeratedArray(), id: \.element.id, content: { (i, section) in
            headerView(i: i, section: section)
            rowViews(section: section)
            footerView(i: i, section: section)
            padding(i: i)
        })
            .padding(.trailing, model.layout.contentMargin)
    }

    private func headerView(i: Int, section: Section) -> some View {
        headerContent?(section)
            .padding(.bottom, model.layout.headerMarginBottom)
    }

    private func rowViews(section: Section) -> some View {
        VBaseList(
            model: model.baseListSubModel,
            layout: .fixed,
            data: section.rows,
            rowContent: rowContent
        )
    }

    private func footerView(i: Int, section: Section) -> some View {
        footerContent?(section)
            .padding(.top, model.layout.footerMarginTop)
    }

    @ViewBuilder private func padding(i: Int) -> some View {
        if showSectionSpacing(for: i) {
            Spacer()
                .frame(height: model.layout.sectionSpacing)
        }
    }
}

// MARK:- Helpers
extension VSectionList {
    private func showSectionSpacing(for i: Int) -> Bool {
        i <= sections.count-2
    }
}

// MARK:- Preview
struct VSectionList_Previews: PreviewProvider {
    private struct Section: VSectionListSectionViewModelable {
        let id: Int
        let title: String
        let rows: [Row]
        
        static let count: Int = 2
    }

    private struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String
        
        static let count: Int = 3
    }

    private static let sections: [Section] = (0..<Section.count).map { i in
        .init(
            id: i,
            
            title: spellOut(i + 1),
            
            rows: (0..<Row.count).map { ii in
                let num: Int = i * Row.count + ii + 1
                return .init(
                    id: num,
                    color: [.red, .green, .blue][ii],
                    title: spellOut(num)
                )
            }
        )
    }
    
    private static func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }

    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)

            VSectionList(
                sections: sections,
                headerTitle: { $0.title },
                footerTitle: { $0.title },
                rowContent: { row in
                    VBaseList_Previews.rowContent(
                        title: row.title,
                        color: row.color
                    )
                }
            )
                .padding(20)
        })
    }
}
