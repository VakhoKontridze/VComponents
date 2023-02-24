//
//  VTextFieldDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import SwiftUI
import VComponents
import VCore

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
    @State private var textAlignment: TextAlignment = VTextFieldUIModel.Layout().textAlignment
    @State private var autocapitalization: Bool = false
    @State private var autocorrection: Bool = false
    @State private var hasClearButton: Bool = VTextFieldUIModel.Misc().hasClearButton
    
    private var uiModel: VTextFieldUIModel {
        var uiModel: VTextFieldUIModel = .init()
        
        uiModel.layout.textAlignment = textAlignment
        
        uiModel.colors = {
            switch textFieldHighlight {
            case .none: return .init()
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }()
        
        uiModel.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        
        uiModel.misc.autocorrection = autocorrection
        uiModel.misc.autocapitalization = autocapitalization ? .words : nil
        
        uiModel.misc.hasClearButton = hasClearButton
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settingsSections: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        ZStack(content: {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture(perform: { isFocused = false })
            
            VTextField(
                uiModel: uiModel,
                type: textFieldType,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                placeholder: hasPlaceholder ? "Lorem ipsum" : nil,
                text: $text
            )
                .disabled(!isEnabled)
                .focused($isFocused)
        })
    }

    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VTextFieldInternalState(isEnabled: isEnabled, isFocused: isFocused) },
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
                    isOn: $autocapitalization,
                    title: "Autocapitalization",
                    description: "Other types are not shown in the demo, as there are many."
                )

                VSegmentedPicker(selection: $textAlignment, headerTitle: "Alignment")
            })
        })
    }
}

// MARK: - Helpers
enum VTextFieldInternalState: StringRepresentableHashableEnumeration {
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
    
    var stringRepresentation: String {
        switch self {
        case .enabled: return "Enabled"
        case .focused: return "Focused"
        case .disabled: return "Disabled"
        }
    }
}

extension VTextFieldType: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .standard: return "Standard"
        case .secure: return "Secure"
        case .search: return "Search"
        }
    }
}

extension TextAlignment: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        case .trailing: return "Traiiling"
        }
    }
}

enum VTextFieldHighlight: StringRepresentableHashableEnumeration {
    case none
    case success
    case warning
    case error
    
    var stringRepresentation: String {
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
