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
    static var navBarTitle: String { "Accordion" }
    
    @State private var isEnabled: Bool = true
    @State private var isExpanded: Bool = true
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
        DemoView(
            hasLayer: false,
            component: component,
            settings: settings
        )
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)

            VAccordion(
                model: model,
                isExpanded: $isExpanded,
                headerTitle: "Lorem Ipsum",
                content: {
                    VList(
                        layout: .fixed,
                        data: 1..<10,
                        rowContent: { num in
                            Text(String(num))
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                }
            )
                .disabled(!isEnabled)
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { _VAccordionState(isEnabled: isEnabled, isExpanded: isExpanded) },
                set: { state in
                    isEnabled = state != .disabled
                    isExpanded = state == .expanded
                }
            ),
            headerTitle: "State"
        )
        
        ToggleSettingView(isOn: $expandCollapseOnHeaderTap, title: "Expand/Collapse on Header Tap")
        
        ToggleSettingView(isOn: $hasDivider, title: "Header Divider")
    }
}

// MARK: - Helpers
private enum _VAccordionState: PickableTitledEnumeration {
    case collapsed
    case expanded
    case disabled
    
    init(isEnabled: Bool, isExpanded: Bool) {
        switch (isEnabled, isExpanded) {
        case (false, _): self = .disabled
        case (true, false): self = .collapsed
        case (true, true): self = .expanded
        }
    }
    
    var pickerTitle: String {
        switch self {
        case .collapsed: return "Collapsed"
        case .expanded: return "Expanded"
        case .disabled: return "Disabled"
        }
    }
}

// MARK: - Preview
struct VAccordionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAccordionDemoView()
    }
}
