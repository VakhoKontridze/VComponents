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
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var actualState: VPrimaryButtonActualState { state.actualState(isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        _ buttonType: VPrimaryButtonType,
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.state = state
        self.action = action
        self.content = content
    }
}

extension VPrimaryButton where Content == Text {
    public init<S>(
        _ buttonType: VPrimaryButtonType,
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            buttonType,
            state: state,
            action: action,
            content: { Text(title) }
        )
    }
}

// MARK:- Body
public extension VPrimaryButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .compact(let viewModel): VPrimaryButtonCompact(viewModel: viewModel, state: state, action: action, content: content)
        case .fixed(let viewModel): VPrimaryButtonFixed(viewModel: viewModel, state: state, action: action, content: content)
        case .flexible(let viewModel): VPrimaryButtonFlexible(viewModel: viewModel, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(.compact(), state: .enabled, action: {}, title: "Press")
    }
}
