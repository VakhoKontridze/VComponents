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
    
    private let textFieldPlaceholder: String = "Lorem ipsum"
    
    @State private var textField1Text: String = ""
    @State private var textField2Text: String = ""
    @State private var textField1IsFocused: Bool = false
    @State private var textFieldState: VBaseTextFieldState = .enabled
}

// MARK:- Body
extension VBaseTextFieldDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Default"), content: {
                    VBaseTextField(
                        state: textFieldState,
                        placeholder: textFieldPlaceholder,
                        text: $textField1Text
                    )
                })
                
                DemoRowView(type: .titled("Focusable"), content: {
                    VBaseTextField(
                        state: textFieldState,
                        isFocused: $textField1IsFocused,
                        placeholder: textFieldPlaceholder,
                        text: $textField2Text
                    )
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                ControllerToggleView(state: $textField1IsFocused, title: "Focused")
                Spacer()
                controllerToggle(active: .disabled, title: "Disabled")
                Spacer()
            })
        })
    }
    
    private func controllerToggle(active state: VBaseTextFieldState, title: String) -> some View {
        ControllerToggleView(
            state: .init(
                get: { textFieldState == state },
                set: { textFieldState = $0 ? state : .enabled }
            ),
            title: title
        )
    }
}

// MARK:- Preview
struct VBaseTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseTextFieldDemoView()
    }
}
