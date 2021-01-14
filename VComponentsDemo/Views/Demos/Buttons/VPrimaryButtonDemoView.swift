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
    
    private func buttonContent() -> some View { VDemoIconContentView(dimension: 20, color: ColorBook.primaryInverted) }
    
    @State private var buttonState: VPrimaryButtonState = .enabled
    
    private let borderedModel: VPrimaryButtonModel = {
        let defaultModel: VPrimaryButtonModel = .init()
        
        var model: VPrimaryButtonModel = .init()
        
        model.colors.text.enabled = defaultModel.colors.background.enabled
        model.colors.text.pressed = defaultModel.colors.background.pressed
        model.colors.text.disabled = defaultModel.colors.background.disabled
        model.colors.text.loading = defaultModel.colors.background.loading
        
        model.colors.background.enabled = .init("PrimaryButtonBordered.Background.enabled")
        model.colors.background.pressed = .init("PrimaryButtonBordered.Background.pressed")
        model.colors.background.disabled = .init("PrimaryButtonBordered.Background.disabled")
        model.colors.background.loading = .init("PrimaryButtonBordered.Background.disabled")
        
        model.colors.border.enabled = defaultModel.colors.background.enabled
        model.colors.border.pressed = defaultModel.colors.background.disabled   // It's better this way
        model.colors.border.disabled = defaultModel.colors.background.disabled
        model.colors.border.loading = defaultModel.colors.background.loading
        
        return model
    }()
}

// MARK:- Body
extension VPrimaryButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
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
                            
                            VBaseTitle(
                                title: buttonTitle,
                                color: ColorBook.primaryInverted,
                                font: VPrimaryButtonModel().font,
                                type: .oneLine
                            )
                        })
                    })
                })
                
                DemoRowView(type: .titled("Bordered"), content: {
                    VPrimaryButton(model: borderedModel, state: buttonState, action: action, title: buttonTitle)
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                
                ToggleSettingView(
                    state: .init(
                        get: { buttonState == .disabled },
                        set: { buttonState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )

                Spacer()
                
                ToggleSettingView(
                    state: .init(
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
