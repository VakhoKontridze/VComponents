//
//  VPrimaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Primary Button Demo View
struct VPrimaryButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Primary Button"
    
    private let buttonTitle: String = "Press"
    
    private func buttonContent() -> some View { VDemoIconContentView(color: ColorBook.primaryInverted) }
    
    @State private var buttonState: VPrimaryButtonState = .enabled
    
    private let borderedModel: VPrimaryButtonModel = {
        let defaultModel: VPrimaryButtonModel = .init()
        
        return .init(
            colors: .init(
                foreground: .init(
                    enabled: defaultModel.colors.background.enabled,
                    pressed: defaultModel.colors.background.pressed,
                    disabled: defaultModel.colors.background.disabled,
                    loading: defaultModel.colors.background.loading
                ),
                background: .init(
                    enabled: .init("PrimaryButtonBordered.Background.enabled"),
                    pressed: .init("PrimaryButtonBordered.Background.pressed"),
                    disabled: .init("PrimaryButtonBordered.Background.disabled"),
                    loading: .init("PrimaryButtonBordered.Background.disabled")
                ),
                border: .init(
                    enabled: defaultModel.colors.background.enabled,
                    pressed: defaultModel.colors.background.disabled,   // It's better this way
                    disabled: defaultModel.colors.background.disabled,
                    loading: defaultModel.colors.background.loading
                )
            )
        )
    }()
}

// MARK:- Body
extension VPrimaryButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            DemoRowView(type: .titled("Text"), content: {
                VPrimaryButton(state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Image"), content: {
                VPrimaryButton(state: buttonState, action: action, content: buttonContent)
            })

            DemoRowView(type: .titled("Image and Text"), content: {
                VPrimaryButton(state: buttonState, action: action, content: {
                    HStack(spacing: 5, content: {
                        buttonContent()
                        Text(buttonTitle)
                    })
                })
            })
            
            DemoRowView(type: .titled("Bordered"), content: {
                VPrimaryButton(model: borderedModel, state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .disabled },
                        set: { buttonState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
                
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .loading },
                        set: { buttonState = $0 ? .loading : .enabled }
                    ),
                    title: "Loading"
                )

                Spacer()
            })
        })
    }
}

// MARK:- Action
private extension VPrimaryButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK:- Preview
struct VPrimaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonDemoView()
    }
}
