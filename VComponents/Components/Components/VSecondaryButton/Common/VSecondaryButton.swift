//
//  VSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button
public struct VSecondaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let buttonType: VSecondaryButtonType
    private let state: VSecondaryButtonState
    private let action: () -> Void
    private let content: () -> Content

    // MARK: Initializers
    public init(
        _ buttonType: VSecondaryButtonType = .default,
        state: VSecondaryButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.state = state
        self.action = action
        self.content = content
    }
}

extension VSecondaryButton where Content == Text {
    public init<S>(
        _ buttonType: VSecondaryButtonType = .default,
        state: VSecondaryButtonState = .enabled,
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
public extension VSecondaryButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .filled(let model): VSecondaryButtonFilled(model: model, state: state, action: action, content: content)
        case .bordered(let model): VSecondaryButtonBordered(model: model, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VSecondaryButtonFilled_Previews.previews
            VSecondaryButtonBordered_Previews.previews
        })
            .padding()
    }
}
