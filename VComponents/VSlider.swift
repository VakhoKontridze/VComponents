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
    @Binding private var value: Double
    private let min, max: Double
    private let step: Double?
    
    private let sliderType: VSliderType
    private let viewModel: VSliderViewModel
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init(
        value: Binding<Double>,
        min: Double, max: Double,
        step: Double?,
        type sliderType: VSliderType,
        viewModel: VSliderViewModel,
        onChange action: ((Bool) -> Void)?
    ) {
        precondition(min < max, "Min value cannot be highter than max value")
        
        self._value = value
        self.min = min
        self.max = max
        self.step = step
        self.sliderType = sliderType
        self.viewModel = viewModel
        self.action = action
    }
    
    public init(
        value: Binding<Double>,
        step: Double,
        type sliderType: VSliderType,
        viewModel: VSliderViewModel,
        onChange action: ((Bool) -> Void)?
    ) {
        self.init(
            value: value,
            min: 0, max: 1,
            step: step,
            type: sliderType,
            viewModel: viewModel,
            onChange: action
        )
    }
    
    public init(
        value: Binding<Double>,
        type sliderType: VSliderType,
        viewModel: VSliderViewModel,
        onChange action: ((Bool) -> Void)?
    ) {
        self.init(
            value: value,
            min: 0, max: 1,
            step: nil,
            type: sliderType,
            viewModel: viewModel,
            onChange: action
        )
    }
    
    public init<V>(
        value: Binding<Double>,
        range: ClosedRange<V>,
        step: Double?,
        type sliderType: VSliderType,
        viewModel: VSliderViewModel,
        onChange action: ((Bool) -> Void)?
    )
        where V: BinaryFloatingPoint, V.Stride :BinaryFloatingPoint
    {
        self.init(
            value: value,
            min: .init(range.lowerBound), max: .init(range.upperBound),
            step: step,
            type: sliderType,
            viewModel: viewModel,
            onChange: action
        )
    }
}

// MARK:- Body
public extension VSlider {
    @ViewBuilder var body: some View {
        switch (sliderType, step) {
        case (.rounded, let step): VRoundedSlider(value: $value, min: min, max: max, step: step, viewModel: viewModel, onChange: { action?($0) })
            
        case (.thin, nil): thinSlider
        case (.thin, let step?): thinSteppedSlider(step: step)
        }
    }
    
    private var thinSlider: some View {
        Slider(value: $value, in: min...max, onEditingChanged: { action?($0) })
            .accentColor(viewModel.colors.thin.slider)
    }
    
    private func thinSteppedSlider(step: Double) -> some View {
        Slider(value: $value, in: min...max, step: step, onEditingChanged: { action?($0) })
            .accentColor(viewModel.colors.thin.slider)
    }
}

// MARK:- Preview
struct VSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VSlider(value: $value, type: .rounded, viewModel: .init(), onChange: nil)
            .padding()
    }
}
