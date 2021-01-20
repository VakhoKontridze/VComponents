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
    
    @State private var textFieldState: VBaseTextFieldState = .enabled
    @State private var hasPlaceholder: Bool = true
    @State private var textFieldText: String = ""
}

// MARK:- Body
extension VBaseTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    VSegmentedPicker(selection: $textFieldState, title: "State")
                    
                    ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")
                    
                    VBaseTextField(
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

// MARK:- Preview
struct VBaseTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextFieldDemoView()
    }
}
