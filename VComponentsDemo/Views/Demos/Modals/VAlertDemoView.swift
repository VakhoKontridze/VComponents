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
    @State private var hasTwoButtons: Bool = true
    
    @State private var alertIsShown: Bool = false
    private var alertDialog: VAlertDialogType {
        switch hasTwoButtons {
        case false:
            return .one(
                button: .init(title: "Ok", action: {})
            )
        
        case true:
            return .two(
                primary: .init(title: "Confirm", action: {}),
                secondary: .init(title: "Cancel", action: {})
            )
        }
    }
}

// MARK:- Body
extension VAlertDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            VStack(spacing: 10, content: {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                VToggle(isOn: $hasTwoButtons, title: "Has Two Buttons")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
