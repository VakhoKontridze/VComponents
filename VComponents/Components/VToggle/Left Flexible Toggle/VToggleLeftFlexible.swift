//
//  VToggleLeftFlexible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- VToggleLeftFlexibleContent
struct VToggleLeftFlexibleContent<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VToggleLeftFlexibleContentViewModel
    
    @Binding private var isOn: Bool
    @State private var isPressed: Bool = false
    private let state: VToggleState
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsDisabled: Bool { state.isDisabled || !viewModel.behavior.contentIsClickable }
    private var spaceIsDisabled: Bool { state.isDisabled || !viewModel.behavior.spaceIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    init(
        viewModel: VToggleLeftFlexibleContentViewModel,
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
extension VToggleLeftFlexibleContent {
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
            VToggleContentView(
                opacity: viewModel.colors.contentDisabledOpacity(state: internalState),
                isDisabled: contentIsDisabled,
                isPressed: $isPressed,
                action: action,
                content: content
            )
            
            VToggleSpacerView(
                width: nil,
                isDisabled: spaceIsDisabled,
                action: action
            )
            
            toggle
        })
    }
}

// MARK:- Action
private extension VToggleLeftFlexibleContent {
    func action() {
        withAnimation(viewModel.behavior.animation, { isOn.toggle() })
    }
}

// MARK:- Preview
struct VToggleLeftFlexibleContent_Previews: PreviewProvider {
    @State private static var isOn: Bool = true
    
    static var previews: some View {
        VToggleLeftFlexibleContent(
            viewModel: .init(),
            isOn: $isOn,
            state: .enabled,
            content: { Text("Press") }
        )
    }
}
