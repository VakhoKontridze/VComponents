//
//  VAlertDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V Alert Demo View
struct VAlertDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Alert" }
    
    @State private var isPresented: Bool = false
    @State private var text: String = ""
    @State private var title: String = "Lorem Ipsum Dolor Sit Amet"
    @State private var message: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var alertButtons: VAlertButtonsHelper = .two
    @State private var ignoreKeyboardSafeArea: Bool = !VAlertUIModel.Layout().ignoredKeybordSafeAreaEdges.isEmpty
    
    private var uiModel: VAlertUIModel {
        var uiModel: VAlertUIModel = .init()
        uiModel.layout.ignoredKeybordSafeAreaEdges = ignoreKeyboardSafeArea ? .all : []
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vAlert(
                uiModel: uiModel,
                isPresented: $isPresented,
                title: title,
                message: message,
                content: { VTextField(placeholder: "Name", text: $text) },
                actions: alertButtons.actions(text: text)
            )
            .onChange(of: isPresented, perform: { value in
                if !value { text = "" }
            })
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VTextField(
                placeholder: "Title",
                headerTitle: "Title",
                text: $title
            )
            
            VTextField(
                placeholder: "Description",
                headerTitle: "Description",
                text: $message
            )
        })
        
        DemoViewSettingsSection(content: {
            VWheelPicker(selection: $alertButtons, headerTitle: "Buttons")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $ignoreKeyboardSafeArea, title: "Ignore Keyboard Safe Area")
        })
    }
}

// MARK: - Helpers
private enum VAlertButtonsHelper: Int, PickableTitledEnumeration {
    case `none`
    case one
    case two
    case many
    
    var pickerTitle: String {
        switch self {
        case .none: return "No Buttons"
        case .one: return "One Button"
        case .two: return "Two Buttons"
        case .many: return "Many Buttons"
        }
    }
    
    func actions(text: String) -> [VAlertButton] {
        switch self {
        case .none:
            return []
            
        case .one:
            return [
                .primary(isEnabled: !text.isEmpty, action: {}, title: "Option A"),
            ]
        
        case .two:
            return [
                .primary(isEnabled: !text.isEmpty, action: {}, title: "Option A"),
                .cancel()
            ]
            
        case .many:
            return [
                .primary(isEnabled: !text.isEmpty, action: {}, title: "Option A"),
                .secondary(isEnabled: !text.isEmpty, action: {}, title: "Option B"),
                .destructive(isEnabled: !text.isEmpty, action: {}, title: "Delete"),
                .cancel()
            ]
        }
    }
}

// MARK: - Preview
struct VAlertDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAlertDemoView()
    }
}
