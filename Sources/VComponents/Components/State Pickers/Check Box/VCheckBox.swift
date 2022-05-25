//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - V Check Box
/// State picker component that toggles between off, on, indeterminate, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
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
public struct VCheckBox<Label>: View where Label: View {
    // MARK: Properties
    private let model: VCheckBoxModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let label: VCheckBoxLabel<Label>
    
    private var labelIsEnabled: Bool { model.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Label == Never
    {
        self.model = model
        self._state = state
        self.label = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
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
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.model = model
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VCheckBoxModel = .init(),
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
        model: VCheckBoxModel = .init(),
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
        model: VCheckBoxModel = .init(),
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
                checkBox
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    checkBox
                    
                    spacer

                    VBaseButton(gesture: gestureHandler, label: {
                        VText(
                            type: .multiLine(alignment: .leading, lineLimit: model.layout.titleLineLimit),
                            color: model.colors.title.for(internalState),
                            font: model.fonts.title,
                            text: title
                        )
                    })
                        .disabled(!labelIsEnabled)
                })
                
            case .custom(let label):
                HStack(spacing: 0, content: {
                    checkBox
                    
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
    
    private var checkBox: some View {
        VBaseButton(gesture: gestureHandler, label: {
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
        VBaseButton(gesture: gestureHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.checkBoxLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
    }

    // MARK: Icon
    private var checkMarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff: return nil
        case .on, .pressedOn: return ImageBook.checkBoxCheckMarkOn
        case .indeterminate, .pressedIndeterminate: return ImageBook.checkBoxCheckMarkIndeterminate
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
