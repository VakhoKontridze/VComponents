//
//  VStepper.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI
import VCore

// MARK: - V Stepper
/// Value picker component that selects value from a bounded linear range of values.
///
///     @State private var value: Double = 5
///
///     var body: some View {
///         VStepper(
///             range: 1...10,
///             value: $value
///         )
///         .padding()
///     }
///
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG. No `SwiftUIGestureBaseButton`.
@available(watchOS, unavailable) // Doesn't follow HIG. No `SwiftUIGestureBaseButton`.
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VStepper: View {
    // MARK: Properties - UI Model
    private let uiModel: VStepperUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VStepperInternalState { .init(isEnabled: isEnabled) }

    // MARK: Properties - State - Button
    @State private var pressedButton: VStepperButton?

    private func buttonIsEnabled(_ button: VStepperButton) -> Bool {
        switch (internalState, button) {
        case (.disabled, _): false
        case (.enabled, .minus): !(value <= range.lowerBound)
        case (.enabled, .plus): !(value >= range.upperBound)
        }
    }

    private func buttonInternalState(_ button: VStepperButton) -> VStepperButtonInternalState {
        .init(
            isEnabled: buttonIsEnabled(button),
            isPressed: pressedButton == button
        )
    }

    // MARK: Properties - Value Range
    private let range: ClosedRange<Int>
    private let step: Int

    // MARK: Properties - Value
    @Binding private var value: Int

    // MARK: Properties - Actions
    private let onIncrement: (() -> Void)?
    private let onDecrement: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?

    // MARK: Properties - Long Press
    @State private var longPressSchedulerTimer: Timer?

    @State private var longPressIncrementTimer: Timer?
    @State private var longPressIncrementTimerIncremental: Timer?
    @State private var longPressIncrementTimeElapsed: TimeInterval = 0

    @State private var shouldSkipIncrementBecauseOfLongPressIncrementFinish: Bool = false
    
    // MARK: Initializers
    /// Initializes `VStepper` with range and value.
    public init(
        uiModel: VStepperUIModel = .init(),
        range: ClosedRange<Int>,
        step: Int = 1,
        value: Binding<Int>,
        onIncrement: (() -> Void)? = nil,
        onDecrement: (() -> Void)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.uiModel = uiModel
        self.range = range
        self.step = step
        self._value = value
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.onEditingChanged = onEditingChanged
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(content: {
            backgroundView
            buttons
        })
        .frame(size: uiModel.size)
        .clipShape(.rect(cornerRadius: uiModel.cornerRadius))
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: uiModel.cornerRadius)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
    }
    
    private var buttons: some View {
        HStack(spacing: 0, content: {
            button(.minus)
            dividerView
            button(.plus)
        })
        .frame(maxWidth: .infinity)
    }
    
    private func button(_ button: VStepperButton) -> some View {
        SwiftUIGestureBaseButton(
            onStateChange: { stateChangeHandler(button: button, gestureState: $0) },
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .foregroundStyle(uiModel.buttonBackgroundColors.value(for: buttonInternalState(button)))

                    buttonIcon(button)
                        .applyIf(uiModel.isButtonIconResizable, transform: { $0.resizable() })
                        .applyIfLet(uiModel.buttonIconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
                        .applyIfLet(uiModel.buttonIconColors, transform: { $0.foregroundStyle($1.value(for: buttonInternalState(button))) })
                        .applyIfLet(uiModel.buttonIconOpacities, transform: { $0.opacity($1.value(for: buttonInternalState(button))) })
                        .font(uiModel.buttonIconFont)
                        .frame(size: uiModel.buttonIconSize)
                })
                .frame(maxWidth: .infinity)
            }
        )
        .disabled(!buttonIsEnabled(button))
    }
    
    private var dividerView: some View {
        Rectangle()
            .frame(size: uiModel.dividerSize)
            .foregroundStyle(uiModel.dividerColors.value(for: internalState))
    }

    // MARK: Button Icon
    private func buttonIcon(_ button: VStepperButton) -> Image {
        switch button {
        case .minus: uiModel.buttonIconMinus
        case .plus: uiModel.buttonIconPlus
        }
    }
    
    // MARK: Actions
    private func stateChangeHandler(
        button: VStepperButton,
        gestureState: GestureBaseButtonGestureState
    ) {
        Task(operation: { @MainActor in // `MainActor` is needed
            if !gestureState.didRecognizePress {
                pressedButton = nil
                shouldSkipIncrementBecauseOfLongPressIncrementFinish = longPressIncrementTimer != nil
                zeroLongPressTimers()
                
            } else if pressedButton != button {
                pressedButton = button
                scheduleLongPressIncrementSchedulerTimer(for: button)
            }

            if gestureState == .began {
                onEditingChanged?(true)
            }

            if gestureState.didRecognizeClick {
                playHapticPressEffect()
                action(button: button)
            }

            if gestureState == .ended {
                onEditingChanged?(false)
            }
        })
    }
    
    private func action(button: VStepperButton) {
        guard !shouldSkipIncrementBecauseOfLongPressIncrementFinish else {
            shouldSkipIncrementBecauseOfLongPressIncrementFinish = false
            return
        }
        
        switch button {
        case .minus:
            if value <= range.lowerBound {
                zeroLongPressTimers()
            } else {
                value -= step
                onDecrement?()
            }
            
        case .plus:
            if value >= range.upperBound {
                zeroLongPressTimers()
            } else {
                value += step
                onIncrement?()
            }
        }
    }
    
    // MARK: Long Press Increment
    private func scheduleLongPressIncrementSchedulerTimer(for button: VStepperButton) {
        zeroLongPressTimers()
        
        longPressSchedulerTimer = .scheduledTimer(withTimeInterval: uiModel.intervalToStartLongPressIncrement, repeats: false, block: { _ in
            if longPressIncrementTimeElapsed == 0 { playHapticLongPressEffect() }
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
            let adjustedStep: Int = .init(pow(Double(uiModel.longPressIncrementExponent), longPressIncrementTimeElapsed)) * step
            let interval: TimeInterval = 1 / Double(adjustedStep)
            return interval
        }()
        
        longPressIncrementTimerIncremental = .scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
            if let pressedButton {
                action(button: pressedButton)
            } else {
                zeroLongPressTimers()
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
    
    // MARK: Haptics
    private func playHapticPressEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.hapticPress)
#endif
    }
    
    private func playHapticLongPressEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.hapticLongPress)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var value: Int = 50

        var body: some View {
            PreviewContainer(content: {
                VStepper(
                    range: 1...100,
                    value: $value
                )

                Text(String(value))
            })
        }
    }

    return ContentView()
})

#Preview("States", body: {
    PreviewContainer(content: {
        PreviewRow("Enabled", content: {
            VStepper(
                range: 1...100,
                value: .constant(50)
            )
        })

        PreviewRow("Pressed (Row) (*)", content: {
            VStepper(
                uiModel: {
                    var uiModel: VStepperUIModel = .init()
                    uiModel.buttonBackgroundColors.enabled = uiModel.buttonBackgroundColors.pressed
                    uiModel.buttonIconColors!.enabled = uiModel.buttonIconColors!.pressed // Force-unwrap
                    return uiModel
                }(),
                range: 1...100,
                value: .constant(50)
            )
        })

        PreviewRow("Disabled", content: {
            VStepper(
                range: 1...100,
                value: .constant(50)
            )
            .disabled(true)
        })

        PreviewHeader("Native")

        PreviewRow("Enabled", content: {
            Stepper(
                "",
                value: .constant(50),
                in: 1...100
            )
            .labelsHidden()
        })

        PreviewRow("Disabled", content: {
            Stepper(
                "",
                value: .constant(50),
                in: 1...100
            )
            .labelsHidden()
            .disabled(true)
        })
    })
})

#endif

#endif
