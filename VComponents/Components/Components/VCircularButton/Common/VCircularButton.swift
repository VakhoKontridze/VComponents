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

// MARK:- Body
public extension VCircularButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .standard(let model): VCircularButtonStandard(model: model, state: state, action: action, content: content)
        }
    }
}

// MARK:- Preview
struct VCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButton(action: {}, content: {
            Image(systemName: "swift")
                .resizable()
                .frame(size: .init(width: 20, height: 20))
                .foregroundColor(ColorBook.primaryInverted)
        })
    }
}
