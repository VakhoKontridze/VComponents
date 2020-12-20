//
//  VPlainButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Plain Button Demo View
struct VPlainButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Plain Button"
    
    private let buttonTitle: String = "Press"
    
    @State private var buttonState: VPlainButtonState = .enabled
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(viewModel: .init(), content: {
                buttons
            })
        })
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
            HStack(content: {
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .disabled },
                        set: { buttonState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
            })
        })
    }
    
    private var buttons: some View {
        VStack(content: {
            RowView(type: .untitled, content: {
                VPlainButton(state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
}

// MARK:- Action
private extension VPlainButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}