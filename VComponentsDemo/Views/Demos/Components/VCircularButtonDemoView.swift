//
//  VCircularButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Circular Button Demo View
struct VCircularButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Circular Button"
    
    private let buttonTitle: String = "Press"
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(ColorBook.primaryInverted)
    }

    @State private var buttonState: VCircularButtonState = .enabled
}

// MARK:- Body
extension VCircularButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            buttons
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
                    get: { buttonState == .disabled },
                    set: { buttonState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
    
    private var buttons: some View {
        VStack(content: {
            DemoRowView(type: .titled("Image"), content: {
                VCircularButton(state: buttonState, action: action, content: buttonContent)
            })
            
            DemoRowView(type: .titled("Text"), content: {
                VCircularButton(state: buttonState, action: action, content: {
                    Text(buttonTitle)
                })
            })
        })
    }
}

// MARK:- Action
private extension VCircularButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VCircularButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButtonDemoView()
    }
}
