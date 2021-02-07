//
//  VSegmentedPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI
import VComponents

// MARK:- V Segmented Picker Demo View
struct VSegmentedPickerDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Segmented Picker"
    
    @State private var selection: ComponentRGBItem = .red
    @State private var state: VSegmentedPickerState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var hasDisabledRow: Bool = false
    @State private var selectionAnimation: Bool = VSegmentedPickerModel.Animations().selection != nil
    @State private var loweredOpacityWhenPressed: Bool = VSegmentedPickerModel.Colors().content.pressedOpacity != 1
    @State private var resizeIndicatorWhenPressed: Bool = VSegmentedPickerModel.Layout().indicatorPressedScale != 1
    @State private var loweredOpacityWhenDisabled: Bool = VSegmentedPickerModel.Colors().content.disabledOpacity != 1

    private var model: VSegmentedPickerModel {
        let defaultModel: VSegmentedPickerModel = .init()
        
        var model: VSegmentedPickerModel = .init()
        
        model.animations.selection = selectionAnimation ? (defaultModel.animations.selection ?? .default) : nil
        
        model.colors.content.pressedOpacity = loweredOpacityWhenPressed ? 0.5 : 1
        
        model.layout.indicatorPressedScale =
            resizeIndicatorWhenPressed ?
            (model.layout.indicatorPressedScale == 1 ? 0.95 : model.layout.indicatorPressedScale) :
            1
        
        model.colors.content.disabledOpacity = loweredOpacityWhenDisabled ? 0.5 : 1
        
        return model
    }
}

// MARK:- Body
extension VSegmentedPickerDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text:
            VSegmentedPicker(
                model: model,
                state: state,
                selection: $selection,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                disabledItems: hasDisabledRow ? [.green] : []
            )
        
        case .custom:
            VSegmentedPicker(
                model: model,
                state: state,
                selection: $selection,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                disabledItems: hasDisabledRow ? [.green] : [],
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
            ToggleSettingView(isOn: $hasDisabledRow, title: "Disabled Row")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $selectionAnimation, title: "Selection Animation")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $loweredOpacityWhenPressed, title: "Low Pressed Opacity", description: "Content lowers opacity when pressed")
            
            ToggleSettingView(isOn: $resizeIndicatorWhenPressed, title: "Resize Indicator", description: "Selection indicator resizes when pressed")

            ToggleSettingView(isOn: $loweredOpacityWhenDisabled, title: "Low Disabled Opacity", description: "Content lowers opacity when disabled")
        })
    }
}

// MARK:- Helpers
extension VSegmentedPickerState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
}

enum ComponentRGBItem: Int, VPickableTitledItem {
    case red
    case green
    case blue
    
    var pickerTitle: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        }
    }
    
    var pickerSymbol: some View {
        let color: Color = {
            switch self {
            case .red: return .red
            case .green: return .green
            case .blue: return .blue
            }
        }()
        
        return DemoIconContentView(color: color)
    }
}

// MARK:- Preview
struct VSegmentedPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSegmentedPickerDemoView()
    }
}
