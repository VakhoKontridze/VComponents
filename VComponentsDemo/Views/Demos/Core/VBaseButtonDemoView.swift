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
    static let navigationBarTitle: String = "Base Buton"
    
    @State private var clickInstruction: ClickInstruction = .prompt
    private enum ClickInstruction {
        case prompt
        case clicked
        
        var title: String {
            switch self {
            case .prompt: return "Click on circle"
            case .clicked: return "You clicked on circle"
            }
        }
    }
    
    @State private var pressInsturction: PressInstruction = .none
    private enum PressInstruction {
        case none
        case pressed
        
        var title: String {
            switch self {
            case .none: return ""
            case .pressed: return "You are pressing on circle"
            }
        }
        
        var opacity: Double {
            switch self {
            case .none: return 1
            case .pressed: return 0.75
            }
        }
    }
}

// MARK:- Body
extension VBaseButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    VBaseText(
                        title: clickInstruction.title,
                        color: ColorBook.primary,
                        font: .system(size: 16, weight: .semibold, design: .default),
                        type: .oneLine
                    )
                        .frame(height: 20)
                    
                    VBaseButton(isEnabled: true, action: action, onPress: pressAction, content: {
                        Circle()
                            .frame(dimension: 200)
                            .foregroundColor(Color.pink.opacity(pressInsturction.opacity))
                    })
                    
                    VBaseText(
                        title: pressInsturction.title,
                        color: ColorBook.primary,
                        font: .system(size: 16, weight: .semibold, design: .default),
                        type: .oneLine
                    )
                        .frame(height: 20)
                })
            })
        })
    }
}

// MARK:- Actions
private extension VBaseButtonDemoView {
    func action() {
        clickInstruction = .clicked
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { clickInstruction = .prompt })
    }
    
    func pressAction(isPressed: Bool) {
        switch isPressed {
        case false: pressInsturction = .none
        case true: pressInsturction = .pressed
        }
    }
}

// MARK:- Preview
struct VBaseButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseButtonDemoView()
    }
}
