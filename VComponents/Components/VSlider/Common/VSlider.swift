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
        _ sliderType: VSliderType,
        range: ClosedRange<V> = 0...1,
        step: Double?,
        state: VSliderState,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint
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
        _ sliderType: VSliderType,
        step: Double?,
        state: VSliderState,
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
        _ sliderType: VSliderType,
        state: VSliderState,
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
        case .plain(let model): VSliderPlain(model: model, range: range, step: step, state: state, value: $value, onChange: action)
        case .thumb(let model): VSliderThumb(model: model, range: range, step: step, state: state, value: $value, onChange: action)
        case .solidThumb(let model): VSliderSolidThumb(model: model, range: range, step: step, state: state, value: $value, onChange: action)
        }
    }
}

// MARK:- Preview
struct VSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VStack(spacing: 20, content: {
            VSlider(.plain(), state: .enabled, value: $value)
            VSlider(.thumb(), state: .enabled, value: $value)
            VSlider(.solidThumb(), state: .enabled, value: $value)
        })
            .padding()
    }
}
