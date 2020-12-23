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
    
    private func toggleContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(VComponents.ColorBook.accent)
    }
    
    @State private var noContentToggleIsOn: Bool = true
    
    @State private var standardTitleToggleIsOn: Bool = true
    @State private var standardIconToggleIsOn: Bool = true
    
    @State private var settingTitleToggleIsOn: Bool = true
    @State private var settingIconToggleIsOn: Bool = true
    
    @State private var nonInteractiveContentstandardIconToggleIsOn: Bool = true
    @State private var interactiveContentLeftFlexibleContentToggleIsOn: Bool = true
    
    @State private var noLoweredOpacityPressedContentToggleIsOn: Bool = true
    @State private var noLoweredOpacityDisabledContentToggleIsOn: Bool = true
    
    @State private var toggleState: VToggleState = .enabled
}

// MARK:- Body
extension VToggleDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            noContentToggle
            standardIconToggles
            leftFlexibleContentToggles
            nonInteractiveContentstandardIconToggle
            interactiveContentLeftFlexibleContentToggle
            noLoweredOpacityPressedContentToggle
            noLoweredOpacityDisabledContentToggle
        })
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
                    get: { toggleState == .disabled },
                    set: { toggleState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
    
    private var noContentToggle: some View {
        RowView(type: .titled("No Content"), content: {
            VToggle(isOn: $noContentToggleIsOn, state: toggleState)
        })
    }
    
    private var standardIconToggles: some View {
        VStack(content: {
            RowView(type: .titled("Standard (Text)"), content: {
                VToggle(.standard(), isOn: $standardTitleToggleIsOn, state: toggleState, title: toggleTitle)
            })
            
            RowView(type: .titled("Standard (Icon)"), content: {
                VToggle(.standard(), isOn: $standardIconToggleIsOn, state: toggleState, content: toggleContent)
            })
        })
    }
    
    private var leftFlexibleContentToggles: some View {
        VStack(content: {
            RowView(type: .titled("Setting (Text)"), content: {
                VToggle(.setting(), isOn: $settingTitleToggleIsOn, state: toggleState, title: toggleTitle)
            })
            
            RowView(type: .titled("Setting (Icon)"), content: {
                VToggle(.setting(), isOn: $settingIconToggleIsOn, state: toggleState, content: toggleContent)
            })
        })
    }
    
    private var nonInteractiveContentstandardIconToggle: some View {
        let model: VToggleStandardModel = .init(
            behavior: .init(
                contentIsClickable: false
            )
        )
        
        return RowView(type: .titled("Non-interractive Content"), content: {
            VToggle(.standard(model), isOn: $nonInteractiveContentstandardIconToggleIsOn, state: toggleState, title: toggleTitle)
        })
    }
    
    private var interactiveContentLeftFlexibleContentToggle: some View {
        let model: VToggleSettingModel = .init(
            behavior: .init(
                contentIsClickable: true,
                spaceIsClickable: true,
                animation: .default
            )
        )
        
        return RowView(type: .titled("Interractive Spacing"), content: {
            VToggle(.setting(model), isOn: $interactiveContentLeftFlexibleContentToggleIsOn, state: toggleState, title: toggleTitle)
        })
    }
    
    private var noLoweredOpacityPressedContentToggle: some View {
        let model: VToggleStandardModel = .init(
            colors: .init(
                content: .init(
                    pressedOpacity: 1,
                    disabledOpacity: 0.5
                )
            )
        )
        
        return VStack(content: {
            RowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                VToggle(.standard(model), isOn: $noLoweredOpacityPressedContentToggleIsOn, state: toggleState, title: toggleTitle)
            })
        })
    }
    
    private var noLoweredOpacityDisabledContentToggle: some View {
        let model: VToggleStandardModel = .init(
            colors: .init(
                content: .init(
                    pressedOpacity: 0.5,
                    disabledOpacity: 1
                )
            )
        )
        
        return VStack(content: {
            RowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                VToggle(.standard(model), isOn: $noLoweredOpacityDisabledContentToggleIsOn, state: toggleState, title: toggleTitle)
            })
        })
    }
}

// MARK: Preview
struct VToggleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleDemoView()
    }
}

