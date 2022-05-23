//
//  VDialogDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V Dialog Demo View
struct VDialogDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Dialog" }
    
    @State private var isPresented: Bool = false
    @State private var text: String = ""
    @State private var title: String = "Lorem ipsum dolor sit amet"
    @State private var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var dialogButtons: VDialogButtonsHelper = .two
    @State private var ignoreKeyboardSafeArea: Bool = !VDialogModel.Layout().ignoredKeybordSafeAreaEdges.isEmpty
    
    private var model: VDialogModel {
        var model: VDialogModel = .init()
        model.layout.ignoredKeybordSafeAreaEdges = ignoreKeyboardSafeArea ? .all : []
        return model
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
            .vDialog(isPresented: $isPresented, dialog: {
                VDialog(
                    model: model,
                    title: title,
                    description: description,
                    content: { VTextField(placeholder: "Name", text: $text) },
                    actions: dialogButtons.actions(text: text)
                )
            })
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
                text: $description
            )
        })
        
        DemoViewSettingsSection(content: {
            VWheelPicker(selection: $dialogButtons, headerTitle: "Buttons")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $ignoreKeyboardSafeArea, title: "Ignore Keyboard Safe Area")
        })
    }
}

// MARK: - Helpers
private enum VDialogButtonsHelper: Int, PickableTitledEnumeration {
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
    
    func actions(text: String) -> [VDialogButton] {
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
struct VDialogDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VDialogDemoView()
    }
}
