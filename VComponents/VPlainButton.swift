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
    private let state: VPlainButtonState

    private let viewModel: VPlainButtonViewModel
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        state: VPlainButtonState,
        viewModel: VPlainButtonViewModel,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.viewModel = viewModel
        self.action = action
        self.content = content
    }
}

public extension VPlainButton where Content == Text {
    init<S>(
        state: VPlainButtonState,
        viewModel: VPlainButtonViewModel,
        action: @escaping () -> Void,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            state: state,
            viewModel: viewModel,
            action: action,
            content: { Text(title) }
        )
    }
}

// MARK:- Body
public extension VPlainButton {
    var body: some View {
        Button(action: action, label: content)
            .disabled(!state.isEnabled)
            .buttonStyle(VPlainButtonStyle(state: state, viewModel: viewModel))
    }
}

// MARK:- Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(state: .enabled, viewModel: .init(), action: {}, title: "Press")
    }
}
