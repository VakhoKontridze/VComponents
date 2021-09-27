//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Toggle
/// State picker component that toggles between off, on, or disabled states, and displays content
///
/// Component can be initialized with content, title, or without body. Bool can also be passed as state.
///
/// Model can be passed as parameter
///
/// # Usage Example #
///
/// ```
/// @State var state: VToggleState = .on
///
/// var body: some View {
///     VToggle(
///         state: $state,
///         title: "Lorem ipsum"
///     )
/// }
/// ```
///
public struct VToggle<Content>: View where Content: View {
    // MARK: Properties
    private let model: VToggleModel
    
    @Binding private var state: VToggleState
    @State private var animatableState: VToggleState?
    @State private var isPressed: Bool = false
    private var internalState: VToggleInternalState { .init(state: animatableState ?? state, isPressed: isPressed) }
    private var contentIsEnabled: Bool { state.isEnabled && model.misc.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers - State
    /// Initializes component with state and content
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = content
    }

    /// Initializes component with state and title
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        title: String
    )
        where Content == VText
    {
        self.init(
            model: model,
            state: state,
            content: {
                VText(
                    type: .multiLine(limit: nil, alignment: .leading),
                    font: model.fonts.title,
                    color: model.colors.textContent.for(.init(state: state.wrappedValue, isPressed: false)),
                    title: title
                )
            }
        )
    }
    
    /// Initializes component with state
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
    
    // MARK: Initializers - Bool
    /// Initializes component with bool and content
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            model: model,
            state: Binding<VToggleState>(bool: isOn),
            content: content
        )
    }

    /// Initializes component with bool and title
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Content == VText
    {
        self.init(
            model: model,
            state: .init(bool: isOn),
            content: {
                VText(
                    type: .multiLine(limit: nil, alignment: .leading),
                    font: model.fonts.title,
                    color: model.colors.textContent.for(VRadioButtonInternalState(bool: isOn.wrappedValue, isPressed: false)),
                    title: title
                )
            }
        )
    }
    
    /// Initializes component with bool
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>
    )
        where Content == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.content = nil
    }

    // MARK: Body
    public var body: some View {
        performStateSets()
        
        return Group(content: {
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
        })
    }
    
    private var toggle: some View {
        VBaseButton(isEnabled: state.isEnabled, action: nextState, onPress: { _ in }, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                    .foregroundColor(model.colors.fill.for(internalState))

                Circle()
                    .frame(dimension: model.layout.thumbDimension)
                    .foregroundColor(model.colors.thumb.for(internalState))
                    .offset(x: thumbOffset)
            })
                .frame(size: model.layout.size)
        })
    }
    
    private var spacerView: some View {
        VBaseButton(isEnabled: contentIsEnabled, action: nextState, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.contentMarginLeading)
                .foregroundColor(ColorBook.clear)
        })
    }
    
    private func contentView(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VBaseButton(isEnabled: contentIsEnabled, action: nextState, onPress: { isPressed = $0 }, content: {
            content()
                .opacity(model.colors.content.for(internalState))
        })
    }

    // MARK: State Sets
    private func performStateSets() {
        DispatchQueue.main.async(execute: {
            setAnimatableState()
        })
    }

    // MARK: Actions
    private func nextState() {
        withAnimation(model.animations.stateChange, { animatableState?.nextState() })
        state.nextState()
    }
    
    private func setAnimatableState() {
        if animatableState == nil || animatableState != state {
            withAnimation(model.animations.stateChange, { animatableState = state })
        }
    }

    // MARK: Thumb Position
    private var thumbOffset: CGFloat {
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

// MARK: - Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var state: VToggleState = .on

    static var previews: some View {
        VToggle(state: $state, title: "Lorem ipsum")
    }
}
