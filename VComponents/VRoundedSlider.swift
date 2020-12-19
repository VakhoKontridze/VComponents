//
//  VRoundedSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Rounded Slider
struct VRoundedSlider: View {
    // MARK: Properties
    private let state: VSliderState
    
    @Binding private var value: Double
    private let min, max: Double
    private let step: Double?
    
    private let viewModel: VSliderViewModel
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    init(
        state: VSliderState,
        value: Binding<Double>,
        min: Double, max: Double,
        step: Double?,
        viewModel: VSliderViewModel,
        onChange action: ((Bool) -> Void)?
    ) {
        self.state = state
        self._value = value
        self.min = min
        self.max = max
        self.step = step
        self.viewModel = viewModel
        self.action = action
    }
}

// MARK:- Body
extension VRoundedSlider {
    var body: some View {
        GeometryReader(content: { proxy in
            ZStack(alignment: .leading) {
                track
                progress(proxy: proxy)
            }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ dragChanged($0, in: proxy) })
                        .onEnded(dragEnded)
                )
        })
            .disabled(!state.isEnabled)
        
            .frame(height: viewModel.layout.rounded.height)
            .mask(RoundedRectangle(cornerRadius: viewModel.layout.rounded.cornerRadius))
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(VSliderViewModel.Colors.track(state: state, vm: viewModel))
    }

    private func progress(proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: {
                let range: CGFloat = .init(max - min)
                let width: CGFloat = proxy.size.width
                let value: CGFloat = .init(self.value)

                return (value / range) * width
            }())

            .foregroundColor(VSliderViewModel.Colors.slider(state: state, vm: viewModel))
    }
}

// MARK:- Value
private extension VRoundedSlider {
    func dragChanged(_ draggedValue: DragGesture.Value, in proxy: GeometryProxy) {
        switch viewModel.behavior.rounded.useAnimation {
        case false: calculateDragChangedValue(draggedValue, in: proxy)
        case true: withAnimation{ calculateDragChangedValue(draggedValue, in: proxy) }
        }

        action?(true)
    }
    
    func calculateDragChangedValue(_ draggedValue: DragGesture.Value, in proxy: GeometryProxy) {
        value = {
            let range: Double = max - min
            let width: Double = .init(proxy.size.width)
            let draggedValue: Double = .init(draggedValue.location.x)

            let rawValue: Double = (draggedValue / width) * range
            
            switch (rawValue, step) {
            case (...min, _): return min
            case (max..., _): return max
            case (_, nil): return rawValue
            case (_, let step?): return rawValue.roundWithPrecision(step, min: min, max: max)
            }
        }()
    }
    
    func dragEnded(_ draggedValue: DragGesture.Value) {
        action?(false)
    }
}

private extension Double {
    func roundWithPrecision(_ step: Double, min: Double, max: Double) -> Double {
        let rawValue: Double = (self/step).rounded() * step
        
        switch rawValue {
        case ...min: return min
        case max...: return max
        case _: return rawValue
        }
    }
}

// MARK:- Preview
struct VRoundedSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VRoundedSlider(state: .enabled, value: $value, min: 0, max: 1, step: 0.1, viewModel: .init(), onChange: nil)
            .padding()
    }
}

// MARK:- ViewModel Mapping
private extension VSliderViewModel.Colors {
    static func slider(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.rounded.slider.enabled
        case .disabled: return vm.colors.rounded.slider.disabled
        }
    }
    
    static func track(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.rounded.track.enabled
        case .disabled: return vm.colors.rounded.track.disabled
        }
    }
}
