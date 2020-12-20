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
    private let buttonType: VPrimaryButtonType
    private let viewModel: VPrimaryButtonViewModel
    
    private let state: VPrimaryButtonState
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    private init(
        _ buttonType: VPrimaryButtonType,
        viewModel: VPrimaryButtonViewModel = .init(),
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.viewModel = viewModel
        self.state = state
        self.action = action
        self.content = content
    }
}

extension VPrimaryButton where Content == Text {
    public init<S>(
        _ buttonType: VPrimaryButtonType,
        viewModel: VPrimaryButtonViewModel = .init(),
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            buttonType,
            viewModel: viewModel,
            state: state,
            action: action,
            content: { Text(title) }
        )
    }
}

// MARK:- Body
public extension VPrimaryButton {
    var body: some View {
        Button(action: action, label: content)
            .disabled(!state.isEnabled)
            .buttonStyle(VPrimaryButtonStyle(state: state, type: buttonType, viewModel: viewModel))
    }
}

// MARK:- Preview
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(.compact, state: .enabled, action: {}, title: "Press")
    }
}
