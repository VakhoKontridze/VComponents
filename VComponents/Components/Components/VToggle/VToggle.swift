//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Toggle
public struct VToggle<Content>: View where Content: View {
    // MARK: Properties
    private let model: VToggleModel
    
    @Binding private var isOn: Bool
    @State private var isPressed: Bool = false
    private let state: VToggleState
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsDisabled: Bool { state.isDisabled || !model.behavior.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState = .enabled,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._isOn = isOn
        self.state = state
        self.content = content
    }

    public init<S>(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState = .enabled,
        title: S
    )
        where
            Content == Text,
            S: StringProtocol
    {
        self.init(
            model: model,
            isOn: isOn,
            state: state,
            content: {
                Text(title)
                    .foregroundColor(model.colors.textColor(
                        isOn: isOn.wrappedValue,
                        state: .init(state: state, isPressed: false)
                    ))
                    .font(model.font)
            }
        )
    }

    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState = .enabled
    )
        where Content == Never
    {
        self.model = model
        self._isOn = isOn
        self.state = state
        self.content = nil
    }
}

// MARK:- Body
public extension VToggle {
    @ViewBuilder var body: some View {
        switch content {
        case nil:
            toggle
            
        case let content?:
            HStack(spacing: 0, content: {
                toggle
                spacerView
                contentView(content: content)
            })
        }
    }
    
    private var toggle: some View {
        VBaseButton(isDisabled: state.isDisabled, action: action, onPress: { _ in }, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: model.layout.size.height)
                    .foregroundColor(model.colors.fillColor(isOn: isOn, state: internalState))

                Circle()
                    .frame(dimension: model.layout.thumbDimension)
                    .foregroundColor(model.colors.thumbColor(isOn: isOn, state: internalState))
                    .offset(x: isOn ? model.layout.animationOffset : -model.layout.animationOffset)
            })
                .frame(size: model.layout.size)
        })
    }
    
    private var spacerView: some View {
        VBaseButton(isDisabled: contentIsDisabled, action: action, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .ifLet(model.layout.contentSpacing, transform: { $0.frame(width: $1) })
                .foregroundColor(.clear)
        })
    }
    
    private func contentView(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VBaseButton(isDisabled: contentIsDisabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .opacity(model.colors.contentOpacity(state: internalState))
        })
    }
}

// MARK:- Action
private extension VToggle {
    func action() {
        withAnimation(model.behavior.animation, { isOn.toggle() })
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var isOn: Bool = true

    static var previews: some View {
        VToggle(isOn: $isOn, title: "Press")
            .padding()
    }
}
