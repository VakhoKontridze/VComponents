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
    
    @Binding private var state: VToggleState
    @State private var isPressed: Bool = false
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsDisabled: Bool { state.isDisabled || !model.behavior.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = content
    }
    
    public init(
        model: VToggleModel = .init(),
        state: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            model: model,
            state: Binding<VToggleState>(bool: state),
            content: content
        )
    }

    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        title: String
    )
        where Content == VBaseTitle
    {
        self.init(
            model: model,
            state: state,
            content: {
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(state: .init(state: state.wrappedValue, isPressed: false)),
                    font: model.font,
                    type: .multiLine(limit: nil, alignment: .leading)
                )
            }
        )
    }
    
    public init(
        model: VToggleModel = .init(),
        state: Binding<Bool>,
        title: String
    )
        where Content == VBaseTitle
    {
        self.init(
            model: model,
            state: state,
            content: {
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(state: .init(bool: state.wrappedValue, isPressed: false)),
                    font: model.font,
                    type: .multiLine(limit: nil, alignment: .leading)
                )
            }
        )
    }

    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = nil
    }
    
    public init(
        model: VToggleModel = .init(),
        state: Binding<Bool>
    )
        where Content == Never
    {
        self.model = model
        self._state = .init(bool: state)
        self.content = nil
    }
}

// MARK:- Body
extension VToggle {
    @ViewBuilder public var body: some View {
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
                    .foregroundColor(model.colors.fillColor(state: internalState))

                Circle()
                    .frame(dimension: model.layout.thumbDimension)
                    .foregroundColor(model.colors.thumbColor(state: internalState))
                    .offset(x: thumbOffset)
            })
                .frame(size: model.layout.size)
        })
    }
    
    private var spacerView: some View {
        VBaseButton(isDisabled: contentIsDisabled, action: action, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.contentMargin)
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

// MARK:- Thumb Position
private extension VToggle {
    var thumbOffset: CGFloat {
        let offset: CGFloat = model.layout.animationOffset
        
        switch internalState {
        case .off: return -offset
        case .on: return offset
        case .pressedOff: return -offset
        case .pressedOn: return offset
        case .disabled: return -offset
        }
    }
}

// MARK:- Action
private extension VToggle {
    func action() {
        withAnimation(model.behavior.animation, { state.nextState() })
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var state: VToggleState = .on

    static var previews: some View {
        VToggle(state: $state, title: "Press")
            .padding()
    }
}
