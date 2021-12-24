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
/// Component can be initialized with content, title, or without body. `Bool` can also be passed as state.
///
/// Model can be passed as parameter.
///
/// Usage example:
///
///     @State var state: VCheckBoxState = .on
///
///     var body: some View {
///         VCheckBox(
///             state: $state,
///             title: "Lorem ipsum"
///         )
///     }
///
public struct VCheckBox<Content>: View where Content: View {
    // MARK: Properties
    private let model: VCheckBoxModel
    
    @Binding private var state: VCheckBoxState
    @State private var internalStateRaw: VCheckBoxInternalState?
    private var internalState: VCheckBoxInternalState { internalStateRaw ?? .default(state: state) }
    
    private let content: (() -> Content)?
    
    private var contentIsEnabled: Bool { internalState.isEnabled && model.misc.contentIsClickable }
    
    // MARK: Initializers - State
    /// Initializes component with state and content.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = content
    }

    /// Initializes component with state and title.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
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
    
    /// Initializes component with state.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = nil
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with bool and content.
    public init(
        model: VCheckBoxModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            model: model,
            state: Binding<VCheckBoxState>(bool: isOn),
            content: content
        )
    }

    /// Initializes component with bool and title.
    public init(
        model: VCheckBoxModel = .init(),
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
                    color: model.colors.textContent.for(.init(bool: isOn.wrappedValue, isPressed: false)),
                    title: title
                )
            }
        )
    }

    /// Initializes component with bool.
    public init(
        model: VCheckBoxModel = .init(),
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
        syncInternalStateWithState()
        
        return Group(content: {
            switch content {
            case nil:
                checkBox
                
            case let content?:
                HStack(spacing: 0, content: {
                    checkBox
                    spacerView
                    contentView(content: content)
                })
            }
        })
    }
    
    private var checkBox: some View {
        VBaseButton(
            isEnabled: internalState.isEnabled,
            gesture: gestureHandler,
            content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                        .foregroundColor(model.colors.fill.for(internalState))
                    
                    RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                        .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWith)

                    if let icon = icon {
                        icon
                            .resizable()
                            .frame(dimension: model.layout.iconDimension)
                            .foregroundColor(model.colors.icon.for(internalState))
                    }
                })
                    .frame(dimension: model.layout.dimension)
                    .padding(model.layout.hitBox)
            }
        )
    }
    
    private var spacerView: some View {
        VBaseButton(
            isEnabled: contentIsEnabled,
            gesture: gestureHandler,
            content: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: model.layout.contentMarginLeading)
                    .foregroundColor(.clear)
            }
        )
    }
    
    private func contentView(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VBaseButton(
            isEnabled: contentIsEnabled,
            gesture: gestureHandler,
            content: {
                content()
                    .opacity(model.colors.content.for(internalState))
            }
        )
    }

    // MARK: State Syncs
    private func syncInternalStateWithState() {
        DispatchQueue.main.async(execute: {
            if
                internalStateRaw == nil ||
                .init(internalState: internalState) != state
            {
                withAnimation(model.animations.stateChange, { internalStateRaw = .default(state: state) })
            }
        })
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        switch gestureState.isClicked {
        case false:
            internalStateRaw = .init(state: state, isPressed: gestureState.isPressed)

        case true:
            state.setNextState()
            withAnimation(model.animations.stateChange, { internalStateRaw?.setNextState() })
        }
    }

    // MARK: Icon
    private var icon: Image? {
        switch state {
        case .off: return nil
        case .on: return ImageBook.checkBoxOn
        case .indeterminate: return ImageBook.checkBoxInterm
        case .disabled: return nil
        }
    }
}

// MARK: - Preview
struct VCheckBox_Previews: PreviewProvider {
    @State private static var state: VCheckBoxState = .on

    static var previews: some View {
        VCheckBox(state: $state, title: "Lorem ipsum")
    }
}
