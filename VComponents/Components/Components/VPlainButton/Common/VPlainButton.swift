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
    private let buttonType: VPlainButtonType
    private let state: VPlainButtonState
    private let action: () -> Void
    private let content: () -> Content

    // MARK: Initializers
    public init(
        _ buttonType: VPlainButtonType = .default,
        state: VPlainButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.state = state
        self.action = action
        self.content = content
    }
}

public extension VPlainButton where Content == Text {
    init<S>(
        _ buttonType: VPlainButtonType = .default,
        state: VPlainButtonState = .enabled,
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
public extension VPlainButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .standard(let model): VPlainButtonStandard(model: model, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(action: {}, title: "Press")
    }
}
