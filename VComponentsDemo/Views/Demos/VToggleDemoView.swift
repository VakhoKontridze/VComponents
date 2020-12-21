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
    static let sceneTitle: String = "Toggle"
    
    private let toggleTitle: String = "Toggle"
    
    private func toggleContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(.accentColor)
    }
    
    @State private var noContentToggleIsOn: Bool = true
    
    @State private var rightTitleToggleIsOn: Bool = true
    @State private var rightContentToggleIsOn: Bool = true
    
    @State private var spacedLeftTitleToggleIsOn: Bool = true
    @State private var spacedLeftContentToggleIsOn: Bool = true
    
    @State private var nonInteractiveContentRightContentToggleIsOn: Bool = true
    @State private var interactiveContentLeftFlexibleContentToggleIsOn: Bool = true
    
    @State private var noLoweredOpacityPressedContentToggleIsOn: Bool = true
    @State private var noLoweredOpacityDisabledContentToggleIsOn: Bool = true
    
    @State private var toggleState: VToggleState = .enabled
}

// MARK:- Body
extension VToggleDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(content: {
                noContentToggle
                rightContentToggles
                leftFlexibleContentToggles
                nonInteractiveContentRightContentToggle
                interactiveContentLeftFlexibleContentToggle
                noLoweredOpacityPressedContentToggle
                noLoweredOpacityDisabledContentToggle
            })
        })
            .navigationTitle(Self.sceneTitle)
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
    
    private var rightContentToggles: some View {
        VStack(content: {
            RowView(type: .titled("Right Text Alignment"), content: {
                VToggle(.rightContent(), isOn: $rightTitleToggleIsOn, state: toggleState, title: toggleTitle)
            })
            
            RowView(type: .titled("Right Content Alignment"), content: {
                VToggle(.rightContent(), isOn: $rightContentToggleIsOn, state: toggleState, content: toggleContent)
            })
        })
    }
    
    private var leftFlexibleContentToggles: some View {
        VStack(content: {
            RowView(type: .titled("Spaced Left Text Alignment"), content: {
                VToggle(.spacedLeftContent(), isOn: $spacedLeftTitleToggleIsOn, state: toggleState, title: toggleTitle)
            })
            
            RowView(type: .titled("Spaced Left Content Alignment"), content: {
                VToggle(.spacedLeftContent(), isOn: $spacedLeftContentToggleIsOn, state: toggleState, content: toggleContent)
            })
        })
    }
    
    private var nonInteractiveContentRightContentToggle: some View {
        let model: VToggleRightContentModel = .init(
            behavior: .init(
                contentIsClickable: false
            )
        )
        
        return RowView(type: .titled("Non-interractive Content"), content: {
            VToggle(.rightContent(model), isOn: $nonInteractiveContentRightContentToggleIsOn, state: toggleState, title: toggleTitle)
        })
    }
    
    private var interactiveContentLeftFlexibleContentToggle: some View {
        let model: VToggleLeftFlexibleContentModel = .init(
            behavior: .init(
                contentIsClickable: true,
                spaceIsClickable: true,
                animation: .default
            )
        )
        
        return RowView(type: .titled("Interractive Spacing"), content: {
            VToggle(.spacedLeftContent(model), isOn: $interactiveContentLeftFlexibleContentToggleIsOn, state: toggleState, title: toggleTitle)
        })
    }
    
    private var noLoweredOpacityPressedContentToggle: some View {
        let model: VToggleRightContentModel = .init(
            colors: .init(
                content: .init(
                    pressedOpacity: 1,
                    disabledOpacity: 0.5
                )
            )
        )
        
        return VStack(content: {
            RowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                VToggle(.rightContent(model), isOn: $noLoweredOpacityPressedContentToggleIsOn, state: toggleState, title: toggleTitle)
            })
        })
    }
    
    private var noLoweredOpacityDisabledContentToggle: some View {
        let model: VToggleRightContentModel = .init(
            colors: .init(
                content: .init(
                    pressedOpacity: 0.5,
                    disabledOpacity: 1
                )
            )
        )
        
        return VStack(content: {
            RowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                VToggle(.rightContent(model), isOn: $noLoweredOpacityDisabledContentToggleIsOn, state: toggleState, title: toggleTitle)
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

