//
//  VStepper.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK:- V Stepper
/// Value picker component that selects value from a bounded linear range of values
///
/// Model, step, and state can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var value: Double = 0.5
///
/// var body: some View {
///     VStepper(range: 1...10, value: $value)
///         .padding()
/// }
/// ```
///
public struct VStepper: View {
    // MARK: Properties
    private let model: VStepperModel
    
    private let range: ClosedRange<Int>
    private let step: Int
    
    @Binding private var value: Int
    
    private let state: VStepperState
    @State private var pressedButton: VStepperButton?
    private func pressedButtonState(_ button: VStepperButton) -> VStepperButtonState {
        .init(
            isEnabled: buttonState(for: button).isEnabled,
            isPressed: pressedButton == button
        )
    }
    
    // MARK: Initializers
    public init(
        model: VStepperModel = .init(),
        range: ClosedRange<Int>,
        step: Int = 1,
        value: Binding<Int>,
        state: VStepperState = .enabled
    ) {
        self.model = model
        self.range = range
        self.step = step
        self._value = value
        self.state = state
    }
}

// MARK:- Body
extension VStepper {
    public var body: some View {
        ZStack(content: {
            background
            buttons
        })
            .frame(size: model.layout.size)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.background.for(state))
    }
    
    private var buttons: some View {
        HStack(spacing: 0, content: {
            button(.minus)
            divider
            button(.plus)
        })
            .frame(maxWidth: .infinity)
    }
    
    private func button(_ button: VStepperButton) -> some View {
        VBaseButton(
            state: buttonState(for: button),
            action: { incrementValue(from: button) },
            onPress: { saveButtonPressState(button, state: $0) },
            content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                        .foregroundColor(model.colors.buttonBackground.for(pressedButtonState(button)))
                    
                    button.icon
                        .resizable()
                        .frame(dimension: model.layout.iconDimension)
                        .foregroundColor(model.colors.buttonIcon.for(pressedButtonState(button)))
                        .opacity(model.colors.buttonIcon.for(pressedButtonState(button)))
                })
                    .frame(maxWidth: .infinity)
            }
        )
    }
    
    private var divider: some View {
        Rectangle()
            .frame(size: model.layout.divider)
            .foregroundColor(model.colors.divider.for(state))
    }
}

// MARK:- Actions
private extension VStepper {
    func incrementValue(from button: VStepperButton) {
        switch button {
        case .minus: value -= step
        case .plus: value += step
        }
    }
    
    func saveButtonPressState(_ button: VStepperButton, state: Bool) {
        switch state {
        case false: pressedButton = nil
        case true: pressedButton = button
        }
    }
}

// MARK:- Button State
private extension VStepper {
    func buttonState(for button: VStepperButton) -> VBaseButtonState {
        switch (state, button) {
        case (.disabled, _): return .disabled
        case (.enabled, .minus): return value == range.lowerBound ? .disabled : .enabled
        case (.enabled, .plus): return value == range.upperBound ? .disabled : .enabled
        }
    }
}

// MARK:- Preview
struct VStepper_Previews: PreviewProvider {
    @State private static var value: Int = 5
    
    static var previews: some View {
        VStepper(range: 1...10, value: $value)
    }
}
