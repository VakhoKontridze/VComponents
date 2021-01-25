//
//  VCheckBoxDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V CheckBox Demo View
struct VCheckBoxDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "CheckBox"
    
    @State private var state: VCheckBoxState = .on
    @State private var contentType: ComponentContentType = .text
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VCheckBoxModel.Layout().hitBox)
    @State private var contentIsClickable: Bool = VCheckBoxModel.Misc().contentIsClickable
    @State private var loweredOpacityWhenPressed: Bool = VCheckBoxModel.Colors().content.pressedOpacity != 1
    @State private var loweredOpacityWhenDisabled: Bool = VCheckBoxModel.Colors().content.disabledOpacity != 1
    
    private var model: VCheckBoxModel {
        let defaultModel: VCheckBoxModel = .init()
        
        var model: VCheckBoxModel = .init()
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBox = 0
            model.layout.contentMarginLeading = defaultModel.layout.hitBox.isZero ? 5 : defaultModel.layout.hitBox
            
        case .extended:
            model.layout.hitBox = defaultModel.layout.hitBox.isZero ? 5 : defaultModel.layout.hitBox
        }
        
        model.colors.content.pressedOpacity = loweredOpacityWhenPressed ? 0.5 : 1
        
        model.colors.content.disabledOpacity = loweredOpacityWhenDisabled ? 0.5 : 1
        
        model.misc.contentIsClickable = contentIsClickable

        return model
    }
}

// MARK:- Body
extension VCheckBoxDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VCheckBox(model: model, state: $state, title: CheckBoxTitle)
        case .custom: VCheckBox(model: model, state: $state, content: CheckBoxContent)
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
            VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $contentIsClickable, title: "Clickable Content")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $loweredOpacityWhenPressed, title: "Low Pressed Opacity", description: "Content lowers opacity when pressed")
            
            ToggleSettingView(isOn: $loweredOpacityWhenDisabled, title: "Low Disabled Opacity", description: "Content lowers opacity when disabled")
        })
    }
    
    private var CheckBoxTitle: String { "Lorem ipsum" }
    
    private func CheckBoxContent() -> some View { DemoIconContentView() }
}

// MARK:- Helpers
extension VCheckBoxState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .off: return "Off"
        case .on: return "On"
        case .intermediate: return "Interm."
        case .disabled: return "Disabled"
        }
    }
}

// MARK: Preview
struct VCheckBoxDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCheckBoxDemoView()
    }
}
