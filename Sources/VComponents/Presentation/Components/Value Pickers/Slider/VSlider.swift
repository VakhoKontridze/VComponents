//
//  VSlider.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

/// Value picker component that selects value from a bounded linear range of values.
///
///     @State private var value: Double = 0.5
///
///     var body: some View {
///         VSlider(value: $value)
///             .padding()
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VSlider: View {
    // MARK: Properties - Appearance
    private let appearance: VSliderAppearance
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat
    
    @State private var sliderSize: CGSize = .zero
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VSliderInternalState {
        .init(
            isEnabled: isEnabled
        )
    }

    // MARK: Properties - Value Range
    private let range: ClosedRange<Double>
    private let step: Double?
    
    // MARK: Properties - Value
    @Binding private var value: Double

    // MARK: Properties - Actions
    private let onChange: ((Bool) -> Void)?
    
    // MARK: Initializers
    /// Initializes `VSlider` with value.
    public init<V>(
        appearance: VSliderAppearance = .init(),
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        value: Binding<V>,
        onChange: ((Bool) -> Void)? = nil
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.appearance = appearance

        self.range = ClosedRange(
            lower: Double(range.lowerBound),
            upper: Double(range.upperBound)
        )
        self.step = step.map { Double($0) }

        self._value = Binding( // Like native `Slider`, clamps initial value, but not subsequent ones
            get: { Double(value.wrappedValue.clamped(to: range, step: step)) },
            set: { value.wrappedValue = V($0) }
        )

        self.onChange = onChange
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: appearance.direction.toAlignment) {
            ZStack(alignment: appearance.direction.toAlignment) {
                trackView
                progressView
                borderView
            }
            .clipShape(.rect(cornerRadius: appearance.cornerRadius))
            .frame(
                width: appearance.direction.isHorizontal ? nil : appearance.height,
                height: appearance.direction.isHorizontal ? appearance.height : nil
            )
            
            thumbView
        }
        .onGeometryChange(of: { $0.size }) { sliderSize = $0 }
        .gesture(dragGesture, isEnabled: appearance.bodyIsDraggable)
        .applyIf(appearance.appliesProgressAnimation) { $0.animation(appearance.progressAnimation, value: value) }
    }
    
    private var trackView: some View {
        Rectangle()
            .foregroundStyle(appearance.trackColors.value(for: internalState))
    }
    
    private var progressView: some View {
        UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
                trailingCorners: appearance.roundsProgressViewTrailingCorners ? appearance.cornerRadius : 0
            )
            .cornersAdjustedForDirection(appearance.direction)
        )
        .frame(
            width: appearance.direction.isHorizontal ? progressWidth : nil,
            height: appearance.direction.isHorizontal ? nil : progressWidth
        )
        .foregroundStyle(appearance.progressColors.value(for: internalState))
    }
    
    @ViewBuilder 
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }
    
    @ViewBuilder 
    private var thumbView: some View {
        if 
            appearance.thumbSize.width > 0,
            appearance.thumbSize.height > 0 
        {
            ZStack { // Used for additional frame
                ZStack {
                    thumbBackgroundView
                    thumbBorderView
                }
                .frame(size: appearance.thumbSize)
                .offset(
                    x: appearance.direction.isHorizontal ? thumbOffset.withOppositeSign(appearance.direction.isReversed) : 0,
                    y: appearance.direction.isHorizontal ? 0 : thumbOffset.withOppositeSign(appearance.direction.isReversed)
                )
            }
            .frame( // Must be put into group, as content already has frame
                maxWidth: appearance.direction.isHorizontal ? CGFloat.infinity : nil,
                maxHeight: appearance.direction.isHorizontal ? nil : CGFloat.infinity,
                alignment: appearance.direction.toAlignment
            )
            .allowsHitTesting(appearance.bodyIsDraggable ? false : true) // `true` is default value
            .gesture(dragGesture, isEnabled: !appearance.bodyIsDraggable)
        }
    }

    private var thumbBackgroundView: some View {
        RoundedRectangle(cornerRadius: appearance.thumbCornerRadius)
            .foregroundStyle(appearance.thumbColors.value(for: internalState))
            .shadow(
                color: appearance.thumbShadowColors.value(for: internalState),
                radius: appearance.thumbShadowRadius,
                offset: appearance.thumbShadowOffset // No need to reverse coordinates on shadow
            )

    }

    @ViewBuilder
    private var thumbBorderView: some View {
        let borderWidth: CGFloat = appearance.thumbBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.thumbCornerRadius)
                .strokeBorder(appearance.thumbBorderColors.value(for: internalState), lineWidth: borderWidth)
        }
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value) {
        let value: Double = dragValue.location.coordinate(isX: appearance.direction.isHorizontal)
        let boundRange: Double = range.boundRange
        guard let width: CGFloat = sliderSize.dimension(isWidth: appearance.direction.isHorizontal).nonZero else { return }

        let rawValue: Double = ((value / width) * boundRange + range.lowerBound)
            .invertedFromMax(
                range.upperBound,
                if: layoutDirection.isRightToLeft || appearance.direction.isReversed
            )

        let valueFixed: Double = rawValue.clamped(to: range, step: step)
        
        setValue(to: valueFixed)
        
        onChange?(true)
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        onChange?(false)
    }
    
    // MARK: Actions
    private func setValue(to value: Double) {
        self.value = value
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let value: CGFloat = value - range.lowerBound
        guard let boundRange: Double = range.boundRange.nonZero else { return 0 }
        let width: CGFloat = sliderSize.dimension(isWidth: appearance.direction.isHorizontal)
        
        return (value / boundRange) * width
    }
    
    // MARK: Thumb Offset
    private var thumbOffset: CGFloat {
        let thumbWidth: CGFloat = appearance.thumbSize.dimension(isWidth: appearance.direction.isHorizontal)

        return progressWidth - thumbWidth/2
    }
}

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var value: Double = 0.5

    PreviewContainer {
        VSlider(value: $value)
            .padding(.horizontal)
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VSlider(value: .constant(0.5))
                .padding(.horizontal)
        }

        PreviewRow("Disabled") {
            VSlider(value: .constant(0.5))
                .disabled(true)
                .padding(.horizontal)
        }

        PreviewHeader("Native")

        PreviewRow("Enabled") {
            Slider(value: .constant(0.5))
                .padding(.horizontal)
        }

        PreviewRow("Disabled") {
            Slider(value: .constant(0.5))
                .disabled(true)
                .padding(.horizontal)
        }
    }
}

