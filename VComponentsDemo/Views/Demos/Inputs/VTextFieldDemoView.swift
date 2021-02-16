//
//  VTextFieldDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import SwiftUI
import VComponents

// MARK: V Text Field Demo View
struct VTextFieldDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "TextField"

    @State private var text: String = ""
    @State private var state: VTextFieldState = .enabled
    @State private var textFieldType: VTextFieldType = .default
    @State private var textFieldHighlight: VTextFieldHighlight = .default
    @State private var hasPlaceholder: Bool = true
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: VTextFieldModel.Layout.TextAlignment = .default
    @State private var spellCheck: UITextSpellCheckingType = VTextFieldModel.Misc().spellCheck
    @State private var autoCorrect: UITextAutocorrectionType = VTextFieldModel.Misc().autoCorrect
    @State private var autoCapitalizaton: UITextAutocapitalizationType = VTextFieldModel.Misc().autoCapitalization
    @State private var hasClearButton: Bool = VTextFieldModel.Misc().clearButton
    @State private var hasCancelButton: Bool = VTextFieldModel.Misc().cancelButton != nil
    
    private var model: VTextFieldModel {
        var model: VTextFieldModel = .init()
        
        model.layout.textAlignment = textAlignment
        
        model.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        
        model.misc.spellCheck = spellCheck
        model.misc.autoCorrect = autoCorrect
        model.misc.autoCapitalization = autoCapitalizaton
        
        model.misc.clearButton = hasClearButton
        model.misc.cancelButton = hasCancelButton ? "Cancel" : nil
        
        return model
    }
}

// MARK:- Body
extension VTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    private func component() -> some View {
        VTextField(
            model: model,
            type: textFieldType,
            state: $state,
            highlight: textFieldHighlight,
            placeholder: hasPlaceholder ? "Lorem ipsum" : nil,
            headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
            footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
            text: $text
        )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $state, headerTitle: "State")
        })
        
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $textFieldType, headerTitle: "Type")
            
            VSegmentedPicker(selection: $textFieldHighlight, headerTitle: "Highlight")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")

            ToggleSettingView(isOn: $hasHeader, title: "Header")

            ToggleSettingView(isOn: $hasFooter, title: "Footer")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(
                isOn: .constant(true),
                title: "Return Button",
                description: "Default set to \"return\". Other types are not shown in the demo, as there are many."
            )

            ToggleSettingView(
                isOn: $hasClearButton,
                title: "Clear Button",
                description: "Not supported for secure type"
            )

            ToggleSettingView(
                isOn: $hasCancelButton,
                title: "Cancel Button",
                description: "Not supported for secure type"
            )
        })
        
        DemoViewSettingsSection(content: {
            VStack(spacing: 20, content: {
                ToggleSettingView(
                    isOn: $numericalKeyboard,
                    title: "Numerical Keyboard",
                    description: "Many keyboard types are supported. ASCII and numerical are shown for demo."
                )
                
                ToggleSettingView(
                    isOn: .constant(false),
                    title: "Content Type",
                    description: "Default set to \"nil\". Other types are not shown in the demo, as there are many."
                )
                
                VSegmentedPicker(selection: $spellCheck, headerTitle: "Spell Check")

                VSegmentedPicker(selection: $autoCorrect, headerTitle: "Autocorrect")

                VSegmentedPicker(selection: $autoCapitalizaton, headerTitle: "Auto-Capitalizaiton")
                
                VSegmentedPicker(selection: $textAlignment, headerTitle: "Alignment")
            })
        })
    }
}

// MARK:- Helpers
extension VTextFieldState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .focused: return "Focused"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

extension VTextFieldType: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .secure: return "Secure"
        case .search: return "Search"
        @unknown default: fatalError()
        }
    }
}

extension VTextFieldHighlight: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .none: return "None"
        case .success:  return "Success"
        case .error:  return "Error"
        @unknown default: fatalError()
        }
    }
}

// MARK:- Preview
struct VTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextFieldDemoView()
    }
}
