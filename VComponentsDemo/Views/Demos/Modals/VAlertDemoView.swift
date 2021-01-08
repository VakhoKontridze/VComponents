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
    
    @State private var title: String = "Title"
    @State private var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var dialogType: DialogType = .two
    
    @State private var alertIsShown: Bool = false
    private var alertDialog: VAlertDialogType {
        switch dialogType {
        case .one:
            return .one(
                button: .init(title: "Ok", action: {})
            )
        
        case .two:
            return .two(
                primary: .init(title: "Confirm", action: {}),
                secondary: .init(title: "Cancel", action: {})
            )
        }
    }
    
    private enum DialogType: Int, CaseIterable, VPickerTitledEnumerableOption {
        case one
        case two
        
        var pickerTitle: String {
            switch self {
            case .one: return "One Button"
            case .two: return "Two Buttons"
            }
        }
    }
}

// MARK:- Body
extension VAlertDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            VStack(spacing: 20, content: {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                VStack(spacing: 3, content: {
                    Text("Dialog Type")
                        .font(.footnote)
                    
                    VSegmentedPicker(selection: $dialogType)
                })
                
                VSecondaryButton(action: { alertIsShown = true }, title: "Demo Alert")
                
                Spacer()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
            
                .vAlert(
                    isPresented: $alertIsShown,
                    dialog: alertDialog,
                    title: title,
                    description: description
                )
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
    }
}

// MARK:- Preview
struct VAlertDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VAlertDemoView()
    }
}
