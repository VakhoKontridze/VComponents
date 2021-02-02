//
//  VDropDownDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI
import VComponents

// MARK:- V Drop Down Demo View
struct VDropDownDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Drop Down"
    
    @State private var selection: ComponentRGBItem = .red
    @State private var state: VWheelPickerState = .enabled
    @State private var dropDownButtonType: VNavigationLinkButtonTypeHelper = .primary
    @State private var contentType: ComponentContentType = .text
}

// MARK:- Body
extension VDropDownDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch (dropDownButtonType.preset, contentType) {
        case (let preset?, .text):
            VDropDown(
                preset: preset,
                selection: $selection,
                state: state,
                title: buttonTitle
            )
        
        case (let preset?, .custom):
            VDropDown(
                preset: preset,
                selection: $selection,
                state: state,
                label: buttonContent
            )
            
        case (nil, _):
            VDropDown(
                selection: $selection,
                state: state,
                label: buttonContent
            )
        }
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $state, headerTitle: "State")
        })
        
        DemoViewSettingsSection(content: {
            VWheelPicker(
                selection: $dropDownButtonType,
                headerTitle: "Type"
            )
                .onChange(of: dropDownButtonType, perform: { type in
                    if type == .custom { contentType = .custom }
                })
            
            VSegmentedPicker(
                selection: $contentType,
                headerTitle: "Label Content",
                disabledItems: dropDownButtonType == .custom ? [.text] : []
            )
        })
    }
    
    private var buttonTitle: String {
        switch dropDownButtonType.preset {
        case .square: return "Lorem"
        default: return "Lorem ipsum"
        }
    }

    private func buttonContent() -> some View { DemoIconContentView() }
}

// MARK:- Preview
struct VDropDownDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VDropDownDemoView()
    }
}
