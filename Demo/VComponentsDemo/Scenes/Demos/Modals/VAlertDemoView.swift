//
//  VAlertDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Alert Demo View
struct VAlertDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Alert" }
    
    @State private var isPresented: Bool = false
    @State private var text: String = ""
    @State private var title: String = "Lorem Ipsum Dolor Sit Amet"
    @State private var message: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var alertButtons: VAlertButtonsHelper = .two
    @State private var ignoreKeyboardSafeArea: Bool = !VAlertUIModel.Layout().ignoredKeyboardSafeAreaEdges.isEmpty
    
    private var uiModel: VAlertUIModel {
        var uiModel: VAlertUIModel = .init()
        uiModel.layout.ignoredKeyboardSafeAreaEdges = ignoreKeyboardSafeArea ? .all : []
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vAlert(
                id: "alert_demo",
                uiModel: uiModel,
                isPresented: $isPresented,
                title: title,
                message: message,
                content: { VTextField(placeholder: "Name", text: $text) },
                actions: { alertButtons.actions(text: text) }
            )
            .onChange(of: isPresented, perform: { value in
                if !value { text = "" }
            })
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VTextField(
                headerTitle: "Title",
                placeholder: "Title",
                text: $title
            )
            
            VTextField(
                headerTitle: "Description",
                placeholder: "Description",
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
private enum VAlertButtonsHelper: Int, StringRepresentableHashableEnumeration {
    case none
    case one
    case two
    case many
    
    var stringRepresentation: String {
        switch self {
        case .none: return "No Buttons"
        case .one: return "One Button"
        case .two: return "Two Buttons"
        case .many: return "Many Buttons"
        }
    }
    
    @VAlertButtonBuilder func actions(text: String) -> [any VAlertButtonProtocol] {
        switch self {
        case .none:
            [any VAlertButtonProtocol]()
            
        case .one:
            VAlertPrimaryButton(action: {}, title: "Option A").disabled(text.isEmpty)
        
        case .two:
            VAlertPrimaryButton(action: {}, title: "Option A").disabled(text.isEmpty)
            VAlertCancelButton(action: nil)
            
        case .many:
            VAlertPrimaryButton(action: {}, title: "Option A").disabled(text.isEmpty)
            VAlertSecondaryButton(action: {}, title: "Option B").disabled(text.isEmpty)
            VAlertDestructiveButton(action: {}, title: "Delete").disabled(text.isEmpty)
            VAlertCancelButton(action: nil)
        }
    }
}

// MARK: - Preview
struct VAlertDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAlertDemoView()
    }
}
