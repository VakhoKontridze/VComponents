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
/// Step and state can be passed as parameters
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
    private let range: ClosedRange<Int>
    private let step: Int
    
    @Binding private var value: Int
    private let state: VStepperState
    
    private let changeHandler: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init(
        range: ClosedRange<Int>,
        step: Int = 1,
        value: Binding<Int>,
        state: VStepperState = .enabled,
        changeHandler: ((Bool) -> Void)? = nil
    ) {
        self.range = range
        self.step = step
        self._value = value
        self.state = state
        self.changeHandler = changeHandler
    }
}

// MARK:- Body
extension VStepper {
    public var body: some View {
        Stepper(
            value: $value,
            in: range,
            step: step,
            onEditingChanged: { changeHandler?($0) },
            label: { EmptyView() }
        )
            .labelsHidden()
            .disabled(state.isDisabled)
    }
}

// MARK:- Preview
struct VStepper_Previews: PreviewProvider {
    @State private static var value: Int = 5
    
    static var previews: some View {
        VStepper(range: 1...10, value: $value)
    }
}
