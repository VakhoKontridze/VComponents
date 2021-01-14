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
    
    private func buttonContent() -> some View { VDemoIconContentView() }
    
    @State private var buttonState: VPlainButtonState = .enabled
    
    let clippedHitBoxButtonModel: VPlainButtonModel = {
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        return model
    }()
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
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

                            VBaseTitle(
                                title: buttonTitle,
                                color: ColorBook.accent,
                                font: VPlainButtonModel().font,
                                type: .oneLine
                            )
                        })
                    })
                })
                
                DemoRowView(type: .titled("Clipped Hit Box"), content: {
                    VPlainButton(model: clippedHitBoxButtonModel, state: buttonState, action: action, title: buttonTitle)
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
