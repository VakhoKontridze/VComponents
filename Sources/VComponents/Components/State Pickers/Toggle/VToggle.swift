//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Toggle
/// State picker component that toggles between off, on, or disabled states, and displays label.
///
/// Component can be initialized without label, with label, or label.
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
public struct VToggle<Label>: View where Label: View {
    // MARK: Properties
    private let model: VToggleModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VToggleState
    private var internalState: VToggleInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let label: VToggleLabel<Label>
    
    private var labelIsEnabled: Bool { model.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes component with state.
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>
    )
        where Label == Never
    {
        self.model = model
        self._state = state
        self.label = .empty
    }
    
    /// Initializes component with state and title.
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
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
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.model = model
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with `Bool`.
    public init(
        model: VToggleModel = .init(),
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
        model: VToggleModel = .init(),
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
        model: VToggleModel = .init(),
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
                toggle
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    toggle
                    
                    spacer

                    VBaseButton(gesture: gestureHandler, label: {
                        VText(
                            type: .multiLine(alignment: .leading, limit: model.layout.titleLabelLineLimit),
                            color: model.colors.title.for(internalState),
                            font: model.fonts.title,
                            title: title
                        )
                    })
                        .disabled(!labelIsEnabled)
                })
                
            case .custom(let label):
                HStack(spacing: 0, content: {
                    toggle
                    
                    spacer
                    
                    VBaseButton(gesture: gestureHandler, label: {
                        label()
                            .opacity(model.colors.customLabelOpacities.for(internalState))
                    })
                        .disabled(!labelIsEnabled)
                })
            }
        })
            .animation(model.animations.stateChange, value: state)
    }
    
    private var toggle: some View {
        VBaseButton(gesture: gestureHandler, label: {
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
        VBaseButton(gesture: gestureHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.toggleLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
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
