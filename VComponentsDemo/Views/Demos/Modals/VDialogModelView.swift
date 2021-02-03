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
    static let navigationBarTitle: String = "Dialog"
    
    @State private var isPresented: Bool = false
    @State private var textFieldState: VTextFieldState = .enabled
    @State private var text: String = ""
    
    @State private var dialogButtons: VDialogButtonsHelper = .two
    
    @State private var title: String = "Lorem ipsum dolor sit amet"
    @State private var titleTextFieldState: VTextFieldState = .enabled
    
    @State private var descriptionTextFieldState: VTextFieldState = .enabled
    @State private var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
}

// MARK:- Body
extension VDialogDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    private func component() -> some View {
        VSecondaryButton(action: { isPresented = true }, title: "Present")
            .vDialog(isPresented: $isPresented, dialog: {
                VDialog(
                    buttons: dialogButtons.buttons(text: text),
                    title: title,
                    description: description,
                    content: {
                        VTextField(
                            state: $textFieldState,
                            placeholder: "Name",
                            text: $text
                        )
                    }
                )
            })
            .onChange(of: isPresented, perform: { value in
                if !value { text = "" }
            })
    }
    
    @ViewBuilder private func settings() -> some View {
        VTextField(
            state: $titleTextFieldState,
            placeholder: "Title",
            headerTitle: "Title",
            text: $title
        )
        
        VTextField(
            state: $descriptionTextFieldState,
            placeholder: "Description",
            headerTitle: "Description",
            text: $description
        )
        
        VSegmentedPicker(selection: $dialogButtons, headerTitle: "Buttons")
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

private extension VDialogButtons {
    var helperType: VDialogButtonsHelper {
        switch self {
        case .one: return .one
        case .two: return .two
        case .many: return .many
        }
    }
}

// MARK:- Preview
struct VDialogDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VDialogDemoView()
    }
}
