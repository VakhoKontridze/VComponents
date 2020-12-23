//
//  VChevronButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Chevron Button Demo View
struct VChevronButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Chevron Button"

    @State private var buttonState: VChevronButtonState = .enabled
}

// MARK:- Body
extension VChevronButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            buttons
        })
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
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
            RowView(type: .titled("Up"), content: {
                VChevronButton(direction: .up, state: buttonState, action: action)
            })
            
            RowView(type: .titled("Right"), content: {
                VChevronButton(direction: .right, state: buttonState, action: action)
            })
            
            RowView(type: .titled("Down"), content: {
                VChevronButton(direction: .down, state: buttonState, action: action)
            })
            
            RowView(type: .titled("Left"), content: {
                VChevronButton(direction: .left, state: buttonState, action: action)
            })
        })
    }
}

// MARK:- Action
private extension VChevronButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VChevronButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VChevronButtonDemoView()
    }
}
