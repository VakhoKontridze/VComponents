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
    
    @State private var rightTitleToggleIsOn: Bool = true
    @State private var rightContentToggleIsOn: Bool = true
    @State private var leftFlexibleTitleToggleIsOn: Bool = true
    @State private var leftFlexibleContentToggleIsOn: Bool = true
    @State private var nonClickableToggleIsOn: Bool = true
    
    @State private var toggleState: VToggleState = .enabled
}

// MARK:- Body
extension VToggleDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(viewModel: .init(), content: {
                rightContentToggle
                leftFlexibleContentToggle
                notClickableToggle
            })
        })
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
            HStack(content: {
                ToggleSettingView(
                    isOn: .init(
                        get: { toggleState == .disabled },
                        set: { toggleState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
            })
        })
    }
    
    private var rightContentToggle: some View {
        VStack(content: {
            RowView(
                type: .titled("Right Text Alignment"),
                content: { VToggle(isOn: $rightTitleToggleIsOn, state: toggleState, viewModel: .init(), title: toggleTitle) }
            )
            
            RowView(
                type: .titled("Right Content Alignment"),
                content: { VToggle(isOn: $rightContentToggleIsOn, state: toggleState, viewModel: .init(), content: toggleContent) }
            )
        })
    }
    
    private var leftFlexibleContentToggle: some View {
        let viewModel: VToggleViewModel = .init(
            behavior: .init(),
            layout: .init(
                contentLayout: .leftFlexible
            ),
            colors: .init()
        )
        
        return VStack(content: {
            RowView(
                type: .titled("Flexible Left Text Alignment"),
                content: { VToggle(isOn: $leftFlexibleTitleToggleIsOn, state: toggleState, viewModel: viewModel, title: toggleTitle) }
            )
            
            RowView(
                type: .titled("Flexible Left Content Alignment"),
                content: { VToggle(isOn: $leftFlexibleContentToggleIsOn, state: toggleState, viewModel: viewModel, content: toggleContent) }
            )
        })
    }
    
    private var notClickableToggle: some View {
        let viewModel: VToggleViewModel = .init(
            behavior: .init(
                contentIsClickable: false
            ),
            layout: .init(),
            colors: .init()
        )
        
        return RowView(
            type: .titled("Non-Clickable Text/Content"),
            content: { VToggle(isOn: $nonClickableToggleIsOn, state: toggleState, viewModel: viewModel, title: toggleTitle) }
        )
    }
}

// MARK: Preview
struct VToggleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleDemoView()
    }
}

