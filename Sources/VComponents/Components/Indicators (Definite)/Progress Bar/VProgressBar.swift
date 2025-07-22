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
public struct VProgressBar: View {
    // MARK: Properties - Appearance
    private let appearance: VProgressBarAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    
    @State private var progressBarSize: CGSize = .zero

    // MARK: Properties - Data
    private let range: ClosedRange<Double>
    private let value: Double
    
    // MARK: Initializers
    /// Initializes `VProgressBar` with value.
    public init<V>(
        appearance: VProgressBarAppearance = .init(),
        value: V,
        total: V = 1
    )
        where V: BinaryFloatingPoint
    {
        self.appearance = appearance
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
        .onGeometryChange(of: { $0.size }) { progressBarSize = $0 }
        .applyIf(appearance.appliesProgressAnimation) { $0.animation(appearance.progressAnimation, value: value) }
    }
    
    private var trackView: some View {
        Rectangle()
            .foregroundStyle(appearance.trackColor)
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
        .foregroundStyle(appearance.progressColor)
    }
    
    @ViewBuilder 
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColor, lineWidth: borderWidth)
        }
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let width: CGFloat = progressBarSize.dimension(isWidth: appearance.direction.isHorizontal)
        
        return value * width
    }
}

// MARK: - Preview
#if DEBUG

#Preview("*") {
    @Previewable @State var value: Double = 0

    PreviewContainer {
        VProgressBar(value: value)
            .padding(.horizontal)
    }
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
}

#Preview("States") {
    @Previewable @State var value: Double = 0

    PreviewContainer {
        PreviewRow {
            VProgressBar(value: value)
                .padding(.horizontal)
        }

        PreviewHeader("Native")

        PreviewRow {
            ProgressView(value: value)
                .progressViewStyle(.linear)
                .padding(.horizontal)
        }
    }
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
}

#Preview("Layout Directions") {
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

    PreviewContainer {
        PreviewRow("Left-to-Right") {
            VProgressBar(
                appearance: {
                    var appearance: VProgressBarAppearance = .init()
                    appearance.direction = .leftToRight
                    return appearance
                }(),
                value: value
            )
            .frame(width: length)
            .padding(.horizontal)
        }

        PreviewRow("Right-to-Left") {
            VProgressBar(
                appearance: {
                    var appearance: VProgressBarAppearance = .init()
                    appearance.direction = .rightToLeft
                    return appearance
                }(),
                value: value
            )
            .frame(width: length)
            .padding(.horizontal)
        }

        HStack(spacing: 20) {
            PreviewRow("Top-to-Bottom") {
                VProgressBar(
                    appearance: {
                        var appearance: VProgressBarAppearance = .init()
                        appearance.direction = .topToBottom
                        return appearance
                    }(),
                    value: value
                )
                .frame(height: length)
                .padding(.horizontal)
            }

            PreviewRow("Bottom-to-Top") {
                VProgressBar(
                    appearance: {
                        var appearance: VProgressBarAppearance = .init()
                        appearance.direction = .bottomToTop
                        return appearance
                    }(),
                    value: value
                )
                .frame(height: length)
                .padding(.horizontal)
            }
        }
    }
    .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
}

#endif
