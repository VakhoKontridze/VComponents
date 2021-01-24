//
//  VSectionedList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table
/// Sectioned container component that draws a background, and computes views on demad from an underlying collection of identified data
///
/// Model, layout, and header, and footer can be passed as parameters
///
/// There are three posible layouts:
/// 1. Fixed. Passed as parameter. Component stretches vertically to take required space. Scrolling may be enabled on page.
/// 2. Flexible. Passed as parameter. Component stretches vertically to occupy maximum space, but is constrainted in space given by container. Scrolling may be enabled inside component.
/// 3. Constrained. `.frame()` modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component.
///
/// # Usage Example #
///
/// ```
/// struct TableSection: Identifiable, VTableSection {
///     let id: UUID = .init()
///     let title: String
///     let rows: [TableRow]
/// }
///
/// struct TableRow: VTableRow {
///     let id: UUID = .init()
///     let title: String
/// }
///
/// @State var sections: [TableSection] = [
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
///         VTable(
///             sections: sections,
///             header: { section in
///                 VTableDefaultHeaderFooter(title: section.title)
///             },
///             footer: { section in
///                 VTableDefaultHeaderFooter(title: section.title)
///             },
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
public struct VTable<Section, Row, HeaderContent, FooterContent, Content>: View
    where
        Section: VTableSection,
        Row == Section.VTableRow,
        HeaderContent: View,
        FooterContent: View,
        Content: View
{
    // MARK: Properties
    private let model: VTableModel
    
    private let layoutType: VTableLayoutType
    
    private let sections: [Section]
    
    private let headerContent: ((Section) -> HeaderContent)?
    private let footerContent: ((Section) -> FooterContent)?
    
    private let content: (Row) -> Content
    
    // MARK: Initializers
    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .default,
        sections: [Section],
        @ViewBuilder header headerContent: @escaping (Section) -> HeaderContent,
        @ViewBuilder footer footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder content: @escaping (Row) -> Content
    ) {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = headerContent
        self.footerContent = footerContent
        self.content = content
    }

    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .default,
        sections: [Section],
        @ViewBuilder header headerContent: @escaping (Section) -> HeaderContent,
        @ViewBuilder content: @escaping (Row) -> Content
    )
        where FooterContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = headerContent
        self.footerContent = nil
        self.content = content
    }

    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .default,
        sections: [Section],
        @ViewBuilder footer footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder content: @escaping (Row) -> Content
    )
        where HeaderContent == Never
    {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = nil
        self.footerContent = footerContent
        self.content = content
    }

    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .default,
        sections: [Section],
        @ViewBuilder content: @escaping (Row) -> Content
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
        self.content = content
    }
}

// MARK:- Body
extension VTable {
    public var body: some View {
        VSheet(model: model.sheetSubModel, content: {
            Group(content: {
                switch layoutType {
                case .fixed: VStack(spacing: 0, content: { contentView })
                case .flexible: VLazyList(content: { contentView })
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
            content: content
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
private extension VTable {
    func showSectionSpacing(for i: Int) -> Bool {
        i <= sections.count-2
    }
}

// MARK:- Preview
struct VTable_Previews: PreviewProvider {
    private struct Section: VTableSection {
        let id: Int
        let title: String
        let rows: [Row]
        
        static let count: Int = 2
    }

    private struct Row: VTableRow {
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

            VTable(
                sections: sections,
                header: { section in
                    VTableDefaultHeaderFooter(title: "Header \(section.title)")
                },
                footer: { section in
                    VTableDefaultHeaderFooter(title: "Footer \(section.title)")
                },
                content: { row in
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
