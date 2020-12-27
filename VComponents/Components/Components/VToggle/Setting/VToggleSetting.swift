//
//  VToggleLeftFlexible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Setting
struct VToggleSetting<Content>: View where Content: View {
    // MARK: Properties
    private let model: VToggleModelSetting
    
    @Binding private var isOn: Bool
    @State private var isPressed: Bool = false
    private let state: VToggleState
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsDisabled: Bool { state.isDisabled || !model.behavior.contentIsClickable }
    private var spaceIsDisabled: Bool { state.isDisabled || !model.behavior.spaceIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    init(
        model: VToggleModelSetting,
        isOn: Binding<Bool>,
        state: VToggleState,
        content: (() -> Content)?
    ) {
        self.model = model
        self._isOn = isOn
        self.state = state
        self.content = content
    }
}

// MARK:- Body
extension VToggleSetting {
    @ViewBuilder var body: some View {
        switch content {
        case nil: toggle
        case let content?: toggle(with: content)
        }
    }
    
    private var toggle: some View {
        VToggleToggleView(
            size: model.layout.size,
            thumbDimension: model.layout.thumbDimension,
            animationOffset: model.layout.animationOffset,
            fillColor: model.colors.fillColor(isOn: isOn, state: internalState),
            thumbColor: model.colors.thumbColor(isOn: isOn, state: internalState),
            isOn: isOn,
            isDisabled: state.isDisabled,
            action: action
        )
    }
    
    private func toggle(with content: @escaping () -> Content) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            VToggleContentView(
                opacity: model.colors.foregroundOpacity(state: internalState),
                isDisabled: contentIsDisabled,
                isPressed: $isPressed,
                action: action,
                content: content
            )
                .layoutPriority(1)

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
private extension VToggleSetting {
    func action() {
        withAnimation(model.behavior.animation, { isOn.toggle() })
    }
}

// MARK:- Preview
struct VToggleSetting_Previews: PreviewProvider {
    @State private static var isOn: Bool = true
    
    static var previews: some View {
        VStack(content: {
            VToggleSetting(
                model: .init(),
                isOn: $isOn,
                state: .enabled,
                content: { Text("Press") }
            )
            
            VToggleSetting(
                model: .init(),
                isOn: $isOn,
                state: .enabled,
                content: { Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit") }
            )
            
            Spacer()
        })
            .padding(20)
    }
}
