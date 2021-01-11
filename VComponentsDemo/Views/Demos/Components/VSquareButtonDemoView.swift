//
//  VSquareButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Square Button Demo View
struct VSquareButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Square Button"
    
    private let buttonTitle: String = "Press"
    
    private func buttonContent() -> some View { VDemoIconContentView(color: ColorBook.primaryInverted) }

    @State private var buttonState: VSquareButtonState = .enabled
    
    private let circularModel: VSquareButtonModel = {
        var model: VSquareButtonModel = .init()
        
        model.layout.cornerRadius = VSquareButtonModel.Layout().dimension / 2
        
        return model
    }()

    private let borderedModel: VSquareButtonModel = {
        let defaultModel: VSquareButtonModel = .init()
        
        var model: VSquareButtonModel = .init()
        
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
    
    
    private let largerHitBoxButtonModel: VSquareButtonModel = {
        var model: VSquareButtonModel = .init()
        
        model.layout.hitBoxSpacingX = 10
        model.layout.hitBoxSpacingY = 10
        
        return model
    }()
}

// MARK:- Body
extension VSquareButtonDemoView {
    var body: some View {
        DemoView(title: Self.navigationBarTitle, controller: controller, content: {
            DemoRowView(type: .titled("Text"), content: {
                VSquareButton(state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Image"), content: {
                VSquareButton(state: buttonState, action: action, content: buttonContent)
            })

            DemoRowView(type: .titled("Image and Text"), content: {
                VSquareButton(state: buttonState, action: action, content: {
                    HStack(spacing: 5, content: {
                        buttonContent()
                        
                        Text("A")
                            .font(VSquareButtonModel().font)
                            .foregroundColor(ColorBook.primaryInverted)
                    })
                })
            })
            
            DemoRowView(type: .titled("Cirular"), content: {
                VSquareButton(model: circularModel, state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Bordered"), content: {
                VSquareButton(model: borderedModel, state: buttonState, action: action, title: buttonTitle)
            })
            
            DemoRowView(type: .titled("Larger Hit Box"), content: {
                VSquareButton(model: largerHitBoxButtonModel, state: buttonState, action: action, title: buttonTitle)
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
    
//    private var shapeButtons: some View {
//        let roundedButtonModel: VSquareButtonModelFilled = .init(
//            layout: .init(
//                frame: .rounded()
//            )
//        )
//        
//        return VStack(content: {
//            DemoRowView(type: .titled("Circular"), content: {
//                VSquareButton(state: buttonState, action: action, title: buttonTitle)
//            })
//            
//            DemoRowView(type: .titled("Rounded"), content: {
//                VSquareButton(.filled(roundedButtonModel), state: buttonState, action: action, title: buttonTitle)
//            })
//        })
//    }
//
//    private var filledButton: some View {
//        VStack(content: {
//            DemoRowView(type: .titled("Filled"), content: {
//                VSquareButton(.filled(), state: buttonState, action: action, title: buttonTitle)
//            })
//        })
//    }
//    
//    private var borderedButton: some View {
//        let dashedButtonModel: VSquareButtonModel = .init(
//            layout: .init(
//                borderType: .dashed()
//            )
//        )
//        
//        return VStack(content: {
//            DemoRowView(type: .titled("Continous Border"), content: {
//                VSquareButton(.bordered(), state: buttonState, action: action, title: buttonTitle)
//            })
//            
//            DemoRowView(type: .titled("Dashed Border"), content: {
//                VSquareButton(.bordered(dashedButtonModel), state: buttonState, action: action, title: buttonTitle)
//            })
//        })
//    }
//    
//    private var imageButtons: some View {
//        VStack(content: {
//            DemoRowView(type: .titled("Image"), content: {
//                VSquareButton(state: buttonState, action: action, content: buttonContent)
//            })
//
//            DemoRowView(type: .titled("Image and Text"), content: {
//                VSquareButton(state: buttonState, action: action, content: {
//                    HStack(spacing: 5, content: {
//                        buttonContent()
//                        Text("A")
//                    })
//                })
//            })
//        })
//    }
//    
//    private var largerHitBoxButton: some View {
//        let largerHitBoxButtonModel: VSquareButtonModelFilled = .init(
//            layout: .init(
//                hitBoxSpacingX: 20,
//                hitBoxSpacingY: 20
//            )
//        )
//        
//        return VStack(content: {
//            DemoRowView(type: .titled("Larger Hit Box"), content: {
//                VSquareButton(.filled(largerHitBoxButtonModel), state: buttonState, action: action, title: buttonTitle)
//            })
//        })
//    }
}

// MARK:- Action
private extension VSquareButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VSquareButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSquareButtonDemoView()
    }
}
