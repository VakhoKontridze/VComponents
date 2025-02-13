//
//  VProgressBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore

// MARK: - V Progress Bar
/// Indicator component that represents progress towards the completion of a task.
///
///     @State private var progress: Double = 0.5
///
///     var body: some View {
///         VProgressBar(value: progress)
///             .padding()
///     }
///
public struct VProgressBar: View, Sendable {
    // MARK: Properties - UI Model
    private let uiModel: VProgressBarUIModel
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    
    @State private var progressBarSize: CGSize = .zero

    // MARK: Properties - Data
    private let range: ClosedRange<Double>
    private let value: Double
    
    // MARK: Initializers
    /// Initializes `VProgressBar` with value.
    public init<V>(
        uiModel: VProgressBarUIModel = .init(),
        total: V = 1,
        value: V
    )
        where V: BinaryFloatingPoint
    {
        self.uiModel = uiModel
        self.range = 0...Double(total)
        self.value = {
            let value: Double = .init(value)
            let min: Double = 0
            let max: Double = .init(total)
            
            return value.clamped(min: min, max: max)
        }()
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: uiModel.direction.toAlignment, content: {
            trackView
            progressView
            borderView
        })
        .clipShape(.rect(cornerRadius: uiModel.cornerRadius))
        .frame(
            width: uiModel.direction.isHorizontal ? nil : uiModel.height,
            height: uiModel.direction.isHorizontal ? uiModel.height : nil
        )
        .getSize(assignTo: $progressBarSize)
        .applyIf(uiModel.appliesProgressAnimation, transform: {
            $0.animation(uiModel.progressAnimation, value: value)
        })
    }
    
    private var trackView: some View {
        Rectangle()
            .foregroundStyle(uiModel.trackColor)
    }
    
    private var progressView: some View {
        UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
                trailingCorners: uiModel.roundsProgressViewTrailingCorners ? uiModel.cornerRadius : 0
            )
            .cornersAdjustedForDirection(uiModel.direction)
        )
        .frame(
            width: uiModel.direction.isHorizontal ? progressWidth : nil,
            height: uiModel.direction.isHorizontal ? nil : progressWidth
        )
        .foregroundStyle(uiModel.progressColor)
    }
    
    @ViewBuilder 
    private var borderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColor, lineWidth: borderWidth)
        }
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let width: CGFloat = progressBarSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        return value * width
    }
}

// MARK: - Preview
#if DEBUG

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("*", body: {
    @Previewable @State var value: Double = 0

    PreviewContainer(content: {
        VProgressBar(value: value)
            .padding(.horizontal)
    })
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("States", body: {
    @Previewable @State var value: Double = 0

    PreviewContainer(content: {
        PreviewRow(nil, content: {
            VProgressBar(value: value)
                .padding(.horizontal)
        })

        PreviewHeader("Native")

        PreviewRow(nil, content: {
            ProgressView(value: value)
                .progressViewStyle(.linear)
                .padding(.horizontal)
        })
    })
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Layout Directions", body: {
    @Previewable @State var value: Double = 0 // '@Previewable' items must be at the beginning of the preview block
    
    let length: CGFloat = {
#if os(iOS)
        250
#elseif os(macOS)
        200
#elseif os(tvOS)
        250
#elseif os(watchOS)
        100
#elseif os(visionOS)
        250
#endif
    }()

    PreviewContainer(content: {
        PreviewRow("Left-to-Right", content: {
            VProgressBar(
                uiModel: {
                    var uiModel: VProgressBarUIModel = .init()
                    uiModel.direction = .leftToRight
                    return uiModel
                }(),
                value: value
            )
            .frame(width: length)
            .padding(.horizontal)
        })

        PreviewRow("Right-to-Left", content: {
            VProgressBar(
                uiModel: {
                    var uiModel: VProgressBarUIModel = .init()
                    uiModel.direction = .rightToLeft
                    return uiModel
                }(),
                value: value
            )
            .frame(width: length)
            .padding(.horizontal)
        })

        HStack(spacing: 20, content: {
            PreviewRow("Top-to-Bottom", content: {
                VProgressBar(
                    uiModel: {
                        var uiModel: VProgressBarUIModel = .init()
                        uiModel.direction = .topToBottom
                        return uiModel
                    }(),
                    value: value
                )
                .frame(height: length)
                .padding(.horizontal)
            })

            PreviewRow("Bottom-to-Top", content: {
                VProgressBar(
                    uiModel: {
                        var uiModel: VProgressBarUIModel = .init()
                        uiModel.direction = .bottomToTop
                        return uiModel
                    }(),
                    value: value
                )
                .frame(height: length)
                .padding(.horizontal)
            })
        })
    })
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
})

#endif
