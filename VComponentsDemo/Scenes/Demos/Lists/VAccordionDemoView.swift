//
//  VAccordionDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VComponents

// MARK: - V Accordion Demo View
struct VAccordionDemoView: View {
    // MARK: Properties
    static let navBarTitle: String { "Accordion" }
    
    @State private var accordionState: VAccordionState = .expanded
    @State private var layoutType: BaseListLayoutTypeHelper = .default
    @State private var rowCount: Int = 5
    @State private var expandCollapseOnHeaderTap: Bool = true
    @State private var hasDivider: Bool = VAccordionModel.Layout().headerDividerHeight > 0
    
    private var model: VAccordionModel {
        var model: VAccordionModel = .init()
        
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1 : model.layout.headerDividerHeight) : 0
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear
        
        model.misc.expandCollapseOnHeaderTap = expandCollapseOnHeaderTap
        
        return model
    }

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(
                type: layoutType.demoViewComponentContentType,
                hasLayer: false,
                component: component,
                settings: settings
            )
        })
    }
    
    private func component() -> some View {
            VAccordion(
                model: model,
                layout: layoutType.accordionlayoutType,
                state: $accordionState,
                headerTitle: "Lorem ipsum dolor sit amet",
                data: VBaseListDemoViewDataSource.rows(count: rowCount),
                rowContent: { VBaseListDemoViewDataSource.rowContent(title: $0.title, color: $0.color) }
            )
                .ifLet(
                    layoutType.height,
                    ifTransform: { (view, height) in
                        Group(content: {
                            view
                                .frame(height: height, alignment: .top)
                        })
                            .frame(maxHeight: .infinity, alignment: .top)
                    },
                    elseTransform: { view in
                        view
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                )
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $accordionState, headerTitle: "State")
        
        VSegmentedPicker(selection: $layoutType, headerTitle: "Layout", footerTitle: layoutType.description)
            .frame(height: 110, alignment: .top)
        
        StepperSettingView(range: 0...20, value: $rowCount, title: "Rows")
        
        ToggleSettingView(isOn: $expandCollapseOnHeaderTap, title: "Expand/Collapse on Header Tap")
        
        ToggleSettingView(isOn: $hasDivider, title: "Header Divider")
    }
}

// MARK: - Helpers
extension VAccordionState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .collapsed: return "Collapsed"
        case .expanded: return "Expanded"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

extension BaseListLayoutTypeHelper {
    fileprivate var accordionlayoutType: VAccordionLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// MARK: - Preview
struct VAccordionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAccordionDemoView()
    }
}
