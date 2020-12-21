//
//  VCircularButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button
public struct VCircularButton<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VCircularButtonViewModel
    
    private let state: VCircularButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCircularButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        viewModel: VCircularButtonViewModel = .init(),
        state: VCircularButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.state = state
        self.action = action
        self.content = content
    }
}

// MARK:- Body
public extension VCircularButton {
    var body: some View {
        TouchConatiner(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .frame(dimension: viewModel.layout.dimension)
                
                // Text
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .foregroundColor(viewModel.colors.foregroundColor(state: internalState))
                .font(viewModel.fonts.title)
            
                // Text + Image
                .opacity(viewModel.colors.foregroundOpacity(state: internalState))
            
                .background(
                    Circle()
                        .foregroundColor(viewModel.colors.backgroundColor(state: internalState))
                )
        })
    }
}

// MARK:- Preview
struct VCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButton(state: .enabled, action: {}, content: {
            Image(systemName: "swift")
                .resizable()
                .frame(size: .init(width: 20, height: 20))
                .foregroundColor(.white)
        })
    }
}
