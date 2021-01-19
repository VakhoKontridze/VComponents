//
//  VAlertDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK:- V Alert Demo View
struct VAlertDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Alert"
    
    @State private var title: String = "Lorem ipsum dolor sit amet"
    @State private var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var dialogType: DialogType = .two
    
    @State private var isPresented: Bool = false
    private var alertDialog: VAlertDialogType {
        switch dialogType {
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
    
    private enum DialogType: Int, VPickableTitledItem {
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
    }
    
    @State private var text: String = ""
}

// MARK:- Body
extension VAlertDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    TextField("Title", text: $title).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description", text: $description).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    VSegmentedPicker(selection: $dialogType, title: "Dialog Type")
                    
                    VSecondaryButton(action: { isPresented = true }, title: "Demo Alert")
                })
            })
        })
            .vAlert(isPresented: $isPresented, alert: {
                VAlert(dialog: alertDialog, title: title, description: description, content: {
                    TextField("", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }, onDisappear: {
                    text = ""
                })
            })
    }
}

// MARK:- Preview
struct VAlertDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAlertDemoView()
    }
}
