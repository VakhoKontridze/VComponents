//
//  VDialogDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK:- V Dialog Demo View
struct VDialogDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Dialog"
    
    @State private var isPresented: Bool = false
    @State private var text: String = ""
    @State private var dialogButtons: VDialogButtonsHelper = .two
    @State private var title: String = "Lorem ipsum dolor sit amet"
    @State private var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var ignoreKeyboardSafeArea: Bool = !VDialogModel.Layout().ignoredKeybordSafeAreaEdges.isEmpty
    
    private var model: VDialogModel {
        var model: VDialogModel = .init()
        model.layout.ignoredKeybordSafeAreaEdges = ignoreKeyboardSafeArea ? .all : []
        return model
    }
}

// MARK:- Body
extension VDialogDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    private func component() -> some View {
        VSecondaryButton(action: { isPresented = true }, title: "Present")
            .vDialog(isPresented: $isPresented, dialog: {
                VDialog(
                    model: model,
                    buttons: dialogButtons.buttons(text: text),
                    title: title,
                    description: description,
                    content: { VTextField(placeholder: "Name", text: $text) }
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
            VSegmentedPicker(selection: $dialogButtons, headerTitle: "Buttons")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $ignoreKeyboardSafeArea, title: "Ignore Keyboard Safe Area")
        })
    }
}

// MARK:- Helpers
private enum VDialogButtonsHelper: Int, VPickableTitledItem {
    case one
    case two
    case many
    
    var pickerTitle: String {
        switch self {
        case .one: return "One Button"
        case .two: return "Two Buttons"
        case .many: return "Many Buttons"
        }
    }
    
    func buttons(text: String) -> VDialogButtons {
        switch self {
        case .one:
            return .one(
                button: .init(model: .primary, isEnabled: !text.isEmpty, title: "Ok", action: {})
            )
        
        case .two:
            return .two(
                primary: .init(model: .primary, isEnabled: !text.isEmpty, title: "Confirm", action: {}),
                secondary: .init(model: .secondary, title: "Cancel", action: {})
            )
            
        case .many:
            return .many([
                .init(model: .primary, isEnabled: !text.isEmpty, title: "Option A", action: {}),
                .init(model: .primary, isEnabled: !text.isEmpty, title: "Option B", action: {}),
                .init(model: .secondary, title: "Cancel", action: {})
            ])
        }
    }
}

extension VDialogButtons {
    fileprivate var helperType: VDialogButtonsHelper {
        switch self {
        case .one: return .one
        case .two: return .two
        case .many: return .many
        @unknown default: fatalError()
        }
    }
}

// MARK:- Preview
struct VDialogDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VDialogDemoView()
    }
}
