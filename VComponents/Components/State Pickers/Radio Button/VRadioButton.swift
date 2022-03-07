//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Radio Button
/// State picker component that toggles between off, on, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
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
public struct VRadioButton<Label>: View where Label: View {
    // MARK: Properties
    private let model: VRadioButtonModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let label: VRadioButtonLabel<Label>
    
    private var labelIsEnabled: Bool { model.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>
    )
        where Label == Never
    {
        self.model = model
        self._state = state
        self.label = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>,
        title: String
    )
        where Label == Never
    {
        self.model = model
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes component with state and label.
    public init(
        model: VRadioButtonModel = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.model = model
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>
    )
        where Label == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.label = .empty
    }
    
    /// Initializes component with `Bool` and title.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Label == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes component with `Bool` and label.
    public init(
        model: VRadioButtonModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.model = model
        self._state = .init(bool: isOn)
        self.label = .custom(label: label)
    }

    // MARK: Body
    public var body: some View {
        Group(content: {
            switch label {
            case .empty:
                radioButton
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    radioButton
                    
                    spacer

                    VBaseButton(gesture: gestureHandler, label: {
                        VText(
                            type: .multiLine(alignment: .leading, limit: nil),
                            color: model.colors.title.for(internalState),
                            font: model.fonts.title,
                            title: title
                        )
                    })
                        .disabled(!labelIsEnabled)
                })
                
            case .custom(let label):
                HStack(spacing: 0, content: {
                    radioButton
                    
                    spacer
                    
                    VBaseButton(gesture: gestureHandler, label: {
                        label()
                            .opacity(model.colors.customLabelOpacities.for(internalState))
                    })
                        .disabled(!labelIsEnabled)
                })
            }
        })
            .animation(model.animations.stateChange, value: internalState)
    }
    
    private var radioButton: some View {
        VBaseButton(gesture: gestureHandler, label: {
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
        VBaseButton(gesture: gestureHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.labelMarginLeading)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
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
