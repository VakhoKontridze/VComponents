//
//  VSectionedList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table
/// Sectioned container component that draws a background, and computes views on demad from an underlying collection of identified data
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
    /// Initializes component with sections, header, footer, and row content
    ///
    /// # Usage Example #
    /// Short initialization
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             sections: sections,
    ///             headerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             footerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    /// Full initialization
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
    /// let model: VTableModel = .init()
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             model: model,
    ///             layout: .fixed,
    ///             sections: sections,
    ///             headerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             footerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    ///   - sections: Identified data used to create views dynamically
    ///   - headerContent: View that describes container
    ///   - footerContent: View that describes container
    ///   - rowContent: View builder that creates views dynamically
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
    
    /// Initializes component with sections, header, and row content
    ///
    /// # Usage Example #
    /// Short initialization
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             sections: sections,
    ///             headerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    /// Full initialization
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
    /// let model: VTableModel = .init()
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             model: model,
    ///             layout: .fixed,
    ///             sections: sections,
    ///             headerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    ///   - sections: Identified data used to create views dynamically
    ///   - headerContent: View that describes container
    ///   - rowContent: View builder that creates views dynamically
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
    
    /// Initializes component with sections, footer, and row content
    ///
    /// # Usage Example #
    /// Short initialization
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             sections: sections,
    ///             footerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    /// Full initialization
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
    /// let model: VTableModel = .init()
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             model: model,
    ///             layout: .fixed,
    ///             sections: sections,
    ///             footerContent: { section in
    ///                 VTableDefaultHeaderFooter(title: section.title)
    ///             },
    ///             rowContent: { row in
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
    ///   - sections: Identified data used to create views dynamically
    ///   - footerContent: View that describes container
    ///   - rowContent: View builder that creates views dynamically
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
    
    /// Initializes component with sections and row content
    ///
    /// # Usage Example #
    /// Short initialization
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
    ///         ColorBook.canvas
    ///
    ///         VTable(sections: sections, rowContent: { row in
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
    /// let model: VTableModel = .init()
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
    ///         ColorBook.canvas
    ///
    ///         VTable(
    ///             model: model,
    ///             layout: .fixed,
    ///             sections: sections,
    ///             rowContent: { row in
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
    ///   - sections: Identified data used to create views dynamically
    ///   - rowContent: View builder that creates views dynamically
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
