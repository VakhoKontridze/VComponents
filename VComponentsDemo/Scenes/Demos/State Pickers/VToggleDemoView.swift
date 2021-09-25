//
//  VToggleDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Toggle Demo View
struct VToggleDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Toggle"
    
    @State private var state: VToggleState = .on
    @State private var contentType: ComponentContentType = .text
    @State private var contentIsClickable: Bool = VToggleModel.Misc().contentIsClickable
    @State private var loweredOpacityWhenPressed: Bool = VToggleModel.Colors().content.pressedOpacity != 1
    @State private var loweredOpacityWhenDisabled: Bool = VToggleModel.Colors().content.disabledOpacity != 1
    
    private var model: VToggleModel {
        var model: VToggleModel = .init()
        
        model.colors.content.pressedOpacity = loweredOpacityWhenPressed ? 0.5 : 1
        model.colors.content.disabledOpacity = loweredOpacityWhenDisabled ? 0.5 : 1
        
        model.misc.contentIsClickable = contentIsClickable
        
        return model
    }
}

// MARK: - Body
extension VToggleDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VToggle(model: model, state: $state, title: toggleTitle)
        case .custom: VToggle(model: model, state: $state, content: toggleContent)
        }
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $state, headerTitle: "State")
        })
        
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $contentIsClickable, title: "Clickable Content")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $loweredOpacityWhenPressed, title: "Low Pressed Opacity", description: "Content lowers opacity when pressed")
            
            ToggleSettingView(isOn: $loweredOpacityWhenDisabled, title: "Low Disabled Opacity", description: "Content lowers opacity when disabled")
        })
    }
    
    private var toggleTitle: String { "Lorem ipsum" }
    
    private func toggleContent() -> some View { DemoIconContentView() }
}

// MARK: - Helpers
extension VToggleState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .off: return "Off"
        case .on: return "On"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

// MARK: Preview
struct VToggleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleDemoView()
    }
}
