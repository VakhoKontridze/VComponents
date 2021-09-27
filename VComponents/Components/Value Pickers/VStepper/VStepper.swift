//
//  VStepper.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Stepper
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
    
    private let state: VStepperState
    @State private var pressedButton: VStepperButton?
    private func pressedButtonState(_ button: VStepperButton) -> VStepperButtonState {
        .init(
            isEnabled: buttonState(for: button).isEnabled,
            isPressed: pressedButton == button
        )
    }
    
    @Binding private var value: Int
    
    @State private var longPressSchedulerTimer: Timer?
    @State private var longPressIncrementTimer: Timer?
    @State private var longPressIncrementTimerIncremental: Timer?
    @State private var longPressIncrementTimeElapsed: TimeInterval = 0
    @State private var shouldSkipIncrementBecauseOfLongPressIncrementFinish: Bool = false
    
    // MARK: Initializers
    /// Initializes component with range and value
    public init(
        model: VStepperModel = .init(),
        range: ClosedRange<Int>,
        step: Int = 1,
        state: VStepperState = .enabled,
        value: Binding<Int>
    ) {
        self.model = model
        self.range = range
        self.step = step
        self.state = state
        self._value = value
    }

    // MARK: Body
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
            onPress: { saveButtonPressState(button, isPressed: $0) },
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

    // MARK: Button State
    private func saveButtonPressState(_ button: VStepperButton, isPressed: Bool) {
        if !isPressed {
            pressedButton = nil
            shouldSkipIncrementBecauseOfLongPressIncrementFinish = longPressIncrementTimer != nil
            zeroLongPressTimers()
        } else if pressedButton != button {
            pressedButton = button
            scheduleLongPressIncrementSchedulerTimer(for: button)
        }
    }
    
    private func buttonState(for button: VStepperButton) -> VBaseButtonState {
        switch (state, button) {
        case (.disabled, _): return .disabled
        case (.enabled, .minus): return value <= range.lowerBound ? .disabled : .enabled
        case (.enabled, .plus): return value >= range.upperBound ? .disabled : .enabled
        }
    }

    // MARK: Increment
    private func incrementValue(from button: VStepperButton) {
        guard !shouldSkipIncrementBecauseOfLongPressIncrementFinish else {
            shouldSkipIncrementBecauseOfLongPressIncrementFinish = false
            return
        }
        
        switch button {
        case .minus:
            switch value <= range.lowerBound {
            case false: value -= step
            case true: zeroLongPressTimers()
            }
        
        case .plus:
            switch value >= range.upperBound {
            case false: value += step
            case true: zeroLongPressTimers()
            }
        }
    }

    // MARK: Long Press Increment
    private func scheduleLongPressIncrementSchedulerTimer(for button: VStepperButton) {
        zeroLongPressTimers()
        
        longPressSchedulerTimer = .scheduledTimer(withTimeInterval: model.misc.intervalToStartLongPressIncrement, repeats: false, block: { _ in
            scheduleLongPressIncrementTimer()
        })
    }
    
    private func scheduleLongPressIncrementTimer() {
        zeroLongPressTimers()
        
        longPressIncrementTimer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            longPressIncrementTimeElapsed += timer.timeInterval
            incrementFromLongPress()
        })
        
        longPressIncrementTimeElapsed = 1
        longPressIncrementTimer?.fire()
    }
    
    private func incrementFromLongPress() {
        longPressIncrementTimerIncremental?.invalidate()
        longPressIncrementTimerIncremental = nil

        let interval: TimeInterval = {
            let adjustedStep: Int = .init(pow(.init(model.misc.longPressIncrementExponent), longPressIncrementTimeElapsed)) * step
            let interval: TimeInterval = 1 / .init(adjustedStep)
            return interval
        }()
        
        longPressIncrementTimerIncremental = .scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
            switch pressedButton {
            case nil: zeroLongPressTimers()
            case let button?: incrementValue(from: button)
            }
        })
        
        longPressIncrementTimerIncremental?.fire()
    }
    
    private func zeroLongPressTimers() {
        longPressSchedulerTimer?.invalidate()
        longPressSchedulerTimer = nil
        
        longPressIncrementTimer?.invalidate()
        longPressIncrementTimer = nil
        
        longPressIncrementTimerIncremental?.invalidate()
        longPressIncrementTimerIncremental = nil
        
        longPressIncrementTimeElapsed = 0
    }
}

// MARK: - Preview
struct VStepper_Previews: PreviewProvider {
    @State private static var value: Int = 5
    
    static var previews: some View {
        VStepper(range: 1...10, value: $value)
    }
}
