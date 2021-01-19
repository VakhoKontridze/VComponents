//
//  VRadioButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VComponents

// MARK:- V RadioButton Demo View
struct VRadioButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Radio Button"
    
    private let radioButtonTitle: String = "Lorem ipsum"
    
    private func radioButtonContent() -> some View { DemoIconContentView() }
    
    let nonClickableContentModel: VRadioButtonModel = {
        var model: VRadioButtonModel = .init()
        model.contentIsClickable = false
        return model
    }()
    
    let clippedHitBoxModel: VRadioButtonModel = {
        var model: VRadioButtonModel = .init()
        model.layout.contentMarginLeading = model.layout.hitBox
        model.layout.hitBox = 0
        return model
    }()
    
    let noLoweredOpacityWhenPressedModel: VRadioButtonModel = {
        var model: VRadioButtonModel = .init()
        model.colors.content.pressedOpacity = 1
        return model
    }()
    
    let noLoweredOpacityWhenDisabledModel: VRadioButtonModel = {
        var model: VRadioButtonModel = .init()
        model.colors.content.disabledOpacity = 1
        return model
    }()
    
    @State private var radioButton1State: VRadioButtonState = .on
    @State private var radioButton2State: VRadioButtonState = .on
    @State private var radioButton3State: VRadioButtonState = .on
    @State private var radioButton4State: VRadioButtonState = .on
    @State private var radioButton5State: VRadioButtonState = .on
    @State private var radioButton6State: VRadioButtonState = .on
    @State private var radioButton7State: VRadioButtonState = .on
}

// MARK:- Body
extension VRadioButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("No Content"), content: {
                    VRadioButton(state: $radioButton1State)
                })
                
                DemoRowView(type: .titled("Text"), content: {
                    VRadioButton(state: $radioButton2State, title: radioButtonTitle)
                })
                
                DemoRowView(type: .titled("Icon"), content: {
                    VRadioButton(state: $radioButton3State, content: radioButtonContent)
                })
                
                DemoRowView(type: .titled("Non-clickable Content"), content: {
                    VRadioButton(model: nonClickableContentModel, state: $radioButton4State, title: radioButtonTitle)
                })
                
                DemoRowView(type: .titled("Clipped Hitbox"), content: {
                    VRadioButton(model: clippedHitBoxModel, state: $radioButton5State, title: radioButtonTitle)
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                    VRadioButton(model: noLoweredOpacityWhenPressedModel, state: $radioButton6State, title: radioButtonTitle)
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                    VRadioButton(model: noLoweredOpacityWhenDisabledModel, state: $radioButton7State, title: radioButtonTitle)
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                controllerToggle(active: .off, title: "Off")
                Spacer()
                controllerToggle(active: .disabled, title: "Disabled")
                Spacer()
            })
        })
    }
    
    private func controllerToggle(active state: VRadioButtonState, title: String) -> some View {
        ControllerToggleView(
            state: .init(
                get: {
                    ![radioButton1State, radioButton2State, radioButton3State, radioButton4State, radioButton5State, radioButton6State, radioButton7State]
                        .contains(where: { $0 != state })
                },
                set: {
                    radioButton1State = $0 ? state : .off
                    radioButton2State = $0 ? state : .off
                    radioButton3State = $0 ? state : .off
                    radioButton4State = $0 ? state : .off
                    radioButton5State = $0 ? state : .off
                    radioButton6State = $0 ? state : .off
                    radioButton7State = $0 ? state : .off
                }
            ),
            title: title
        )
    }
}

// MARK: Preview
struct VRadioButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRadioButtonDemoView()
    }
}
