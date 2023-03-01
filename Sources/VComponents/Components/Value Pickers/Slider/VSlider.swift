//
//  VSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Slider
/// Value picker component that selects value from a bounded linear range of values.
///
/// UI Model, range, step, state, and onChange callback can be passed as parameters.
///
///     @State private var value: Double = 0.5
///
///     var body: some View {
///         VSlider(value: $value)
///             .padding()
///     }
///
public struct VSlider: View {
    // MARK: Properties
    private let uiModel: VSliderUIModel
    
    private let min, max: Double
    private var range: ClosedRange<Double> { min...max }
    private let step: Double?
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VSliderInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var value: Double
    
    private let action: ((Bool) -> Void)?
    
    @State private var sliderWidth: CGFloat = 0
    
    private var hasThumb: Bool { uiModel.layout.thumbDimension > 0 }
    
    // MARK: Initializers
    /// Initializes component with value.
    public init<V>(
        uiModel: VSliderUIModel = .init(),
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        value: Binding<V>,
        onChange action: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.uiModel = uiModel
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = step.map { .init($0) }
        self._value = .init(
            get: { .init(value.wrappedValue.clamped(to: range, step: step)) },
            set: { value.wrappedValue = .init($0) }
        )
        self.action = action
    }

    // MARK: Body
    public var body: some View {
        ZStack(alignment: .leading, content: {
            track
            progress
        })
            .mask(RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius))
            .overlay(thumb)
            .frame(height: uiModel.layout.height)
            .readSize(onChange: { sliderWidth = $0.width })
            .padding(.horizontal, uiModel.layout.thumbDimension / 2)
            .animation(uiModel.animations.progress, value: value)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(dragChanged)
                    .onEnded(dragEnded)
            )
            .disabled(!internalState.isEnabled)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(uiModel.colors.track.value(for: internalState))
    }

    private var progress: some View {
        Rectangle()
            .frame(width: progressWidth)
            .cornerRadius(uiModel.layout.cornerRadius, corners: uiModel.layout.progressViewRoundedCorners)
            .foregroundColor(uiModel.colors.progress.value(for: internalState))
    }
    
    @ViewBuilder private var thumb: some View {
        if hasThumb {
            Group(content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .foregroundColor(uiModel.colors.thumb.value(for: internalState))
                        .shadow(color: uiModel.colors.thumbShadow.value(for: internalState), radius: uiModel.layout.thumbShadowRadius)
                    
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .strokeBorder(uiModel.colors.thumbBorder.value(for: internalState), lineWidth: uiModel.layout.thumbBorderWidth)
                })
                    .frame(dimension: uiModel.layout.thumbDimension)
                    .offset(x: thumbOffset)
            })
                .frame(maxWidth: .infinity, alignment: .leading)    // Must be put into group, as content already has frame
                .allowsHitTesting(false)
        }
    }

    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value) {
        let rawValue: Double = {
            let value: Double = .init(dragValue.location.x)
            let range: Double = max - min
            let width: Double = .init(sliderWidth)

            return (value / width) * range + min
        }()
        
        let valueFixed: Double = rawValue.clamped(min: min, max: max, step: step)
        
        setValue(to: valueFixed)
        
        action?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        action?(false)
    }

    // MARK: Actions
    private func setValue(to value: Double) {
        self.value = value
    }

    // MARK: Progress
    private var progressWidth: CGFloat {
        let value: CGFloat = .init(value - min)
        let range: CGFloat = .init(max - min)
        let width: CGFloat = sliderWidth

        return (value / range) * width
    }

    // MARK: Thumb Offset
    private var thumbOffset: CGFloat {
        let progressW: CGFloat = progressWidth
        let thumbW: CGFloat = uiModel.layout.thumbDimension
        let offset: CGFloat = progressW - thumbW / 2
        
        return offset
    }
}

// MARK: - Preview
struct VSlider_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    private struct Preview: View {
        @State private var value: Double = 0.5
        
        var body: some View {
            VSlider(value: $value)
                .padding()
        }
    }
}
