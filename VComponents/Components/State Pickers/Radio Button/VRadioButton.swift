//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Radio Button
/// State picker component that toggles between off, on, or disabled states, and displays content.
///
/// Component can be initialized with without content, title, or content.
///
/// Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
/// Usage example:
///
///     @State var state: VRadioButtonState = .on
///
///     var body: some View {
///         VRadioButton(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///     
public struct VRadioButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VRadioButtonModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let content: VRadioButtonContent<Content>
    
    private var contentIsEnabled: Bool { model.misc.contentIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = .title(title: title)
    }
    
    /// Initializes component with state and content.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = .content(content: content)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>
    )
        where Content == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.content = .empty
    }
    
    /// Initializes component with `Bool` and title.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.content = .title(title: title)
    }
    
    /// Initializes component with `Bool` and content.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = .init(bool: isOn)
        self.content = .content(content: content)
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch content {
        case .empty:
            radioButton
            
        case .title(let title):
            HStack(spacing: 0, content: {
                radioButton
                
                spacer

                VBaseButton(gesture: gestureHandler, content: {
                    VText(
                        type: .multiLine(alignment: .leading, limit: nil),
                        color: model.colors.title.for(internalState),
                        font: model.fonts.title,
                        title: title
                    )
                })
                    .disabled(!contentIsEnabled)
            })
            
        case .content(let content):
            HStack(spacing: 0, content: {
                radioButton
                
                spacer
                
                VBaseButton(gesture: gestureHandler, content: {
                    content()
                        .opacity(model.colors.customContentOpacities.for(internalState))
                })
                    .disabled(!contentIsEnabled)
            })
        }
    }
    
    private var radioButton: some View {
        VBaseButton(gesture: gestureHandler, content: {
            ZStack(content: {
                Circle()
                    .frame(dimension: model.layout.dimension)
                    .foregroundColor(model.colors.fill.for(internalState))
                
                Circle()
                    .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWith)
                    .frame(dimension: model.layout.dimension)
                
                Circle()
                    .frame(dimension: model.layout.bulletDimension)
                    .foregroundColor(model.colors.bullet.for(internalState))
            })
                .frame(dimension: model.layout.dimension)
                .padding(model.layout.hitBox)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var spacer: some View {
        VBaseButton(gesture: gestureHandler, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.contentMarginLeading)
                .foregroundColor(.clear)
        })
            .disabled(!contentIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        withAnimation(model.animations.stateChange, {
            isPressed = gestureState.isPressed
            if gestureState.isClicked { state.setNextState() }
        })
    }
}

// MARK: - Preview
struct VRadioButton_Previews: PreviewProvider {
    @State private static var state: VRadioButtonState = .on

    static var previews: some View {
        VRadioButton(
            state: $state,
            title: "Lorem Ipsum"
        )
    }
}
