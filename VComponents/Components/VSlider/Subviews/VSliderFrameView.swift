//
//  VSliderFrameView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Frame View
struct VSliderFrameView<ThumbContent>: View where ThumbContent: View {
    // MARK: Properties
    private let animation: Animation?
    
    private let height: CGFloat
    private let cornerRadius: CGFloat
    
    private let trackColor: Color
    private let progressColor: Color
    
    private let isDisabled: Bool
    
    private let min, max: Double
    private let step: Double?
    
    @Binding private var value: Double
    
    private let action: ((Bool) -> Void)?
    
    private let thumbContent: ((GeometryProxy) -> ThumbContent)?
    
    // MARK: Initializers
    init<V>(
        animation: Animation?,
        
        height: CGFloat,
        cornerRadius: CGFloat,
        
        trackColor: Color,
        progressColor: Color,
        
        isDisabled: Bool,
        
        range: ClosedRange<V>,
        step: Double?,
        value: Binding<Double>,
        
        action: ((Bool) -> Void)?,
        @ViewBuilder thumbContent: @escaping (GeometryProxy) -> ThumbContent
    )
        where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint
    {
        self.animation = animation
        self.height = height
        self.cornerRadius = cornerRadius
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.isDisabled = isDisabled
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = step
        self._value = value
        self.action = action
        self.thumbContent = thumbContent
    }
}

extension VSliderFrameView where ThumbContent == Never {
    init<V>(
        animation: Animation?,
        
        height: CGFloat,
        cornerRadius: CGFloat,
        
        trackColor: Color,
        progressColor: Color,
        
        isDisabled: Bool,
        
        range: ClosedRange<V>,
        step: Double?,
        value: Binding<Double>,
        
        action: ((Bool) -> Void)?
    )
        where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint
    {
        self.animation = animation
        self.height = height
        self.cornerRadius = cornerRadius
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.isDisabled = isDisabled
        self.min = .init(range.lowerBound)
        self.max = .init(range.upperBound)
        self.step = step
        self._value = value
        self.action = action
        self.thumbContent = nil
    }
}

// MARK:- Body
extension VSliderFrameView {
    var body: some View {
        GeometryReader(content: { proxy in
            ZStack(alignment: .leading, content: {
                track
                progress(in: proxy)
            })
                .mask(RoundedRectangle(cornerRadius: cornerRadius))
            
                .ifLet(thumbContent, transform: { $0.overlay(thumb($1, in: proxy)) })
            
                .disabled(isDisabled)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ dragChanged($0, in: proxy) })
                        .onEnded(dragEnded)
                )
        })
            .frame(height: height)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(trackColor)
    }

    private func progress(in proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: progressWidth(in: proxy))

            .foregroundColor(progressColor)
    }
    
    private func thumb(
        @ViewBuilder _ thumbContent: @escaping (GeometryProxy) -> ThumbContent,
        in proxy: GeometryProxy
    ) -> some View {
        Group(content: {
            thumbContent(proxy)
        })
            .frame(maxWidth: .infinity, alignment: .leading)    // Must be put into group, as content already has frame
            .allowsHitTesting(false)
    }
}

// MARK:- Drag
private extension VSliderFrameView {
    func dragChanged(_ draggedValue: DragGesture.Value, in proxy: GeometryProxy) {
        switch animation {
        case nil: calculateDragChangedValue(draggedValue, in: proxy)
        case let animation?: withAnimation(animation, { calculateDragChangedValue(draggedValue, in: proxy) })
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

// MARK:- Progress
private extension VSliderFrameView {
    func progressWidth(in proxy: GeometryProxy) -> CGFloat {
        let range: CGFloat = .init(max - min)
        let width: CGFloat = proxy.size.width
        let value: CGFloat = .init(self.value)

        return (value / range) * width
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
struct VSliderFrameView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
