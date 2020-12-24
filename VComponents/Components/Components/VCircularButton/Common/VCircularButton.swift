//
//  VCircularButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button
public struct VCircularButton<Content>: View where Content: View {
    // MARK: Properties
    private let buttonType: VCircularButtonType
    private let state: VCircularButtonState
    private let action: () -> Void
    private let content: () -> Content

    // MARK: Initializers
    public init(
        _ buttonType: VCircularButtonType = .default,
        state: VCircularButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.state = state
        self.action = action
        self.content = content
    }
}

extension VCircularButton where Content == Text {
    public init<S>(
        _ buttonType: VCircularButtonType = .default,
        state: VCircularButtonState = .enabled,
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
public extension VCircularButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .filled(let model): VCircularButtonFilled(model: model, state: state, action: action, content: content)
        case .bordered(let model): VCircularButtonBordered(model: model, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VCircularButtonFilled_Previews.previews
            VCircularButtonBordered_Previews.previews
        })
            .padding()
    }
}
