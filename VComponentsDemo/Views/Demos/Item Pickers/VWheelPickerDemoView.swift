//
//  VWheelPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI
import VComponents

// MARK:- V Wheel Picker Demo View
struct VWheelPickerDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Wheel Picker"
    
    @State private var selection: ComponentRGBItem = .green
    @State private var state: VWheelPickerState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var loweredOpacityWhenDisabled: Bool = VWheelPickerModel.Colors().content.disabledOpacity != 1

    private var model: VWheelPickerModel {
        var model: VWheelPickerModel = .init()
        
        model.colors.content.disabledOpacity = loweredOpacityWhenDisabled ? 0.5 : 1
        
        return model
    }
}

// MARK:- Body
extension VWheelPickerDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text:
            VWheelPicker(
                model: model,
                state: state,
                selection: $selection,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil
            )
        
        case .custom:
            VWheelPicker(
                model: model,
                state: state,
                selection: $selection,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                rowContent: { $0.pickerSymbol }
            )
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
            ToggleSettingView(isOn: $hasHeader, title: "Header")
            
            ToggleSettingView(isOn: $hasFooter, title: "Footer")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $loweredOpacityWhenDisabled, title: "Low Disabled Opacity", description: "Content lowers opacity when disabled")
        })
    }
}

// MARK:- Helpers
extension VWheelPickerState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
}

// MARK:- Preview
struct VWheelPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VWheelPickerDemoView()
    }
}
