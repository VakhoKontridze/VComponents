//
//  VDisclosureGroupDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Disclosure Group Demo View
struct VDisclosureGroupDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Disclosure Group" }
    
    @State private var isEnabled: Bool = true
    @State private var isExpanded: Bool = true
    @State private var expandCollapseOnHeaderTap: Bool = true
    @State private var hasDivider: Bool = VDisclosureGroupUIModel.Layout().dividerHeight > 0
    
    private var uiModel: VDisclosureGroupUIModel {
        var uiModel: VDisclosureGroupUIModel = .init()
        
        uiModel.layout.dividerHeight = hasDivider ? (uiModel.layout.dividerHeight == 0 ? 1 : uiModel.layout.dividerHeight) : 0
        uiModel.colors.divider = hasDivider ? (uiModel.colors.divider == .clear ? .gray : uiModel.colors.divider) : .clear
        
        uiModel.misc.expandsAndCollapsesOnHeaderTap = expandCollapseOnHeaderTap
        
        return uiModel
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
            ColorBook.canvas.ignoresSafeArea()

            VDisclosureGroup(
                uiModel: uiModel,
                isExpanded: $isExpanded,
                headerTitle: "Lorem Ipsum",
                content: {
                    LazyVStack(spacing: 0, content: {
                        ForEach(0..<10, content: { num in
                            VListRow(separator: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                                Text(String(num))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            })
                        })
                    })
                }
            )
                .disabled(!isEnabled)
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VDisclosureGroupInternalState(isEnabled: isEnabled, isExpanded: isExpanded) },
                set: { state in
                    isEnabled = state != .disabled
                    isExpanded = state == .expanded
                }
            ),
            headerTitle: "State"
        )
        
        ToggleSettingView(isOn: $expandCollapseOnHeaderTap, title: "Expand/Collapse on Header Tap")
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
}

// MARK: - Helpers
private enum VDisclosureGroupInternalState: StringRepresentableHashableEnumeration {
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
    
    var stringRepresentation: String {
        switch self {
        case .collapsed: return "Collapsed"
        case .expanded: return "Expanded"
        case .disabled: return "Disabled"
        }
    }
}

// MARK: - Preview
struct VDisclosureGroupDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VDisclosureGroupDemoView()
    }
}
