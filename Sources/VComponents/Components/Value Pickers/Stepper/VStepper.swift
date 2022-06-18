//
//  VStepper.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Stepper
/// Value picker component that selects value from a bounded linear range of values.
///
/// UI Model, step, and state can be passed as parameters.
///
///     @State var value: Double = 0.5
///
///     var body: some View {
///         VStepper(
///             range: 1...10,
///             value: $value
///         )
///             .padding()
///     }
///
public struct VStepper: View {
    // MARK: Properties
    private let uiModel: VStepperUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VStepperInternalState { .init(isEnabled: isEnabled) }
    @State private var pressedButton: VStepperButton?
    private func buttonInternalState(_ button: VStepperButton) -> VStepperButtonInternalState {
        .init(
            isEnabled: buttonIsEnabled(for: button),
            isPressed: pressedButton == button
        )
    }
    
    private let range: ClosedRange<Int>
    private let step: Int
    
    @Binding private var value: Int
    
    @State private var longPressSchedulerTimer: Timer?
    @State private var longPressIncrementTimer: Timer?
    @State private var longPressIncrementTimerIncremental: Timer?
    @State private var longPressIncrementTimeElapsed: TimeInterval = 0
    @State private var shouldSkipIncrementBecauseOfLongPressIncrementFinish: Bool = false
    
    // MARK: Initializers
    /// Initializes component with range and value.
    public init(
        uiModel: VStepperUIModel = .init(),
        range: ClosedRange<Int>,
        step: Int = 1,
        value: Binding<Int>
    ) {
        self.uiModel = uiModel
        self.range = range
        self.step = step
        self._value = value
    }

    // MARK: Body
    public var body: some View {
        ZStack(content: {
            background
            buttons
        })
            .frame(size: uiModel.layout.size)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .foregroundColor(uiModel.colors.background.for(internalState))
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
            gesture: { gestureHandler(button: button, gestureState: $0) },
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                        .foregroundColor(uiModel.colors.buttonBackground.for(buttonInternalState(button)))
                    
                    button.icon
                        .resizable()
                        .frame(dimension: uiModel.layout.iconDimension)
                        .foregroundColor(uiModel.colors.buttonIcon.for(buttonInternalState(button)))
                })
                    .frame(maxWidth: .infinity)
            }
        )
            .disabled(!buttonIsEnabled(for: button))
    }
    
    private var divider: some View {
        Rectangle()
            .frame(size: uiModel.layout.divider)
            .foregroundColor(uiModel.colors.divider.for(internalState))
    }
    
    // MARK: Actions
    private func gestureHandler(button: VStepperButton, gestureState: VBaseButtonGestureState) {
        pressGestureHandler(button, isPressed: gestureState.isPressed)
        if gestureState.isClicked { clickGestureHandler(button) }
    }

    private func clickGestureHandler(_ button: VStepperButton) {
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
    
    private func pressGestureHandler(_ button: VStepperButton, isPressed: Bool) {
        if !isPressed {
            pressedButton = nil
            shouldSkipIncrementBecauseOfLongPressIncrementFinish = longPressIncrementTimer != nil
            zeroLongPressTimers()
            
        } else if pressedButton != button {
            pressedButton = button
            scheduleLongPressIncrementSchedulerTimer(for: button)
        }
    }

    // MARK: Long Press Increment
    private func scheduleLongPressIncrementSchedulerTimer(for button: VStepperButton) {
        zeroLongPressTimers()
        
        longPressSchedulerTimer = .scheduledTimer(withTimeInterval: uiModel.misc.intervalToStartLongPressIncrement, repeats: false, block: { _ in
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
            let adjustedStep: Int = .init(pow(.init(uiModel.misc.longPressIncrementExponent), longPressIncrementTimeElapsed)) * step
            let interval: TimeInterval = 1 / .init(adjustedStep)
            return interval
        }()
        
        longPressIncrementTimerIncremental = .scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
            switch pressedButton {
            case nil: zeroLongPressTimers()
            case let button?: clickGestureHandler(button)
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
    
    // MARK: Helpers
    private func buttonIsEnabled(for button: VStepperButton) -> Bool {
        switch (internalState, button) {
        case (.disabled, _): return false
        case (.enabled, .minus): return !(value <= range.lowerBound)
        case (.enabled, .plus): return !(value >= range.upperBound)
        }
    }
}

// MARK: - Preview
struct VStepper_Previews: PreviewProvider {
    @State private static var value: Int = 5
    
    static var previews: some View {
        VStepper(
            range: 1...10,
            value: $value
        )
    }
}
