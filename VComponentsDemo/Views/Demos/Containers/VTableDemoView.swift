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
    
    @State private var form: Form = .free
    enum Form: Int, VPickerTitledEnumerableOption {
        case free
        case constrained
        
        var pickerTitle: String {
            switch self {
            case .free: return "Free"
            case .constrained: return "Constrained"
            }
        }
        
        var subtitle: String {
            switch self {
            case .free: return "Content would stretch vertically to occupy maximum space"
            case .constrained: return "Content would be limited in vertical space. Content can be scrolled using internal scrller."
            }
        }
        
        var height: CGFloat? {
            switch self {
            case .free: return nil
            case .constrained: return 500
            }
        }
    }
    
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
            DemoView(type: .freeform, controller: controller, content: {
                VTable(
                    sections: sections,
                    headerContent: { section in VTableDefaultHeaderFooter(title: "Header \(section.title)") },
                    footerContent: { section in VTableDefaultHeaderFooter(title: "Footer \(section.title)") },
                    rowContent: { row in rowContent(title: row.title, color: row.color) }
                )
                    .frame(height: form.height)
            })
        })
    }
    
    private var controller: some View {
        VSegmentedPicker(
            selection: $form,
            title: "Table Height",
            subtitle: form.subtitle
        )
            .frame(height: 90, alignment: .top)
    }
}

// MARK:- Preview
struct VTableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTableDemoView()
    }
}
