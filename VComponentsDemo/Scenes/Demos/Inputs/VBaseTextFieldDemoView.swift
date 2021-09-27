//
//  VBaseTextFieldDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import SwiftUI
import VComponents

// MARK: V Text Field Demo View
struct VBaseTextFieldDemoView: View {
    // MARK: Properties
    static let navBarTitle: String { "Base TextField" }

    @State private var text: String = ""
    @State private var state: VBaseTextFieldState = .enabled
    @State private var hasPlaceholder: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: VBaseTextFieldModel.Layout.TextAlignment = .default
    @State private var spellCheck: UITextSpellCheckingType = VBaseTextFieldModel.Misc().spellCheck
    @State private var autoCorrect: UITextAutocorrectionType = VBaseTextFieldModel.Misc().autoCorrect
    @State private var autoCapitalizaton: UITextAutocapitalizationType = VTextFieldModel.Misc().autoCapitalization

    private var model: VBaseTextFieldModel {
        var model: VBaseTextFieldModel = .init()
        
        model.layout.textAlignment = textAlignment
        
        model.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        model.misc.spellCheck = spellCheck
        model.misc.autoCorrect = autoCorrect
        model.misc.autoCapitalization = autoCapitalizaton
        
        return model
    }

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    private func component() -> some View {
        VBaseTextField(
            model: model,
            state: $state,
            placeholder: hasPlaceholder ? "Lorem ipsum" : nil,
            text: $text
        )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $state, headerTitle: "State")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(
                isOn: .constant(true),
                title: "Return Button",
                description: "Default set to \"return\". Other types not shown in this demo, as there are many."
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
                
                VSegmentedPicker(selection: $autoCapitalizaton, headerTitle: "Auto-Capitalizaton")

                VSegmentedPicker(selection: $textAlignment, headerTitle: "Alignment")
            })
        })
    }
}

// MARK: - Helpers
extension VBaseTextFieldState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .focused: return "Focused"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

extension VTextFieldModel.Layout.TextAlignment: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .center: return "Center"
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .auto: return "Auto"
        @unknown default: fatalError()
        }
    }
}

extension UITextSpellCheckingType: VPickableTitledItem {
    public static var allCases: [Self] = [.default, .no, .yes]
    
    public var pickerTitle: String {
        switch self {
        case .no: return "No"
        case .yes: return "Yes"
        case .default: return "Auto"
        @unknown default: fatalError()
        }
    }
}

extension UITextAutocorrectionType: VPickableTitledItem {
    public static var allCases: [Self] = [.default, .no, .yes]
    
    public var pickerTitle: String {
        switch self {
        case .no: return "No"
        case .yes: return "Yes"
        case .default: return "Auto"
        @unknown default: fatalError()
        }
    }
}

extension UITextAutocapitalizationType: VPickableTitledItem {
    public static var allCases: [Self] = [.none, .sentences, .words, .allCharacters]
    
    public var pickerTitle: String {
        switch self {
        case .none: return "None"
        case .sentences: return "Sentences"
        case .words: return "Words"
        case .allCharacters: return "All Chars"
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VBaseTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextFieldDemoView()
    }
}
