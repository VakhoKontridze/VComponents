//
//  VBaseTextFieldDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VComponents

// MARK:- V Base TextField Demo View
struct VBaseTextFieldDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base TextField"
    
    @State private var stateAccordionState: VAccordionState = .expanded
    @State private var textsAccordionState: VAccordionState = .collapsed
    @State private var formattingAccordionState: VAccordionState = .collapsed
    
    @State private var isSecure: Bool = VBaseTextFieldModel.Misc().isSecureTextEntry
    @State private var textFieldState: VBaseTextFieldState = .enabled
    @State private var hasPlaceholder: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: VBaseTextFieldModel.Layout.TextAlignment = .default
    @State private var hasAutoCorrect: Bool = VBaseTextFieldModel.Misc().useAutoCorrect
    @State private var textFieldText: String = ""
    
    private var textFieldModel: VBaseTextFieldModel {
        var model: VBaseTextFieldModel = .init()
        
        model.misc.isSecureTextEntry = isSecure
        model.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        model.misc.useAutoCorrect = hasAutoCorrect
        
        model.layout.textAlignment = textAlignment
        
        return model
    }
}

// MARK:- Body
extension VBaseTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .freeFormFlexible, content: {
                VStack(spacing: 20, content: {
                    VAccordion(state: $stateAccordionState, header: { VAccordionDefaultHeader(title: "General") }, content: {
                        VStack(spacing: 20, content: {
                            ToggleSettingView(isOn: $isSecure, title: "Secure Field")
                            
                            VSegmentedPicker(selection: $textFieldState, title: "State")
                        })
                    })
                    
                    VAccordion(state: $textsAccordionState, header: { VAccordionDefaultHeader(title: "Texts") }, content: {
                        VStack(spacing: 20, content: {
                            ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")
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
                    
                    VBaseTextField(
                        model: textFieldModel,
                        state: $textFieldState,
                        placeholder: hasPlaceholder ? "Lorem ipsum" : "",
                        text: $textFieldText
                    )
                })
            })
        })
    }
}

// MARK:- Helpers
extension VBaseTextFieldState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .focused: return "Focused"
        case .disabled: return "Disabled"
        }
    }
}

extension VTextFieldModel.Layout.TextAlignment: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        case .trailing: return "Trailing"
        case .automatic: return "Automatic"
        }
    }
}

// MARK:- Preview
struct VBaseTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextFieldDemoView()
    }
}
