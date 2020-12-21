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
    private let model: VCircularButtonModel
    
    private let state: VCircularButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCircularButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        model: VCircularButtonModel = .init(),
        state: VCircularButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
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
                .frame(dimension: model.layout.dimension)
                
                // Text
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .foregroundColor(model.colors.foregroundColor(state: internalState))
                .font(model.fonts.title)
            
                // Text + Image
                .opacity(model.colors.foregroundOpacity(state: internalState))
            
                .background(
                    Circle()
                        .foregroundColor(model.colors.backgroundColor(state: internalState))
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
