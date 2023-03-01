//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button
/// State picker component that toggles between off, on, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
///
/// UI Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
///     @State private var state: VRadioButtonState = .on
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
    private let uiModel: VRadioButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState { .init(isEnabled: isEnabled, isOn: state == .on, isPressed: isPressed) }
    
    private let label: VRadioButtonLabel<Label>
    
    private var labelIsEnabled: Bool { uiModel.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
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
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
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
        uiModel: VRadioButtonUIModel = .init(),
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
        uiModel: VRadioButtonUIModel = .init(),
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
                radioButton
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    radioButton
                    
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
                    radioButton
                    
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
    
    private var radioButton: some View {
        SwiftUIBaseButton(gesture: gestureHandler, label: {
            ZStack(content: {
                Circle()
                    .frame(dimension: uiModel.layout.dimension)
                    .foregroundColor(uiModel.colors.fill.value(for: internalState))
                
                Circle()
                    .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWith)
                    .frame(dimension: uiModel.layout.dimension)
                
                Circle()
                    .frame(dimension: uiModel.layout.bulletDimension)
                    .foregroundColor(uiModel.colors.bullet.value(for: internalState))
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
                .frame(width: uiModel.layout.radioLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
    }
}

// MARK: - Preview
struct VRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    private struct Preview: View {
        @State private var state: VRadioButtonState = .on
        
        var body: some View {
            VRadioButton(
                state: $state,
                title: "Lorem Ipsum"
            )
        }
    }
}
