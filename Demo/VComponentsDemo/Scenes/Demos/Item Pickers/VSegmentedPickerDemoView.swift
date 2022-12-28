//
//  VSegmentedPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Segmented Picker Demo View
struct VSegmentedPickerDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Segmented Picker" }
    
    @State private var selection: VSegmentedPickerDataSource = .red
    @State private var isEnabled: Bool = true
    @State private var contentType: VSegmentedPickerContent = .title
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var hasDisabledRow: Bool = false
    @State private var selectionAnimation: Bool = VSegmentedPickerUIModel.Animations().selection != nil
    @State private var resizeIndicatorWhenPressed: Bool = VSegmentedPickerUIModel.Layout().indicatorPressedScale != 1

    private var uiModel: VSegmentedPickerUIModel {
        let defaultUIModel: VSegmentedPickerUIModel = .init()
        
        var uiModel: VSegmentedPickerUIModel = .init()
        
        uiModel.animations.selection = selectionAnimation ? (defaultUIModel.animations.selection ?? .default) : nil
        
        uiModel.layout.indicatorPressedScale =
            resizeIndicatorWhenPressed ?
            (uiModel.layout.indicatorPressedScale == 1 ? 0.95 : uiModel.layout.indicatorPressedScale) :
            1
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch contentType {
            case .title:
                VSegmentedPicker(
                    uiModel: uiModel,
                    selection: $selection,
                    headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                    footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                    disabledIndexes: hasDisabledRow ? [1] : []
                )
            
            case .custom:
                VSegmentedPicker(
                    uiModel: uiModel,
                    selection: $selection,
                    headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                    footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                    disabledIndexes: hasDisabledRow ? [1] : [],
                    content: { $0.pickerSymbol }
                )
            }
        })
            .disabled(!isEnabled)
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VSegmentedPickerState(isEnabled: isEnabled) },
                    set: { isEnabled = $0 == .enabled }
                ),
                headerTitle: "State"
            )
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
            ToggleSettingView(isOn: $resizeIndicatorWhenPressed, title: "Resize Indicator", description: "Selection indicator resizes when pressed")
        })
    }
}

// MARK: - Helpers
private typealias VSegmentedPickerState = VSecondaryButtonInternalState

enum VSegmentedPickerContent: Int, StringRepresentableHashableEnumeration {
    case title
    case custom
    
    var stringRepresentation: String {
        switch self {
        case .title: return "Title"
        case .custom: return "Custom"
        }
    }
}

enum VSegmentedPickerDataSource: Int, StringRepresentableHashableEnumeration {
    case red
    case green
    case blue
    
    var stringRepresentation: String {
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
        
        return Image(systemName: "swift")
            .resizable()
            .frame(dimension: 15)
            .foregroundColor(color)
    }
}

// MARK: - Preview
struct VSegmentedPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSegmentedPickerDemoView()
    }
}
