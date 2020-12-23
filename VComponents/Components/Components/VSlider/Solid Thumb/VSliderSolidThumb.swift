//
//  VSliderSolidThumb.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Solid Thumb
struct VSliderSolidThumb<V>: View where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
    // MARK: Properties
    private let model: VSliderSolidThumbModel
    private let range: ClosedRange<V>
    private let step: Double?
    
    @Binding private var value: Double
    private let state: VSliderState
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init(
        model: VSliderSolidThumbModel,
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
extension VSliderSolidThumb {
    var body: some View {
        VSliderFrameView(
            animation: model.behavior.animation,
            
            height: model.layout.slider.height,
            cornerRadius: model.layout.slider.cornerRadius,
            
            trackColor: model.colors.trackColor(state: state),
            progressColor: model.colors.progressColor(state: state),
            
            isDisabled: state.isDisabled,
            
            range: range,
            step: step,
            value: $value,
            
            action: action,
            
            thumbContent: thumbContent
        )
    }
    
    private func thumbContent(_ proxy: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: model.layout.thumb.cornerRadius)
            .strokeBorder(model.colors.thumbStroke(state: state), lineWidth: model.layout.thumb.stroke)
            .background(
                RoundedRectangle(cornerRadius: model.layout.thumb.cornerRadius)
                    .foregroundColor(model.colors.thumbFillColor(state: state))
            )

            .frame(dimension: model.layout.thumb.dimension)
            .offset(x: thumbOffset(in: proxy), y: 0)
    }
}

// MARK:- Thumb Progress
private extension VSliderSolidThumb {
    func thumbOffset(in proxy: GeometryProxy) -> CGFloat {
        let progressW: CGFloat = progressWidth(in: proxy)
        let thumbW: CGFloat = model.layout.thumb.dimension
        let offset: CGFloat = progressW - thumbW / 2
        
        return offset
    }
    
    func progressWidth(in proxy: GeometryProxy) -> CGFloat {
        let range: CGFloat = CGFloat(self.range.upperBound) - CGFloat(self.range.lowerBound)
        let width: CGFloat = proxy.size.width
        let value: CGFloat = .init(self.value)

        return (value / range) * width
    }
}

// MARK:- Preview
struct VSliderSolidThumb_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VSliderSolidThumb(
            model: .init(),
            range: 0...1,
            step: nil,
            state: .enabled,
            value: $value,
            onChange: nil
        )
    }
}
