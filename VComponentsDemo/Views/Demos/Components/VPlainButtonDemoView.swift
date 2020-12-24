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
    static let navigationBarTitle: String = "Plain Button"
    
    private let buttonTitle: String = "Press"
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(VComponents.ColorBook.accent)
    }
    
    @State private var buttonState: VPlainButtonState = .enabled
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            buttonsByContent
            clippedHitBoxButton
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
                    get: { buttonState == .disabled },
                    set: { buttonState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
    
    private var buttonsByContent: some View {
        VStack(content: {
            DemoRowView(type: .titled("Text"), content: {
                VPlainButton(state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Image"), content: {
                VPlainButton(state: buttonState, action: action, content: buttonContent)
            })
            
            DemoRowView(type: .titled("Image and Text"), content: {
                VPlainButton(state: buttonState, action: action, content: {
                    VStack(spacing: 5, content: {
                        buttonContent()
                        Text(buttonTitle)
                    })
                })
            })
        })
    }
    
    private var clippedHitBoxButton: some View {
        let clippedHitBoxButtonModel: VPlainButtonStandardModel = .init(
            layout: .init(
                hitBoxExtendX: 0,
                hitBoxExtendY: 0
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Clipped Hit Box"), content: {
                VPlainButton(.standard(clippedHitBoxButtonModel), state: buttonState, action: action, title: buttonTitle)
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
