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
    static let navigationBarTitle: String = "TextField"
    
    @State private var textFieldState: VTextFieldState = .enabled
    @State private var textFieldHighlight: VTextFieldHighlight = .default
    @State private var hasPlaceholder: Bool = true
    @State private var hasTitle: Bool = true
    @State private var hasDescription: Bool = true
    @State private var hasClearButton: Bool = true
    @State private var hasCancelButton: Bool = true
    @State private var textFieldText: String = ""
    private let textFieldPlaceholder: String = "Lorem ipsum"
    
    private var textFieldModel: VTextFieldModel {
        var model: VTextFieldModel = .init()
        
        model.clearButton = hasClearButton
        model.cancelButton = hasCancelButton ? "Cancel" : nil
        
        return model
    }
}

// MARK:- Body
extension VTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    VSegmentedPicker(selection: $textFieldState, title: "State")
                    
                    VSegmentedPicker(selection: $textFieldHighlight, title: "Highlight")
                    
                    ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")
                    
                    ToggleSettingView(isOn: $hasTitle, title: "Title")
                    
                    ToggleSettingView(isOn: $hasDescription, title: "Description")
                    
                    ToggleSettingView(isOn: $hasClearButton, title: "Clear Button")
                    
                    ToggleSettingView(isOn: $hasCancelButton, title: "Cancel Button")
                    
                    VTextField(
                        model: textFieldModel,
                        state: $textFieldState,
                        highlight: textFieldHighlight,
                        placeholder: hasPlaceholder ? textFieldPlaceholder : "",
                        title: hasTitle ? "Lorem ipsum dolor sit amet" : "",
                        description: hasDescription ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit" : "",
                        text: $textFieldText
                    )
                })
            })
        })
    }
}

// MARK:- Helpers
//extension VTextFieldState: VPickableTitledItem {
//    public var pickerTitle: String {
//        switch self {
//        case .enabled: return "Enabled"
//        case .focused: return "Focused"
//        case .disabled: return "Disabled"
//        }
//    }
//}

extension VTextFieldHighlight: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .success:  return "Success"
        case .error:  return "Error"
        }
    }
}

// MARK:- Preview
struct VTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextFieldDemoView()
    }
}
