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
    
    @State private var form: VBaseListDemoView.Form = .default
    
    @State private var accordionState: VAccordionState = .expanded
    
    @State private var expandCollapseOnHeaderTap: Bool = true
    
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

            VText(
                title: title,
                color: ColorBook.primary,
                font: .body,
                type: .oneLine
            )
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var accordionModel: VAccordionModel {
        var model: VAccordionModel = .init()
        model.expandCollapseOnHeaderTap = expandCollapseOnHeaderTap
        return model
    }
}

// MARK:- Body
extension VAccordionDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: form.demoViewType, controller: controller, content: {
                VAccordion(
                    model: accordionModel,
                    layout: form.accordionlayoutType,
                    state: $accordionState,
                    header: { VAccordionDefaultHeader(title: "Lorem ipsum dolor sit amet") },
                    data: rows,
                    content: { rowContent(title: $0.title, color: $0.color) }
                )
                    .frame(height: form.height, alignment: .top)
            })
        })
    }
    
    private var controller: some View {
        VStack(spacing: 20, content: {
            ControllerToggleView(
                state: .init(
                    get: { accordionState == .disabled },
                    set: { state in withAnimation { accordionState = state ? .disabled : .collapsed } }
                ),
                title: "Disabled"
            )
            
            Stepper("Rows", value: $rowCount, in: 0...20)

            VSegmentedPicker(
                selection: $form,
                title: "Accordion Height",
                description: form.description
            )
                .frame(height: 90, alignment: .top)

            ToggleSettingView(isOn: $expandCollapseOnHeaderTap, title: "Expand/Collapse on Header Tap")
        })
    }
}

// MARK:- Helpers
private extension VBaseListDemoView.Form {
    var accordionlayoutType: VAccordionLayoutType {
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
