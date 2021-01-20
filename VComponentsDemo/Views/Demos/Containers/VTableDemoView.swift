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
    
    @State private var sectionCount: Int = 2
    @State private var rowCount: Int = 3
    
    @State private var form: VBaseListDemoView.Form = .default
    
    
    // Copied and modified from VTable's preview
    private struct Section: VTableSection {
        let id: Int
        let title: String
        let rows: [Row]
    }

    private struct Row: VTableRow {
        let id: Int
        let color: Color
        let title: String
    }

    private var sections: [Section] {
        (0..<sectionCount).map { i in
            .init(
                id: i,
                
                title: spellOut(i + 1),
                
                rows: (0..<rowCount).map { ii in
                    let num: Int = i * rowCount + ii + 1
                    return .init(
                        id: num,
                        color: [.red, .green, .blue][ii % 3],
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

            VText(
                title: title,
                color: ColorBook.primary,
                font: .body,
                type: .oneLine
            )
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Body
extension VTableDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: form.demoViewType, controller: controller, content: {
                VTable(
                    layout: form.tablelayoutType,
                    sections: sections,
                    header: { section in VTableDefaultHeaderFooter(title: "Header \(section.title)") },
                    footer: { section in VTableDefaultHeaderFooter(title: "Footer \(section.title)") },
                    content: { row in rowContent(title: row.title, color: row.color) }
                )
                    .frame(height: form.height)
            })
        })
    }
    
    private var controller: some View {
        VStack(spacing: 20, content: {
            Stepper("Sections", value: $sectionCount, in: 0...10)
            
            Stepper("Rows", value: $rowCount, in: 0...10)
            
            VSegmentedPicker(
                selection: $form,
                title: "Table Height",
                description: form.description
            )
                .frame(height: 90, alignment: .top)
        })
    }
}

// MARK:- Helpers
private extension VBaseListDemoView.Form {
    var tablelayoutType: VTableLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// MARK:- Preview
struct VTableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTableDemoView()
    }
}
