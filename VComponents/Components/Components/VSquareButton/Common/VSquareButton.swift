//
//  VSquareButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Square Button
public struct VSquareButton<Content>: View where Content: View {
    // MARK: Properties
    private let buttonType: VSquareButtonType
    private let state: VSquareButtonState
    private let action: () -> Void
    private let content: () -> Content

    // MARK: Initializers
    public init(
        _ buttonType: VSquareButtonType = .default,
        state: VSquareButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.state = state
        self.action = action
        self.content = content
    }

    public init<S>(
        _ buttonType: VSquareButtonType = .default,
        state: VSquareButtonState = .enabled,
        action: @escaping () -> Void,
        title: S
    )
        where
            Content == Text,
            S: StringProtocol
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
public extension VSquareButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .filled(let model): VSquareButtonFilled(model: model, state: state, action: action, content: content)
        case .bordered(let model): VSquareButtonBordered(model: model, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VSquareButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VSquareButtonFilled_Previews.previews
            VSquareButtonBordered_Previews.previews
        })
            .padding()
    }
}
