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
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(ColorBook.primaryInverted)
    }
    
    @State private var buttonState: VPrimaryButtonState = .enabled
}

// MARK:- Body
extension VPrimaryButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            filledButton
            borderedButton
            imageButtons
            largerHitBoxButton
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

    private var filledButton: some View {
        VStack(content: {
            DemoRowView(type: .titled("Filled"), content: {
                VPrimaryButton(.filled(), state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var borderedButton: some View {
        let dashedButtonModel: VPrimaryButtonBorderedModel = .init(
            layout: .init(
                borderType: .dashed()
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Continous Border"), content: {
                VPrimaryButton(.bordered(), state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Dashed Border"), content: {
                VPrimaryButton(.bordered(dashedButtonModel), state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var imageButtons: some View {
        VStack(content: {
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
        })
    }
    
    private var largerHitBoxButton: some View {
        let largerHitBoxButtonModel: VPrimaryButtonFilledModel = .init(
            layout: .init(
                hitBoxSpacingX: 20,
                hitBoxSpacingY: 20
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Larger Hit Box"), content: {
                VPrimaryButton(.filled(largerHitBoxButtonModel), state: buttonState, action: action, title: buttonTitle)
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
