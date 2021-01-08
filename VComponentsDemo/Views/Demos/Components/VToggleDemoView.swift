//
//  VToggleDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Toggle Demo View
struct VToggleDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Toggle"
    
    private let toggleTitle: String = "Toggle"
    
    private func toggleContent() -> some View { VDemoIconContentView() }
    
    let nonClickableContentModel: VToggleModel = .init(
        behavior: .init(
            contentIsClickable: false
        )
    )
    
    let noLoweredOpacityWhenPressedModel: VToggleModel = .init(
        colors: .init(
            content: .init(
                pressedOpacity: 1
            )
        )
    )
    
    let noLoweredOpacityWhenDisabledModel: VToggleModel = .init(
        colors: .init(
            content: .init(
                disabledOpacity: 1
            )
        )
    )
    
    @State private var toggle1IsOn: Bool = true
    @State private var toggle2IsOn: Bool = true
    @State private var toggle3IsOn: Bool = true
    @State private var toggle4IsOn: Bool = true
    @State private var toggle5IsOn: Bool = true
    @State private var toggle6IsOn: Bool = true
    @State private var toggleState: VToggleState = .enabled
}

// MARK:- Body
extension VToggleDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            DemoRowView(type: .titled("No Content"), content: {
                VToggle(isOn: $toggle1IsOn, state: toggleState)
            })
            
            DemoRowView(type: .titled("Text"), content: {
                VToggle(isOn: $toggle2IsOn, state: toggleState, title: toggleTitle)
            })
            
            DemoRowView(type: .titled("Icon"), content: {
                VToggle(isOn: $toggle3IsOn, state: toggleState, content: toggleContent)
            })
            
            DemoRowView(type: .titled("Non-clickable Content"), content: {
                VToggle(model: nonClickableContentModel, isOn: $toggle4IsOn, state: toggleState, title: toggleTitle)
            })
            
            DemoRowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                VToggle(model: noLoweredOpacityWhenPressedModel, isOn: $toggle5IsOn, state: toggleState, title: toggleTitle)
            })
            
            DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                VToggle(model: noLoweredOpacityWhenDisabledModel, isOn: $toggle6IsOn, state: toggleState, title: toggleTitle)
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
                    get: { toggleState == .disabled },
                    set: { toggleState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK: Preview
struct VToggleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleDemoView()
    }
}

