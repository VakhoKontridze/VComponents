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
        
        return .init(
            colors: .init(
                foreground: .init(
                    enabled: defaultModel.colors.background.enabled,
                    pressed: defaultModel.colors.background.pressed,
                    disabled: defaultModel.colors.background.disabled
                ),
                background: .init(
                    enabled: .init("PrimaryButtonBordered.Background.enabled"),
                    pressed: .init("PrimaryButtonBordered.Background.pressed"),
                    disabled: .init("PrimaryButtonBordered.Background.disabled")
                ),
                border: .init(
                    enabled: defaultModel.colors.background.enabled,
                    pressed: defaultModel.colors.background.pressed,
                    disabled: defaultModel.colors.background.disabled
                )
            )
        )
    }()
    
    private let clippedHitBoxModel: VSecondaryButtonModel = .init(
        layout: .init(
            hitBoxSpacingX: 0,
            hitBoxSpacingY: 0
        )
    )
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
                isOn: .init(
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
