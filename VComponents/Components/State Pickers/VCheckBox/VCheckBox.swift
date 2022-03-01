//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - V Check Box
/// State picker component that toggles between off, on, indeterminate, or disabled states, and displays content.
///
/// Component can be initialized with without content, title, or content.
///
/// Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
///     @State var state: VCheckBoxState = .on
///
///     var body: some View {
///         VCheckBox(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///
public struct VCheckBox<Content>: View where Content: View {
    // MARK: Properties
    private let model: VCheckBoxModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let content: VCheckBoxContent<Content>
    
    private var contentIsEnabled: Bool { model.misc.contentIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
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
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = .content(content: content)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VCheckBoxModel = .init(),
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
        model: VCheckBoxModel = .init(),
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
        model: VCheckBoxModel = .init(),
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
            checkBox
            
        case .title(let title):
            HStack(spacing: 0, content: {
                checkBox
                
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
                checkBox
                
                spacer
                
                VBaseButton(gesture: gestureHandler, content: {
                    content()
                        .opacity(model.colors.customContentOpacities.for(internalState))
                })
                    .disabled(!contentIsEnabled)
            })
        }
    }
    
    private var checkBox: some View {
        VBaseButton(gesture: gestureHandler, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                    .foregroundColor(model.colors.fill.for(internalState))
                
                RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                    .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWith)

                if let checkMarkIcon = checkMarkIcon {
                    checkMarkIcon
                        .resizable()
                        .frame(dimension: model.layout.iconDimension)
                        .foregroundColor(model.colors.checkmark.for(internalState))
                }
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

    // MARK: Icon
    private var checkMarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff: return nil
        case .on, .pressedOn: return ImageBook.checkBoxOn
        case .indeterminate, .pressedIndeterminate: return ImageBook.checkBoxInterm
        case .disabled: return nil
        }
    }
}

// MARK: - Preview
struct VCheckBox_Previews: PreviewProvider {
    @State private static var state: VCheckBoxState = .on

    static var previews: some View {
        VCheckBox(
            state: $state,
            title: "Lorem Ipsum"
        )
    }
}
