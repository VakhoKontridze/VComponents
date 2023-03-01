//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box
/// State picker component that toggles between off, on, indeterminate, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
///
/// UI Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
///     @State private var state: VCheckBoxState = .on
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
    private let uiModel: VCheckBoxUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let label: VCheckBoxLabel<Label>
    
    private var labelIsEnabled: Bool { uiModel.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes component with state and label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .empty
    }
    
    /// Initializes component with `Bool` and title.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes component with `Bool` and label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
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

                    SwiftUIBaseButton(gesture: gestureHandler, label: {
                        VText(
                            type: uiModel.layout.titleLineType,
                            minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                            color: uiModel.colors.title.value(for: internalState),
                            font: uiModel.fonts.title,
                            text: title
                        )
                    })
                        .disabled(!labelIsEnabled)
                })
                
            case .custom(let label):
                HStack(spacing: 0, content: {
                    checkBox
                    
                    spacer
                    
                    SwiftUIBaseButton(gesture: gestureHandler, label: {
                        label()
                            .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
                    })
                        .disabled(!labelIsEnabled)
                })
            }
        })
            .animation(uiModel.animations.stateChange, value: internalState)
    }
    
    private var checkBox: some View {
        SwiftUIBaseButton(gesture: gestureHandler, label: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                    .foregroundColor(uiModel.colors.fill.value(for: internalState))
                
                RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                    .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWith)

                if let checkMarkIcon {
                    checkMarkIcon
                        .resizable()
                        .frame(dimension: uiModel.layout.iconDimension)
                        .foregroundColor(uiModel.colors.checkmark.value(for: internalState))
                }
            })
                .frame(dimension: uiModel.layout.dimension)
                .padding(uiModel.layout.hitBox)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var spacer: some View {
        SwiftUIBaseButton(gesture: gestureHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: uiModel.layout.checkBoxLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: BaseButtonGestureState) {
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
    static var previews: some View {
        Preview()
    }
    
    private struct Preview: View {
        @State private var state: VCheckBoxState = .on
        
        var body: some View {
            VCheckBox(
                state: $state,
                title: "Lorem Ipsum"
            )
        }
    }
}
