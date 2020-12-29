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
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(ColorBook.primaryInverted)
    }

    @State private var buttonState: VSquareButtonState = .enabled
    
    private let circularModel: VSquareButtonModel = .init(
        layout: .init(
            cornerRadius: VSquareButtonModel.Layout().dimension / 2
        )
    )
    
    private let borderedModel: VSquareButtonModel = {
        let defaultModel: VSquareButtonModel = .init()
        
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
    
    private let largerHitBoxButtonModel: VSquareButtonModel = .init(
        layout: .init(
            hitBoxSpacingX: 10,
            hitBoxSpacingY: 10
        )
    )
}

// MARK:- Body
extension VSquareButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
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
                isOn: .init(
                    get: { buttonState == .disabled },
                    set: { buttonState = $0 ? .disabled : .enabled }
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
