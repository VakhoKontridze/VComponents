//
//  VListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK: - V List Demo View
struct VListDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "List" }
    
    @State private var rowCount: Int = 5
    @State private var showsFirstSeparator: Bool = VListUIModel.Layout().showsFirstSeparator
    @State private var showsLastSeparator: Bool = VListUIModel.Layout().showsLastSeparator
    
    private var uiModel: VListUIModel {
        var uiModel: VListUIModel = .init()
        
        uiModel.layout.showsFirstSeparator = showsFirstSeparator
        uiModel.layout.showsLastSeparator = showsLastSeparator
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(paddedEdges: .vertical, component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VList(
            uiModel: uiModel,
            data: 0..<rowCount,
            id: \.self,
            content: {
                Text(String($0))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            StepperSettingView(range: 0...20, value: $rowCount, title: "Rows")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $showsFirstSeparator, title: "Shows First Separator")
            
            ToggleSettingView(isOn: $showsLastSeparator, title: "Shows Last Separator")
        })
    }

    private static func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
}

// MARK: - Preview
struct VListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VListDemoView()
    }
}
