//
//  VRadioButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V RadioButton Demo View
struct VRadioButtonDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Radio Button"
    
    @State private var state: VRadioButtonState = .on
    @State private var contentType: ComponentContentType = .text
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VRadioButtonModel.Layout().hitBox)
    @State private var contentIsClickable: Bool = VRadioButtonModel.Misc().contentIsClickable
    @State private var loweredOpacityWhenPressed: Bool = VRadioButtonModel.Colors().content.pressedOpacity != 1
    @State private var loweredOpacityWhenDisabled: Bool = VRadioButtonModel.Colors().content.disabledOpacity != 1
    
    private var model: VRadioButtonModel {
        let defaultModel: VRadioButtonModel = .init()
        
        var model: VRadioButtonModel = .init()
        
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
extension VRadioButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VRadioButton(model: model, state: $state, title: RadioButtonTitle)
        case .custom: VRadioButton(model: model, state: $state, content: RadioButtonContent)
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
    
    private var RadioButtonTitle: String { "Lorem ipsum" }
    
    private func RadioButtonContent() -> some View { DemoIconContentView() }
}

// MARK:- Helpers
extension VRadioButtonState: VPickableTitledItem {
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
struct VRadioButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRadioButtonDemoView()
    }
}