#Preview("Layout Directions") {
    @Previewable @State var value: Double = 0.5 // '@Previewable' items must be at the beginning of the preview block
    
    let length: CGFloat = {
#if os(iOS)
        250
#elseif os(macOS)
        200
#else
        fatalError()
#endif
    }()

    PreviewContainer {
        PreviewRow("Left-to-Right") {
            VSlider(
                appearance: {
                    var appearance: VSliderAppearance = .init()
                    appearance.direction = .leftToRight
                    return appearance
                }(),
                value: $value
            )
            .frame(width: length)
        }
        
        PreviewRow("Right-to-Left") {
            VSlider(
                appearance: {
                    var appearance: VSliderAppearance = .init()
                    appearance.direction = .rightToLeft
                    return appearance
                }(),
                value: $value
            )
            .frame(width: length)
        }
        
        HStack(spacing: 20) {
            PreviewRow("Top-to-Bottom") {
                VSlider(
                    appearance: {
                        var appearance: VSliderAppearance = .init()
                        appearance.direction = .topToBottom
                        return appearance
                    }(),
                    value: $value
                )
                .frame(height: length)
            }
            
            PreviewRow("Bottom-to-Top") {
                VSlider(
                    appearance: {
                        var appearance: VSliderAppearance = .init()
                        appearance.direction = .bottomToTop
                        return appearance
                    }(),
                    value: $value
                )
                .frame(height: length)
            }
        }
    }
}

#Preview("Step") {
    @Previewable @State var value: Double = 0.5

    PreviewContainer {
        VSlider(
            step: 0.1,
            value: $value
        )
        .padding(.horizontal)
    }
}

#Preview("Draggable Body") {
    @Previewable @State var value: Double = 0.5

    PreviewContainer {
        VSlider(
            appearance: {
                var appearance: VSliderAppearance = .init()
                appearance.bodyIsDraggable = true
                return appearance
            }(),
            value: $value
        )
        .padding(.horizontal)
    }
}

#endif

#endif
