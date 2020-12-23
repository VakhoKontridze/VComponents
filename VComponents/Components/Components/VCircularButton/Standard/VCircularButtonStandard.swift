//
//  VCircularButtonStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Circular Button Standard
struct VCircularButtonStandard<Content>: View where Content: View {
    // MARK: Properties
    private let model: VCircularButtonStandardModel
    
    private let state: VCircularButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCircularButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VCircularButtonStandardModel,
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
extension VCircularButtonStandard {
    var body: some View {
        VInteractiveView(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
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
struct VCircularButtonStandard_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButtonStandard(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
