//
//  VCheckBoxDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VComponents

// MARK:- V CheckBox Demo View
struct VCheckBoxDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "CheckBox"
    
    private let checkBoxTitle: String = "Lorem ipsum"
    
    private func checkBoxContent() -> some View { VDemoIconContentView() }
    
    let nonClickableContentModel: VCheckBoxModel = {
        var model: VCheckBoxModel = .init()
        model.contentIsClickable = false
        return model
    }()
    
    let clippedHitBoxModel: VCheckBoxModel = {
        var model: VCheckBoxModel = .init()
        model.layout.contentMarginLeading = model.layout.hitBox
        model.layout.hitBox = 0
        return model
    }()
    
    let noLoweredOpacityWhenPressedModel: VCheckBoxModel = {
        var model: VCheckBoxModel = .init()
        model.colors.content.pressedOpacity = 1
        return model
    }()
    
    let noLoweredOpacityWhenDisabledModel: VCheckBoxModel = {
        var model: VCheckBoxModel = .init()
        model.colors.content.disabledOpacity = 1
        return model
    }()
    
    @State private var checkBox1State: VCheckBoxState = .on
    @State private var checkBox2State: VCheckBoxState = .on
    @State private var checkBox3State: VCheckBoxState = .on
    @State private var checkBox4State: VCheckBoxState = .on
    @State private var checkBox5State: VCheckBoxState = .on
    @State private var checkBox6State: VCheckBoxState = .on
    @State private var checkBox7State: VCheckBoxState = .on
}

// MARK:- Body
extension VCheckBoxDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("No Content"), content: {
                    VCheckBox(state: $checkBox1State)
                })
                
                DemoRowView(type: .titled("Text"), content: {
                    VCheckBox(state: $checkBox2State, title: checkBoxTitle)
                })
                
                DemoRowView(type: .titled("Icon"), content: {
                    VCheckBox(state: $checkBox3State, content: checkBoxContent)
                })
                
                DemoRowView(type: .titled("Non-clickable Content"), content: {
                    VCheckBox(model: nonClickableContentModel, state: $checkBox4State, title: checkBoxTitle)
                })
                
                DemoRowView(type: .titled("Clipped Hitbox"), content: {
                    VCheckBox(model: clippedHitBoxModel, state: $checkBox5State, title: checkBoxTitle)
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                    VCheckBox(model: noLoweredOpacityWhenPressedModel, state: $checkBox6State, title: checkBoxTitle)
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                    VCheckBox(model: noLoweredOpacityWhenDisabledModel, state: $checkBox7State, title: checkBoxTitle)
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                controllerToggle(active: .intermediate, title: "Intermediate")
                Spacer()
                controllerToggle(active: .disabled, title: "Disabled")
                Spacer()
            })
        })
    }
    
    private func controllerToggle(active state: VCheckBoxState, title: String) -> some View {
        ControllerToggleView(
            state: .init(
                get: {
                    ![checkBox1State, checkBox2State, checkBox3State, checkBox4State, checkBox5State, checkBox6State, checkBox7State]
                        .contains(where: { $0 != state })
                },
                set: {
                    checkBox1State = $0 ? state : .off
                    checkBox2State = $0 ? state : .off
                    checkBox3State = $0 ? state : .off
                    checkBox4State = $0 ? state : .off
                    checkBox5State = $0 ? state : .off
                    checkBox6State = $0 ? state : .off
                    checkBox7State = $0 ? state : .off
                }
            ),
            title: title
        )
    }
}

// MARK: Preview
struct VCheckBoxDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCheckBoxDemoView()
    }
}
