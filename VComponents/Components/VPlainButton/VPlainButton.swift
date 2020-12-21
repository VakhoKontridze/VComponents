//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button
public struct VPlainButton<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VPlainButtonViewModel
    
    private let state: VPlainButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        viewModel: VPlainButtonViewModel = .init(),
        state: VPlainButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.state = state
        self.action = action
        self.content = content
    }
}

public extension VPlainButton where Content == Text {
    init<S>(
        viewModel: VPlainButtonViewModel = .init(),
        state: VPlainButtonState,
        action: @escaping () -> Void,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            viewModel: viewModel,
            state: state,
            action: action,
            content: { Text(title) }
        )
    }
}

// MARK:- Body
public extension VPlainButton {
    var body: some View {
        TouchConatiner(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .padding(.horizontal, viewModel.layout.hitAreaOffsetHor)
                .padding(.vertical, viewModel.layout.hitAreaOffsetVer)
                
                // Text
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .foregroundColor(viewModel.colors.foregroundColor(state: internalState))
                .font(viewModel.fonts.title)
            
                // Text + Image
                .opacity(viewModel.colors.foregroundOpacity(state: internalState))
        })
    }
}

// MARK:- Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(state: .enabled, action: {}, title: "Press")
    }
}
