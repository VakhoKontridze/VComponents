//
//  VSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Slider
public struct VSlider: View {
    // MARK: Properties
    private let sliderType: VSliderType
    private let min, max: Double
    private var range: ClosedRange<Double> { min...max }
    private let step: Double?
    
    @Binding private var value: Double
    private let state: VSliderState
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init<V>(
        _ sliderType: VSliderType = .default,
        range: ClosedRange<V> = 0...1,
        step: Double?,
        state: VSliderState = .enabled,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.sliderType = sliderType
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = step
        self._value = value
        self.state = state
        self.action = action
    }
    
    public init(
        _ sliderType: VSliderType = .default,
        step: Double?,
        state: VSliderState = .enabled,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    ) {
        self.init(
            sliderType,
            range: 0...1,
            step: step,
            state: state,
            value: value,
            onChange: action
        )
    }
    
    public init(
        _ sliderType: VSliderType = .default,
        state: VSliderState = .enabled,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    ) {
        self.init(
            sliderType,
            range: 0...1,
            step: nil,
            state: state,
            value: value,
            onChange: action
        )
    }
}

// MARK:- Body
public extension VSlider {
    @ViewBuilder var body: some View {
        switch sliderType {
        case .standard(let model): VSliderStandard(model: model, range: range, step: step, state: state, value: $value, onChange: action)
        case .plain(let model): VSliderPlain(model: model, range: range, step: step, state: state, value: $value, onChange: action)
        }
    }
}

// MARK:- Preview
struct VSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VStack(content: {
            VSliderStandard_Previews.previews
            VSliderPlain_Previews.previews
        })
            .padding()
    }
}
