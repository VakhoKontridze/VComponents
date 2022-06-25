//
//  VStaticStaticListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 24.06.22.
//

import SwiftUI
import VComponents

// MARK: - V Static List Demo View
struct VStaticListDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Static List" }
    
    @State private var rowCount: Int = 5
    @State private var showsFirstSeparator: Bool = VStaticListUIModel.Layout().showsFirstSeparator
    @State private var showsLastSeparator: Bool = VStaticListUIModel.Layout().showsLastSeparator
    
    private var uiModel: VStaticListUIModel {
        var uiModel: VStaticListUIModel = .init()
        
        uiModel.layout.showsFirstSeparator = showsFirstSeparator
        uiModel.layout.showsLastSeparator = showsLastSeparator
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VStaticList(
            uiModel: uiModel,
            data: 0..<rowCount,
            id: \.self,
            content: {
                Text(String($0))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
            .frame(maxHeight: UIScreen.main.bounds.height - 200)
            .clipped()
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
struct VStaticListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VStaticListDemoView()
    }
}
