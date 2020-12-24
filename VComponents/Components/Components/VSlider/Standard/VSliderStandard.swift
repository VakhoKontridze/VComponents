//
//  VSliderStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Standard
struct VSliderStandard<V>: View where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
    // MARK: Properties
    private let model: VSliderStandardModel
    private let range: ClosedRange<V>
    private let step: Double?
    
    @Binding private var value: Double
    private let state: VSliderState
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    public init(
        model: VSliderStandardModel,
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
extension VSliderStandard {
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
            
            action: action,
            
            thumbContent: thumbContent
        )
    }
    
    private func thumbContent(_ proxy: GeometryProxy) -> some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: model.layout.thumbCornerRadius)
                .foregroundColor(model.colors.thumbFillColor(state: state))
                .shadow(color: model.colors.thumbShadow(state: state), radius: model.layout.thumbShadowRadius)
            
            RoundedRectangle(cornerRadius: model.layout.thumbCornerRadius)
                .strokeBorder(model.colors.thumbBorderWidth(state: state), lineWidth: model.layout.thumbBorderWidth)
        })
            .frame(dimension: model.layout.thumbDimension)
            .offset(x: thumbOffset(in: proxy), y: 0)
    }
}

// MARK:- Thumb Progress
private extension VSliderStandard {
    func thumbOffset(in proxy: GeometryProxy) -> CGFloat {
        let progressW: CGFloat = progressWidth(in: proxy)
        let thumbW: CGFloat = model.layout.thumbDimension
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
struct VSliderStandard_Previews: PreviewProvider {
    @State private static var value: Double = 0.5
    
    static var previews: some View {
        VSliderStandard(
            model: .init(),
            range: 0...1,
            step: nil,
            state: .enabled,
            value: $value,
            onChange: nil
        )
    }
}