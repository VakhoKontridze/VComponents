//
//  VSectionedList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Section
public protocol VTableSection: Identifiable {
    associatedtype VTableRow: VComponents.VTableRow
    var rows: [VTableRow] { get }
}

// MARK:- V Table Row
public protocol VTableRow: Identifiable {}

// MARK:- V Table
public struct VTable<Section, Row, HeaderContent, FooterContent, RowContent>: View
    where
        Section: VTableSection,
        Row == Section.VTableRow,
        HeaderContent: View,
        FooterContent: View,
        RowContent: View
{
    // MARK: Properties
    private let model: VTableModel
    
    private let layoutType: VTableLayoutType
    
    private let sections: [Section]
    
    private let headerContent: ((Section) -> HeaderContent)?
    private let footerContent: ((Section) -> FooterContent)?
    
    private let rowContent: (Row) -> RowContent
    
    // MARK: Initializers
    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .fixed,
        sections: [Section],
        @ViewBuilder headerContent: @escaping (Section) -> HeaderContent,
        @ViewBuilder footerContent: @escaping (Section) -> FooterContent,
        @ViewBuilder rowContent: @escaping (Row) -> RowContent
    ) {
        self.model = model
        self.layoutType = layoutType
        self.sections = sections
        self.headerContent = headerContent
        self.footerContent = footerContent
        self.rowContent = rowContent
    }
    
    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .fixed,
        sections: [Section],
        @ViewBuilder headerContent: @escaping (Section) -> HeaderContent,
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
    
    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .fixed,
        sections: [Section],
        @ViewBuilder footerContent: @escaping (Section) -> FooterContent,
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
    
    public init(
        model: VTableModel = .init(),
        layout layoutType: VTableLayoutType = .fixed,
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

// MARK:- View
extension VTable {
    public var body: some View {
        VSheet(model: model.sheetModel, content: {
            Group(content: {
                switch layoutType {
                case .fixed: VStack(spacing: 0, content: { contentView })
                case .flexible: VLazyList(content: { contentView })
                }
            })
                .if(!sections.isEmpty, transform: {
                    $0.padding([.leading, .top, .bottom], model.layout.contentMargin)
                })
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
            model: model.genericListContentModel,
            layout: .fixed,
            data: section.rows,
            content: rowContent
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
        
        static let count: Int = 5
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
                layout: .fixed,
                sections: sections,
                headerContent: { section in
                    VTableDefaultHeaderFooter(title: "Header \(section.title)")
                },
                footerContent: { section in
                    VTableDefaultHeaderFooter(title: "Footer \(section.title)")
                },
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
