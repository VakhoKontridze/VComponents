//
//  VToggleRightContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- VToggleRightContent
struct VToggleRightContent<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VToggleRightContentViewModel
    
    @Binding private var isOn: Bool
    @State private var isPressed: Bool = false
    private let state: VToggleState
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsDisabled: Bool { state.isDisabled || !viewModel.behavior.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    init(
        viewModel: VToggleRightContentViewModel,
        isOn: Binding<Bool>,
        state: VToggleState,
        content: (() -> Content)?
    ) {
        self.viewModel = viewModel
        self._isOn = isOn
        self.state = state
        self.content = content
    }
}

// MARK:- Body
extension VToggleRightContent {
    @ViewBuilder var body: some View {
        switch content {
        case nil: toggle
        case let content?: toggle(with: content)
        }
    }
    
    private var toggle: some View {
        VToggleToggleView(
            size: viewModel.layout.size,
            thumbDimension: viewModel.layout.thumbDimension,
            animationOffset: viewModel.layout.animationOffset,
            fillColor: viewModel.colors.fillColor(isOn: isOn, state: internalState),
            thumbColor: viewModel.colors.thumbColor(isOn: isOn, state: internalState),
            isOn: isOn,
            isDisabled: state.isDisabled,
            action: action
        )
    }
    
    private func toggle(with content: @escaping () -> Content) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            toggle
            
            VToggleSpacerView(
                width: viewModel.layout.contentSpacing,
                isDisabled: contentIsDisabled,
                action: action
            )
            
            VToggleContentView(
                opacity: viewModel.colors.contentDisabledOpacity(state: internalState),
                isDisabled: contentIsDisabled,
                isPressed: $isPressed,
                action: action,
                content: content
            )
        })
    }
}

// MARK:- Action
private extension VToggleRightContent {
    func action() {
        withAnimation(viewModel.behavior.animation, { isOn.toggle() })
    }
}

// MARK:- Preview
struct VToggleRightContent_Previews: PreviewProvider {
    @State private static var isOn: Bool = true
    
    static var previews: some View {
        VToggleRightContent(
            viewModel: .init(),
            isOn: $isOn,
            state: .enabled,
            content: { Text("Press") }
        )
    }
}
