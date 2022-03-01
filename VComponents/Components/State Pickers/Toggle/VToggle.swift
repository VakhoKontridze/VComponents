//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Toggle
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
///     @State var state: VToggleState = .on
///
///     var body: some View {
///         VToggle(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///
public struct VToggle<Content>: View where Content: View {
    // MARK: Properties
    private let model: VToggleModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VToggleState
    private var internalState: VToggleInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let content: VToggleContent<Content>
    
    private var contentIsEnabled: Bool { model.misc.contentIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
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
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = .content(content: content)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VToggleModel = .init(),
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
        model: VToggleModel = .init(),
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
        model: VToggleModel = .init(),
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
            toggle
            
        case .title(let title):
            HStack(spacing: 0, content: {
                toggle
                
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
                toggle
                
                spacer
                
                VBaseButton(gesture: gestureHandler, content: {
                    content()
                        .opacity(model.colors.customContentOpacities.for(internalState))
                })
                    .disabled(!contentIsEnabled)
            })
        }
    }
    
    private var toggle: some View {
        VBaseButton(gesture: gestureHandler, content: {
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
        VToggle(
            state: $state,
            title: "Lorem Ipsum"
        )
    }
}
