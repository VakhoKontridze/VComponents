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
    
    private let buttonTitle: String = "Press"
    
    private func buttonContent() -> some View { VDemoIconContentView(color: ColorBook.primaryInverted) }
    
    @State private var buttonState: VSecondaryButtonState = .enabled
    
    private let borderedModel: VSecondaryButtonModel = {
        let defaultModel: VSecondaryButtonModel = .init()
        
        var model: VSecondaryButtonModel = .init()
        
        model.colors.text.enabled = defaultModel.colors.background.enabled
        model.colors.text.pressed = defaultModel.colors.background.pressed
        model.colors.text.disabled = defaultModel.colors.background.disabled
        
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
        
        model.layout.hitBoxSpacingX = 0
        model.layout.hitBoxSpacingY = 0
        
        return model
    }()
}

// MARK:- Body
extension VSecondaryButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
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
                        
                        Text(buttonTitle)
                            .font(VSecondaryButtonModel().font)
                            .foregroundColor(ColorBook.primaryInverted)
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
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                state: .init(
                    get: { buttonState == .disabled ? .on : .off },
                    set: { buttonState = $0.isOn ? .disabled : .enabled }
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
