//
//  VInteractiveViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Interactive View Demo View
struct VInteractiveViewDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Interactive View"
    
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
extension VInteractiveViewDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            ZStack(content: {
                VComponents.ColorBook.layer.edgesIgnoringSafeArea(.bottom)
                interactiveView
            })
        })
    }
    
    private var interactiveView: some View {
        VStack(spacing: 20, content: {
            Text(clickInstruction.title)
                .fontWeight(.semibold)
                .frame(height: 20)
            
            VInteractiveView(isDisabled: false, action: action, onPress: pressAction, content: {
                Circle()
                    .frame(dimension: 200)
                    .foregroundColor(Color.pink.opacity(pressInsturction.opacity))
            })
            
            Text(pressInsturction.title)
                .fontWeight(.semibold)
                .frame(height: 20)
        })
    }
}

// MARK:- Actions
private extension VInteractiveViewDemoView {
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
struct VInteractiveViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VInteractiveViewDemoView()
    }
}
