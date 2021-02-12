//
//  VBaseButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Base Button Demo View
struct VBaseButtonDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Base Buton"
    
    @State private var clickState: ClickState = .prompt
    @State private var pressState: PressState = .none
}

// MARK:- Body
extension VBaseButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component)
        })
    }
    
    private func component() -> some View {
        ZStack(content: {
            textView(title: clickState.promptDescription, color: ColorBook.primary)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 15)
            
            VStack(spacing: 20, content: {
                textView(title: clickState.description, color: ColorBook.secondary)
                
                VBaseButton(isEnabled: true, action: action, onPress: pressAction, content: {
                    Circle()
                        .frame(dimension: 200)
                        .foregroundColor(Color.pink.opacity(pressState.buttonOpacity))
                })
                
                textView(title: pressState.description, color: ColorBook.secondary)
            })
        })
    }
    
    private func textView(title: String, color: Color) -> some View {
        VText(
            type: .oneLine,
            font: .system(size: 16, weight: .semibold),
            color: color,
            title: title
        )
            .frame(height: 20)
    }
}

// MARK:- Actions
private extension VBaseButtonDemoView {
    func action() {
        clickState = .clicked
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { clickState = .prompt })
    }
    
    func pressAction(isPressed: Bool) {
        switch isPressed {
        case false: pressState = .none
        case true: pressState = .pressed
        }
    }
}

// MARK:- Helpers
private enum ClickState {
    case prompt
    case clicked
    
    var promptDescription: String {
        "Click on circle"
    }
    
    var description: String {
        switch self {
        case .prompt: return ""
        case .clicked: return "You clicked on circle"
        }
    }
}

private enum PressState {
    case none
    case pressed
    
    var description: String {
        switch self {
        case .none: return ""
        case .pressed: return "You are pressing on circle"
        }
    }
    
    var buttonOpacity: Double {
        switch self {
        case .none: return 1
        case .pressed: return 0.75
        }
    }
}

// MARK:- Preview
struct VBaseButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseButtonDemoView()
    }
}
