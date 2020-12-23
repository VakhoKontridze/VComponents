//
//  VSliderPlain.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Slider Plain
struct VSliderPlain<V>: View where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
    // MARK: Properties
    private let model: VSliderPlainModel
    private let range: ClosedRange<V>
    private let step: Double?
    
    @Binding private var value: Double
    private let state: VSliderState
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init(
        model: VSliderPlainModel,
        range: ClosedRange<V>,
        step: Double?,
        state: VSliderState,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)?
    ) {
        self.model = model
        self.range = range
        self.step = step
        self._value = value
        self.state = state
        self.action = action
    }
}

// MARK:- Body
extension VSliderPlain {
    var body: some View {
        VSliderFrameView(
            animation: model.behavior.animation,
            
            height: model.layout.height,
            cornerRadius: model.layout.cornerRadius,
            
            trackColor: model.colors.trackColor(state: state),
            progressColor: model.colors.progressColor(state: state),
            
            isDisabled: state.isDisabled,
            
            range: range,
            step: step,
            value: $value,
            
            action: action
        )
    }
}

// MARK:- Preview
struct VSliderPlain_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VSliderPlain(
            model: .init(),
            range: 0...1,
            step: nil,
            state: .enabled,
            value: $value,
            onChange: nil
        )
    }
}
