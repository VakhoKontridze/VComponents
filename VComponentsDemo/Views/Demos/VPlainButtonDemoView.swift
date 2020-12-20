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
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(.accentColor)
    }
    
    @State private var buttonState: VPlainButtonState = .enabled
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(content: {
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
            RowView(type: .titled("Text"), content: {
                VPlainButton(state: buttonState, action: action, title: buttonTitle)
            })
            
            RowView(type: .titled("Image"), content: {
                VPlainButton(state: buttonState, action: action, content: buttonContent)
            })
            
            RowView(type: .titled("Image and Text"), content: {
                VPlainButton(state: buttonState, action: action, content: {
                    VStack(spacing: 5, content: {
                        buttonContent()
                        Text(buttonTitle)
                    })
                })
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
