//
//  VPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Primary Button
public struct VPrimaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let state: VPrimaryButtonState
    
    private let buttonType: VPrimaryButtonType
    private let viewModel: VPrimaryButtonViewModel
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        state: VPrimaryButtonState,
        type buttonType: VPrimaryButtonType,
        viewModel: VPrimaryButtonViewModel,
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

extension VPrimaryButton where Content == Text {
    public init<S>(
        state: VPrimaryButtonState,
        type: VPrimaryButtonType,
        viewModel: VPrimaryButtonViewModel,
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
public extension VPrimaryButton {
    var body: some View {
        Button(action: action, label: content)
            .disabled(!state.shouldBeEnabled)
            .buttonStyle(VPrimaryButtonStyle(state: state, type: buttonType, viewModel: viewModel))
    }
}

// MARK:- Preview
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(
            state: .enabled, type: .compact, viewModel: .init(),
            action: {},
            title: "Press"
        )
    }
}
