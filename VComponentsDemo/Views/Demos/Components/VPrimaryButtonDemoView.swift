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
            biggerHitBoxButton
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
            DemoRowView(type: .titled("Bordered (Continous)"), content: {
                VPrimaryButton(.bordered(), state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Bordered (Dashed)"), content: {
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
    
    private var biggerHitBoxButton: some View {
        let biggerHitBoxButtonModel: VPrimaryButtonFilledModel = .init(
            layout: .init(
                hitBoxExtendX: 20,
                hitBoxExtendY: 20
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Bigger Hit Box"), content: {
                VPrimaryButton(.filled(biggerHitBoxButtonModel), state: buttonState, action: action, title: buttonTitle)
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
