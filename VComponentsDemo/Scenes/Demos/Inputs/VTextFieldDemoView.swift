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
    static var navBarTitle: String { "TextField" }

    @State private var text: String = ""
    @State private var isEnabled: Bool = true
    @FocusState private var isFocused: Bool
    @State private var textFieldType: VTextFieldType = .default
    @State private var textFieldHighlight: VTextFieldHighlight = .none
    @State private var hasPlaceholder: Bool = true
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: TextAlignment = VTextFieldModel.Layout().textAlignment
    @State private var autocapitalizaton: Bool = false
    @State private var autocorrection: Bool = false
    @State private var hasClearButton: Bool = VTextFieldModel.Misc().hasClearButton
    
    private var model: VTextFieldModel {
        var model: VTextFieldModel = .init()
        
        model.layout.textAlignment = textAlignment
        
        model.colors = {
            switch textFieldHighlight {
            case .none: return .init()
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }()
        
        model.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        
        model.misc.autocorrection = autocorrection
        model.misc.autocapitalization = autocapitalizaton ? .words : nil
        
        model.misc.hasClearButton = hasClearButton
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VTextField(
            model: model,
            type: textFieldType,
            placeholder: hasPlaceholder ? "Lorem ipsum" : nil,
            headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
            footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
            text: $text
        )
            .disabled(!isEnabled)
            .focused($isFocused)
    }

    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { _VTextFieldState(isEnabled: isEnabled, isFocused: isFocused) },
                    set: { state in
                        isEnabled = state != .disabled
                        isFocused = state == .focused
                    }
                ),
                headerTitle: "State"
            )
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
                title: "Submit Button",
                description: "Default set to \"return\". Other types are not shown in the demo, as there are many."
            )

            ToggleSettingView(
                isOn: $hasClearButton,
                title: "Clear Button",
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

                ToggleSettingView(
                    isOn: $autocorrection,
                    title: "Autocorrection"
                )
                
                ToggleSettingView(
                    isOn: $autocapitalizaton,
                    title: "Autocapitalizaton",
                    description: "Other types are not shown in the demo, as there are many."
                )

                VSegmentedPicker(selection: $textAlignment, headerTitle: "Alignment")
            })
        })
    }
}

// MARK: - Helpers
private enum _VTextFieldState: PickableTitledEnumeration {
    case enabled
    case focused
    case disabled
    
    init(isEnabled: Bool, isFocused: Bool) {
        switch (isEnabled, isFocused) {
        case (false, _): self = .disabled
        case (true, false): self = .enabled
        case (true, true): self = .focused
        }
    }
    
    var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .focused: return "Focused"
        case .disabled: return "Disabled"
        }
    }
}

extension VTextFieldType: PickableTitledEnumeration {
    public var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .secure: return "Secure"
        case .search: return "Search"
        @unknown default: fatalError()
        }
    }
}

extension TextAlignment: PickableTitledEnumeration {
    public var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        case .trailing: return "Traiiling"
        }
    }
}

private enum VTextFieldHighlight: PickableTitledEnumeration {
    case `none`
    case success
    case warning
    case error
    
    var pickerTitle: String {
        switch self {
        case .none: return "None"
        case .success:  return "Success"
        case .warning:  return "Warning"
        case .error:  return "Error"
        }
    }
}

// MARK: - Preview
struct VTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextFieldDemoView()
    }
}
