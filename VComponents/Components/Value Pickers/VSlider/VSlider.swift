//
//  VSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Slider
/// Value picker component that selects value from a bounded linear range of values.
///
/// Model, range, step, state, and onChange callback can be passed as parameters.
///
/// Usage example:
///
///     @State var value: Double = 0.5
///
///     var body: some View {
///         VSlider(value: $value)
///             .padding()
///     }
///
public struct VSlider: View {
    // MARK: Properties
    private let model: VSliderModel
    
    private let min, max: Double
    private var range: ClosedRange<Double> { min...max }
    private let step: Double?
    
    private let state: VSliderState
    
    @Binding private var value: Double
    @State private var animatableValue: Double?
    
    private let action: ((Bool) -> Void)?
    
    // MARK: Initializers
    /// Initializes component with value.
    public init<V>(
        model: VSliderModel = .init(),
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        state: VSliderState = .enabled,
        value: Binding<V>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.model = model
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = {
            switch step {
            case nil: return nil
            case let step?: return .init(step)
            }
        }()
        self.state = state
        self._value = .init(from: value, range: range, step: step)
        self.action = action
    }

    // MARK: Body
    public var body: some View {
        setStatesFromBodyRender()
        
        return GeometryReader(content: { proxy in
            ZStack(alignment: .leading, content: {
                track
                progress(in: proxy)
            })
                .mask(RoundedRectangle(cornerRadius: model.layout.cornerRadius))
            
                .overlay(thumb(in: proxy))
            
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ dragChanged(drag: $0, in: proxy) })
                        .onEnded(dragEnded)
                )
                .disabled(!state.isEnabled)
        })
            .frame(height: model.layout.height)
            .padding(.horizontal, model.layout.thumbDimension / 2)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(model.colors.track.for(state))
    }

    private func progress(in proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: progressWidth(in: proxy))

            .foregroundColor(model.colors.progress.for(state))
    }
    
    @ViewBuilder private func thumb(in proxy: GeometryProxy) -> some View {
        if model.layout.hasThumb {
            Group(content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: model.layout.thumbCornerRadius)
                        .foregroundColor(model.colors.thumb.for(state))
                        .shadow(color: model.colors.thumbShadow.for(state), radius: model.layout.thumbShadowRadius)
                    
                    RoundedRectangle(cornerRadius: model.layout.thumbCornerRadius)
                        .strokeBorder(model.colors.thumbBorder.for(state), lineWidth: model.layout.thumbBorderWidth)
                })
                    .frame(dimension: model.layout.thumbDimension)
                    .offset(x: thumbOffset(in: proxy))
            })
                .frame(maxWidth: .infinity, alignment: .leading)    // Must be put into group, as content already has frame
                .allowsHitTesting(false)
        }
    }

    // MARK: State Sets
    private func setStatesFromBodyRender() {
        DispatchQueue.main.async(execute: {
            setAnimatableValue()
        })
    }

    // MARK: Drag
    private func dragChanged(drag: DragGesture.Value, in proxy: GeometryProxy) {
        let rawValue: Double = {
            let value: Double = .init(drag.location.x)
            let range: Double = max - min
            let width: Double = .init(proxy.size.width)

            return (value / width) * range + min
        }()
        
        let valueFixed: Double = rawValue.fixedInRange(min: min, max: max, step: step)
        
        setValue(to: valueFixed)
        
        action?(true)
    }
    
    private func dragEnded(drag: DragGesture.Value) {
        action?(false)
    }

    // MARK: Actions
    private func setValue(to value: Double) {
        withAnimation(model.animations.progress, { animatableValue = value })
        self.value = value
    }
    
    private func setAnimatableValue() {
        if animatableValue == nil || animatableValue != value {
            withAnimation(model.animations.progress, { animatableValue = value })
        }
    }

    // MARK: Progress
    private func progressWidth(in proxy: GeometryProxy) -> CGFloat {
        let value: CGFloat = .init((animatableValue ?? self.value) - min)
        let range: CGFloat = .init(max - min)
        let width: CGFloat = proxy.size.width

        return (value / range) * width
    }

    // MARK: Thumb Offset
    private func thumbOffset(in proxy: GeometryProxy) -> CGFloat {
        let progressW: CGFloat = progressWidth(in: proxy)
        let thumbW: CGFloat = model.layout.thumbDimension
        let offset: CGFloat = progressW - thumbW / 2
        
        return offset
    }
}

// MARK: - Preview
struct VSlider_Previews: PreviewProvider {
    @State private static var value: Double = 0.5

    static var previews: some View {
        VSlider(value: $value)
            .padding()
    }
}
