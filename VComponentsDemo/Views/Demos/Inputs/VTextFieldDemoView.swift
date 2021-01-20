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
    
    @State private var stateAccordionState: VAccordionState = .expanded
    @State private var textsAccordionState: VAccordionState = .collapsed
    @State private var buttonsAccordionState: VAccordionState = .collapsed
    @State private var formattingAccordionState: VAccordionState = .collapsed
    
    @State private var textFieldType: VTextFieldType = .default
    @State private var textFieldState: VTextFieldState = .enabled
    @State private var textFieldHighlight: VTextFieldHighlight = .default
    @State private var hasPlaceholder: Bool = true
    @State private var hasTitle: Bool = true
    @State private var hasDescription: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: VTextFieldModel.Layout.TextAlignment = .default
    @State private var hasAutoCorrect: Bool = VTextFieldModel().useAutoCorrect
    @State private var hasClearButton: Bool = VTextFieldModel().clearButton
    @State private var hasCancelButton: Bool = VTextFieldModel().cancelButton != nil
    @State private var textFieldText: String = ""
    private let textFieldPlaceholder: String = "Lorem ipsum"
    
    private var textFieldModel: VTextFieldModel {
        var model: VTextFieldModel = .init()
        
        model.keyboardType = numericalKeyboard ? .numberPad : .default
        model.useAutoCorrect = hasAutoCorrect
        
        model.clearButton = hasClearButton
        model.cancelButton = hasCancelButton ? "Cancel" : nil
        
        model.layout.textAlignment = textAlignment
        
        return model
    }
}

// MARK:- Body
extension VTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .freeFormFlexible, content: {
                VStack(spacing: 20, content: {
                    VAccordion(state: $stateAccordionState, header: { VAccordionDefaultHeader(title: "General") }, content: {
                        VStack(spacing: 20, content: {
                            VSegmentedPicker(selection: $textFieldType, title: "Type")
                            
                            VSegmentedPicker(selection: $textFieldState, title: "State")
                            
                            VSegmentedPicker(selection: $textFieldHighlight, title: "Highlight")
                        })
                    })
                    
                    VAccordion(state: $textsAccordionState, header: { VAccordionDefaultHeader(title: "Texts") }, content: {
                        VStack(spacing: 20, content: {
                            ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")
                            
                            ToggleSettingView(isOn: $hasTitle, title: "Title")
                            
                            ToggleSettingView(isOn: $hasDescription, title: "Description")
                        })
                    })
                    
                    VAccordion(state: $buttonsAccordionState, header: { VAccordionDefaultHeader(title: "Buttons") }, content: {
                        VStack(spacing: 20, content: {
                            ToggleSettingView(isOn: $hasClearButton, title: "Clear Button")
                            
                            ToggleSettingView(isOn: $hasCancelButton, title: "Cancel Button")
                        })
                    })
                    
                    VAccordion(state: $formattingAccordionState, header: { VAccordionDefaultHeader(title: "Formatting") }, content: {
                        VStack(spacing: 20, content: {
                            ToggleSettingView(
                                isOn: $numericalKeyboard,
                                title: "Numerical Keyboard",
                                description: "Many keyboard types are supported. ASCII and numerical are shown for demo."
                            )
                            
                            ToggleSettingView(isOn: $hasAutoCorrect, title: "Autocorrect")
                            
                            VSegmentedPicker(selection: $textAlignment, title: "Alignment")
                        })
                    })
                    
                    VSheet(content: {
                        VTextField(
                            model: textFieldModel,
                            type: textFieldType,
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
        })
    }
}

// MARK:- Helpers
extension VTextFieldType: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .secure: return "Secure"
        case .search: return "Search"
        }
    }
}

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
