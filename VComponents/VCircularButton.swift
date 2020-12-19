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
    private let state: VCircularButtonState
    
    private let viewModel: VCircularButtonViewModel
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        state: VCircularButtonState,
        viewModel: VCircularButtonViewModel,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.viewModel = viewModel
        self.action = action
        self.content = content
    }
}

// MARK:- Body
public extension VCircularButton {
    var body: some View {
        Button(action: action, label: content)
            .disabled(!state.shouldBeEnabled)
            .buttonStyle(VCircularButtonStyle(state: state, viewModel: viewModel))
    }
}

// MARK:- Preview
struct VCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButton(
            state: .enabled, viewModel: .init(),
            action: {},
            content: {
                Image(systemName: "swift")
                    .resizable()
                    .frame(size: .init(width: 20, height: 20))
                    .foregroundColor(.white)
            }
        )
    }
}
