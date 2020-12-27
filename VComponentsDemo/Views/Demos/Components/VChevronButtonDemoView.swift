//
//  VChevronButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Chevron Button Demo View
struct VChevronButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Chevron Button"

    @State private var buttonState: VChevronButtonState = .enabled
}

// MARK:- Body
extension VChevronButtonDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            filledButtons
            plainButtons
            largerHitBoxButton
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
    
    private var filledButtons: some View {
        VStack(content: {
            DemoRowView(type: .titled("Filled Up"), content: {
                VChevronButton(.filled(), direction: .up, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Filled Right"), content: {
                VChevronButton(.filled(), direction: .right, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Filled Down"), content: {
                VChevronButton(.filled(), direction: .down, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Filled Left"), content: {
                VChevronButton(.filled(), direction: .left, state: buttonState, action: action)
            })
        })
    }
    
    private var plainButtons: some View {
        VStack(content: {
            DemoRowView(type: .titled("Plain Up"), content: {
                VChevronButton(.plain(), direction: .up, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Plain Right"), content: {
                VChevronButton(.plain(), direction: .right, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Plain Down"), content: {
                VChevronButton(.plain(), direction: .down, state: buttonState, action: action)
            })
            
            DemoRowView(type: .titled("Plain Left"), content: {
                VChevronButton(.plain(), direction: .left, state: buttonState, action: action)
            })
        })
    }
    
    private var largerHitBoxButton: some View {
        let largerHitBoxButtonModel: VChevronButtonModelFilled = .init(
            layout: .init(
                hitBoxSpacingX: 5,
                hitBoxSpacingY: 5
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Larger Hit Box"), content: {
                VChevronButton(.filled(largerHitBoxButtonModel), direction: .left, state: buttonState, action: action)
            })
        })
    }
}

// MARK:- Action
private extension VChevronButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VChevronButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VChevronButtonDemoView()
    }
}
