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
    private let viewModel: VSliderViewModel
    private let min, max: Double
    private let step: Double?
    
    @Binding private var value: Double
    private let state: VSliderState
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init<V>(
        _ sliderType: VSliderType,
        viewModel: VSliderViewModel = .init(),
        range: ClosedRange<V> = 0...1,
        step: Double?,
        state: VSliderState,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where V: BinaryFloatingPoint, V.Stride :BinaryFloatingPoint
    {
        self.sliderType = sliderType
        self.viewModel = viewModel
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = step
        self._value = value
        self.state = state
        self.action = action
    }
    
    public init(
        _ sliderType: VSliderType,
        viewModel: VSliderViewModel = .init(),
        step: Double?,
        state: VSliderState,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    ) {
        self.init(
            sliderType,
            viewModel: viewModel,
            range: 0...1,
            step: step,
            state: state,
            value: value,
            onChange: action
        )
    }
    
    public init(
        _ sliderType: VSliderType,
        viewModel: VSliderViewModel = .init(),
        state: VSliderState,
        value: Binding<Double>,
        onChange action: ((Bool) -> Void)? = nil
    ) {
        self.init(
            sliderType,
            viewModel: viewModel,
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
    var body: some View {
        GeometryReader(content: { proxy in
            ZStack(alignment: .leading, content: {
                track
                progress(in: proxy)
            })
                .mask(RoundedRectangle(cornerRadius: viewModel.layout.slider.cornerRadius))
            
                .overlay(thumb(in: proxy))
            
                .disabled(!state.isEnabled)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ dragChanged($0, in: proxy) })
                        .onEnded(dragEnded)
                )
        })
            .frame(height: viewModel.layout.slider.height)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(VSliderViewModel.Colors.track(state: state, vm: viewModel))
    }

    private func progress(in proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: progressWidth(in: proxy))

            .foregroundColor(VSliderViewModel.Colors.progress(state: state, vm: viewModel))
    }
    
    private func thumb(in proxy: GeometryProxy) -> some View {
        Group(content: {
            Group(content: {
                switch sliderType {
                case .plain:
                    EmptyView()
                    
                case .thumb:
                    RoundedRectangle(cornerRadius: viewModel.layout.thumb.cornerRadius)
                        .foregroundColor(VSliderViewModel.Colors.thumbFill(state: state, vm: viewModel))
                        .shadow(color: VSliderViewModel.Colors.thumbShadow(state: state, vm: viewModel), radius: 2)
                    
                        .frame(size: .init(width: viewModel.layout.thumb.dimension, height: viewModel.layout.thumb.dimension))
                    
                case .solidThumb:
                    RoundedRectangle(cornerRadius: viewModel.layout.solidThumb.cornerRadius)
                        .stroke(VSliderViewModel.Colors.solidThumbStroke(state: state, vm: viewModel), lineWidth: viewModel.layout.solidThumb.stroke)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(VSliderViewModel.Colors.solidThumbFill(state: state, vm: viewModel)))
                    
                        .frame(size: .init(width: viewModel.layout.solidThumb.dimension, height: viewModel.layout.solidThumb.dimension))
                }
            })
                .offset(x: thumbOffset(in: proxy), y: 0)
        })
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
    }
}

// MARK:- Drag
private extension VSlider {
    func dragChanged(_ draggedValue: DragGesture.Value, in proxy: GeometryProxy) {
        switch viewModel.behavior.useAnimation {
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

// MARK:- Drag Reglection
private extension VSlider {
    func progressWidth(in proxy: GeometryProxy) -> CGFloat {
        let range: CGFloat = .init(max - min)
        let width: CGFloat = proxy.size.width
        let value: CGFloat = .init(self.value)

        return (value / range) * width
    }
    
    func thumbOffset(in proxy: GeometryProxy) -> CGFloat {
        let progressW: CGFloat = progressWidth(in: proxy)
        
        let thumbW: CGFloat = {
            switch sliderType {
            case .plain: return 0
            case .thumb: return viewModel.layout.thumb.dimension
            case .solidThumb: return viewModel.layout.solidThumb.dimension
            }
        }()
        
        let offset: CGFloat = progressW - thumbW / 2

        return offset
    }
}

// MARK:- Helpers
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
struct VSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.25
    
    static var previews: some View {
        VStack(spacing: 20, content: {
            VSlider(.plain, state: .enabled, value: $value)
            VSlider(.thumb, state: .enabled, value: $value)
            VSlider(.solidThumb, state: .enabled, value: $value)
        })
            .padding()
    }
}
