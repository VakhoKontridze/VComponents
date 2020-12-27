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
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(ColorBook.primaryInverted)
    }
    
    @State private var buttonState: VSecondaryButtonState = .enabled
}

// MARK:- Body
extension VSecondaryButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            filledButton
            borderedButton
            imageButtons
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

    private var filledButton: some View {
        VStack(content: {
            DemoRowView(type: .titled("Filled"), content: {
                VSecondaryButton(.filled(), state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var borderedButton: some View {
        let dashedButtonModel: VSecondaryButtonModelBordered = .init(
            layout: .init(
                borderType: .dashed()
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Continous Border"), content: {
                VSecondaryButton(.bordered(), state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Dashed Border"), content: {
                VSecondaryButton(.bordered(dashedButtonModel), state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var imageButtons: some View {
        VStack(content: {
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
        })
    }
    
    private var clippedHitBoxButton: some View {
        let clippedHitBoxButtonModel: VSecondaryButtonModelFilled = .init(
            layout: .init(
                hitBoxSpacingX: 0,
                hitBoxSpacingY: 0
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Clipped Hit Box"), content: {
                VSecondaryButton(.filled(clippedHitBoxButtonModel), state: buttonState, action: action, title: buttonTitle)
            })
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
