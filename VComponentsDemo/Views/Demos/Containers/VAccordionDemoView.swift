//
//  VAccordionDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VComponents

// MARK:- V Accordion Demo View
struct VAccordionDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Accordion"
    
    @State private var rowCount: Int = 5
    
    @State private var form: VSectionDemoView.Form = .fixed
    
    @State private var accordionState: VAccordionState = .expanded
    
    // Copied from VSectionDemoView
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

            Text(title)
                .font(.body)
                .foregroundColor(ColorBook.primary)
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Body
extension VAccordionDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: form.demoViewType, controller: controller, content: {
                VAccordion(
                    layout: form.accordionLayout,
                    state: $accordionState,
                    headerContent: { VAccordionDefaultHeader(title: "Lorem ipsum dolor sit amet") },
                    data: rows,
                    rowContent: { rowContent(title: $0.title, color: $0.color) }
                )
                    .frame(height: form.height, alignment: .top)
            })
        })
    }
    
    private var controller: some View {
        VStack(spacing: 20, content: {
            Stepper("Rows", value: $rowCount, in: 0...20)

            VSegmentedPicker(
                selection: $form,
                title: "Accordion Height",
                subtitle: form.subtitle
            )
                .frame(height: 90, alignment: .top)
        })
    }
}

// MARK:- Helpers
private extension VSectionDemoView.Form {
    var accordionLayout: VAccordionLayout {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// MARK:- Preview
struct VAccordionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAccordionDemoView()
    }
}
