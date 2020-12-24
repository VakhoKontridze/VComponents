//
//  VPlainButtonStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Plain Button Standard
struct VPlainButtonStandard<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPlainButtonStandardModel
    
    private let state: VPlainButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        model: VPlainButtonStandardModel,
        state: VPlainButtonState,
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
extension VPlainButtonStandard {
    var body: some View {
        VInteractiveView(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .padding(.horizontal, model.layout.hitBoxExtendX)
                .padding(.vertical, model.layout.hitBoxExtendY)
                
                // Text
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .foregroundColor(model.colors.foregroundColor(state: internalState))
                .font(model.fonts.title)
            
                // Text + Image
                .opacity(model.colors.foregroundOpacity(state: internalState))
        })
    }
}

// MARK:- Preview
struct VPlainButtonStandard_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonStandard(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
