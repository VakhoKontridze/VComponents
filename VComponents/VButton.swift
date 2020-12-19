//
//  VButton.swift
//  Components
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Button
public struct VButton<Content>: View where Content: View {
    // MARK: Properties
    private let state: VButtonState
    
    private let buttonType: VButtonType
    private let viewModel: VButtonViewModel
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        state: VButtonState,
        type buttonType: VButtonType,
        viewModel: VButtonViewModel,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.buttonType = buttonType
        self.viewModel = viewModel
        self.action = action
        self.content = content
    }
}

extension VButton where Content == Text {
    public init<S>(
        state: VButtonState,
        type: VButtonType,
        viewModel: VButtonViewModel,
        action: @escaping () -> Void,
        title: S
    )
        where S: StringProtocol
    {
        self.state = state
        self.buttonType = type
        self.viewModel = viewModel
        self.action = action
        self.content = { Text(title) }
    }
}

// MARK:- Body
public extension VButton {
    var body: some View {
        Button(action: action, label: content)
            .disabled(!state.shouldBeEnabled)
            .buttonStyle(VButtonStyle(state: state, type: buttonType, viewModel: viewModel))
    }
}

// MARK:- Prwview
private struct VButton_Previews: PreviewProvider {
    static var previews: some View {
        VButton(
            state: .enabled, type: .compact, viewModel: .init(),
            action: {},
            title: "Press"
        )
    }
}
