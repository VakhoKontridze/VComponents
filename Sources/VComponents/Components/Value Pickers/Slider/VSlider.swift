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
/// UI Model, range, step, and onChange callback can be passed as parameters.
///
///     @State private var value: Double = 0.5
///
///     var body: some View {
///         VSlider(value: $value)
///             .padding()
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VSlider: View {
    // MARK: Properties
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    private let uiModel: VSliderUIModel
    
    private let min, max: Double
    private var range: ClosedRange<Double> { min...max }
    private let step: Double?
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VSliderInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var value: Double
    
    private let action: ((Bool) -> Void)?
    
    @State private var sliderSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VSlider` with value.
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
        self.min = Double(range.lowerBound)
        self.max = Double(range.upperBound)
        self.step = step.map { Double($0) }
        self._value = Binding(
            get: { Double(value.wrappedValue.clamped(to: range, step: step)) },
            set: { value.wrappedValue = V($0) }
        )
        self.action = action
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: uiModel.layout.direction.alignment, content: {
            ZStack(alignment: uiModel.layout.direction.alignment, content: {
                track
                progress
                border
            })
            .mask(RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius))
            .frame(
                width: uiModel.layout.direction.isHorizontal ? nil : uiModel.layout.height,
                height: uiModel.layout.direction.isHorizontal ? uiModel.layout.height : nil
            )
            
            thumb
        })
        .onSizeChange(perform: { sliderSize = $0 })
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(dragChanged)
                .onEnded(dragEnded)
        )
        .padding(
            uiModel.layout.direction.isHorizontal ? .horizontal : .vertical,
            uiModel.layout.thumbDimension / 2
        )
        .if(uiModel.animations.appliesProgressAnimation, transform: {
            $0.animation(uiModel.animations.progress, value: value)
        })
    }
    
    private var track: some View {
        Rectangle()
            .foregroundColor(uiModel.colors.track.value(for: internalState))
    }
    
    private var progress: some View {
        Rectangle()
            .frame(
                width: uiModel.layout.direction.isHorizontal ? progressWidth : nil,
                height: uiModel.layout.direction.isHorizontal ? nil : progressWidth
            )
            .cornerRadius(uiModel.layout.cornerRadius, corners: uiModel.layout.progressViewRoundedCorners)
            .foregroundColor(uiModel.colors.progress.value(for: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        }
    }
    
    @ViewBuilder private var thumb: some View {
        if uiModel.layout.thumbDimension > 0 {
            Group(content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .foregroundColor(uiModel.colors.thumb.value(for: internalState))
                        .shadow(
                            color: uiModel.colors.thumbShadow.value(for: internalState),
                            radius: uiModel.colors.thumbShadowRadius,
                            offset: uiModel.colors.thumbShadowOffset // No need to reverse coordinates on shadow
                        )
                    
                    RoundedRectangle(cornerRadius: uiModel.layout.thumbCornerRadius)
                        .strokeBorder(uiModel.colors.thumbBorder.value(for: internalState), lineWidth: uiModel.layout.thumbBorderWidth)
                })
                .frame(dimension: uiModel.layout.thumbDimension)
                .offset(
                    x: uiModel.layout.direction.isHorizontal ? thumbOffset.withOppositeSign(if: uiModel.layout.direction.isReversed) : 0,
                    y: uiModel.layout.direction.isHorizontal ? 0 : thumbOffset.withOppositeSign(if: uiModel.layout.direction.isReversed)
                )
            })
            .frame( // Must be put into group, as content already has frame
                maxWidth: uiModel.layout.direction.isHorizontal ? .infinity : nil,
                maxHeight: uiModel.layout.direction.isHorizontal ? nil : .infinity,
                alignment: uiModel.layout.direction.alignment
            )
            .allowsHitTesting(false)
        }
    }
    
    // MARK: Drag
    private func dragChanged(dragValue: DragGesture.Value) {
        let rawValue: Double = {
            let value: Double = dragValue.location.coordinate(isX: uiModel.layout.direction.isHorizontal)
            let range: Double = max - min
            let width: Double = sliderSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)
            
            return ((value / width) * range + min)
                .invertedFromMax(
                    max,
                    if: layoutDirection == .rightToLeft || uiModel.layout.direction.isReversed
                )
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
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let value: CGFloat = value - min
        let range: CGFloat = max - min
        let width: CGFloat = sliderSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)
        
        return (value / range) * width
    }
    
    // MARK: Thumb Offset
    private var thumbOffset: CGFloat {
        progressWidth - uiModel.layout.thumbDimension/2
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VSlider_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .ifLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var value: Double { 0.5 }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var value: Double = VSlider_Previews.value
        
        var body: some View {
            PreviewContainer(content: {
                VSlider(value: $value)
                    .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VSlider(value: .constant(value))
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VSlider(value: .constant(value))
                            .disabled(true)
                    }
                )
                
                PreviewSectionHeader("Native")
                
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        Slider(value: .constant(value))
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        Slider(value: .constant(value))
                            .disabled(true)
                    }
                )
            })
        }
    }
    
    private struct LayoutDirectionsPreview: View {
        private let dimension: CGFloat = {
#if os(iOS)
            return 250
#elseif os(macOS)
            return 300
#else
            fatalError() // Not supported
#endif
        }()
        
        @State private var value: Double = VSlider_Previews.value
        
        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.macOS],
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Left-to-Right",
                        content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.layout.direction = .leftToRight
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(width: dimension)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Right-to-Left",
                        content: {
                            VSlider(
                                uiModel: {
                                    var uiModel: VSliderUIModel = .init()
                                    uiModel.layout.direction = .rightToLeft
                                    return uiModel
                                }(),
                                value: $value
                            )
                            .frame(width: dimension)
                        }
                    )
                    
                    HStack(content: {
                        PreviewRow(
                            axis: .vertical,
                            title: "Top-to-Bottom",
                            content: {
                                VSlider(
                                    uiModel: {
                                        var uiModel: VSliderUIModel = .init()
                                        uiModel.layout.direction = .topToBottom
                                        return uiModel
                                    }(),
                                    value: $value
                                )
                                .frame(height: dimension)
                            }
                        )
                        
                        PreviewRow(
                            axis: .vertical,
                            title: "Bottom-to-Top",
                            content: {
                                VSlider(
                                    uiModel: {
                                        var uiModel: VSliderUIModel = .init()
                                        uiModel.layout.direction = .bottomToTop
                                        return uiModel
                                    }(),
                                    value: $value
                                )
                                .frame(height: dimension)
                            }
                        )
                    })
                }
            )
        }
    }
}
