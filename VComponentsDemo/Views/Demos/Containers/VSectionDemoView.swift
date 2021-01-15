//
//  VSectionDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VComponents

// MARK:- V Section Demo View
struct VSectionDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Section"
    
    @State private var rowCount: Int = 5
    
    @State private var form: VBaseListDemoView.Form = .default
    
    // Copied and modifier from VSection's preview
    private struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String
    }
    
    private var rows: [Row] {
        (0..<rowCount).map { i in
            .init(
                id: i,
                color: [.red, .green, .blue][i % 3],
                title: spellOut(i + 1)
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

            VBaseTitle(
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
extension VSectionDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: form.demoViewType, controller: controller, content: {
                VSection(
                    layout: form.sectionlayoutType,
                    title: "Lorem ipsum dolor sit amet",
                    data: rows,
                    content: { rowContent(title: $0.title, color: $0.color) }
                )
                    .frame(height: form.height)
            })
        })
    }
    
    private var controller: some View {
        VStack(spacing: 20, content: {
            Stepper("Rows", value: $rowCount, in: 0...20)
            
            VSegmentedPicker(
                selection: $form,
                title: "Section Height",
                subtitle: form.subtitle
            )
                .frame(height: 90, alignment: .top)
        })
    }
}

// MARK:- Helpers
private extension VBaseListDemoView.Form {
    var sectionlayoutType: VSectionLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// MARK:- Preview
struct VSectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSectionDemoView()
    }
}
