//
//  VTableDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VComponents

// MARK:- V Table Demo View
struct VTableDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Table"
    
    // Copied from VTable's preview
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

    private var sections: [Section] {
        (0..<Section.count).map { i in
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
    }
    
    private func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
    
    private func rowContent(title: String, color: Color) -> some View {
        HStack(spacing: 10, content: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(color.opacity(0.8))
                .frame(dimension: 32)

            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
                .foregroundColor(ColorBook.primary)
        })
    }
}

// MARK:- Body
extension VTableDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)
                
                VTable(
                    sections: sections,
                    headerContent: { section in
                        VTableDefaultHeaderFooter(title: "Header \(section.title)")
                    },
                    footerContent: { section in
                        VTableDefaultHeaderFooter(title: "Footer \(section.title)")
                    },
                    rowContent: { row in
                        rowContent(title: row.title, color: row.color)
                    }
                )
                    .padding(20)
            })
        })
    }
}

// MARK:- Preview
struct VTableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTableDemoView()
    }
}
