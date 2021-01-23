//
//  VSecondaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Secondary Button Demo View
struct VSecondaryButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Secondary Button"
    
    private let buttonTitle: String = "Lorem ipsum"
    
    private func buttonContent() -> some View { DemoIconContentView(color: ColorBook.primaryInverted) }
    
    @State private var buttonState: VSecondaryButtonState = .enabled
    
    private let borderedModel: VSecondaryButtonModel = {
        let defaultModel: VSecondaryButtonModel = .init()
        
        var model: VSecondaryButtonModel = .init()
        
        model.colors.textContent.enabled = defaultModel.colors.background.enabled
        model.colors.textContent.pressed = defaultModel.colors.background.pressed
        model.colors.textContent.disabled = defaultModel.colors.background.disabled
        
        model.colors.background.enabled = .init("PrimaryButtonBordered.Background.enabled")
        model.colors.background.pressed = .init("PrimaryButtonBordered.Background.pressed")
        model.colors.background.disabled = .init("PrimaryButtonBordered.Background.disabled")
        
        model.colors.border.enabled = defaultModel.colors.background.enabled
        model.colors.border.pressed = defaultModel.colors.background.disabled   // It's better this way
        model.colors.border.disabled = defaultModel.colors.background.disabled
        
        return model
    }()
    
    private let clippedHitBoxModel: VSecondaryButtonModel = {
        var model: VSecondaryButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        return model
    }()
}

// MARK:- Body
extension VSecondaryButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Text"), content: {
                    VSecondaryButton(state: buttonState, action: action, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Image"), content: {
                    VSecondaryButton(state: buttonState, action: action, content: buttonContent)
                })

                DemoRowView(type: .titled("Image and Text"), content: {
                    VSecondaryButton(state: buttonState, action: action, content: {
                        HStack(spacing: 5, content: {
                            buttonContent()
                            
                            VText(
                                title: buttonTitle,
                                color: ColorBook.primaryInverted,
                                font: VSecondaryButtonModel.Fonts().title,
                                type: .oneLine
                            )
                        })
                    })
                })
                
                DemoRowView(type: .titled("Bordered"), content: {
                    VSecondaryButton(model: borderedModel, state: buttonState, action: action, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Clipped Hit Box"), content: {
                    VSecondaryButton(model: clippedHitBoxModel, state: buttonState, action: action, title: buttonTitle)
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ControllerToggleView(
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
private extension VSecondaryButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK:- Preview
struct VSecondaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButtonDemoView()
    }
}
