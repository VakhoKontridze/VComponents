//
//  VCloseButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Close Button Demo View
struct VCloseButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Close Button"

    @State private var buttonState: VCloseButtonState = .enabled
    
    private let largerHitBoxButtonModel: VCloseButtonModel = {
        var model: VCloseButtonModel = .init()
        
        model.layout.hitBoxHor = 10
        model.layout.hitBoxVer = 10
        
        return model
    }()
}

// MARK:- Body
extension VCloseButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Default"), content: {
                    VCloseButton(state: buttonState, action: action)
                })

                DemoRowView(type: .titled("Larger Hit Box"), content: {
                    VCloseButton(model: largerHitBoxButtonModel, state: buttonState, action: action)
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                state: .init(
                    get: { buttonState == .disabled },
                    set: { buttonState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Action
private extension VCloseButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VCloseButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButtonDemoView()
    }
}
