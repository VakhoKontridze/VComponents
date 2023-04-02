//
//  VProgressBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore

// MARK: - V Progress Bar
/// Indicator component that indicates progress towards completion of a task.
///
/// UI Model and total value can be passed as parameters.
///
///     @State private var progress: Double = 0.5
///
///     var body: some View {
///         VProgressBar(value: progress)
///             .padding()
///     }
///
public struct VProgressBar: View {
    // MARK: Properties
    private let uiModel: VProgressBarUIModel
    
    private let range: ClosedRange<Double>
    private let value: Double
    
    @State private var progressBarSize: CGSize = .zero
    
    // MARK: Initializers
    /// Initializes `VProgressBar` with value.
    public init<V>(
        uiModel: VProgressBarUIModel = .init(),
        total: V = 1,
        value: V
    )
        where
            V: BinaryFloatingPoint
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
            .onSizeChange(perform: { progressBarSize = $0 })
            .animation(uiModel.animations.progress, value: value)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(uiModel.colors.track)
    }

    private var progress: some View {
        Rectangle()
            .frame(
                width: uiModel.layout.direction.isHorizontal ? progressWidth : nil,
                height: uiModel.layout.direction.isHorizontal ? nil : progressWidth
            )
            .cornerRadius(uiModel.layout.cornerRadius, corners: uiModel.layout.progressViewRoundedCorners)
            .foregroundColor(uiModel.colors.progress)
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.layout.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border, lineWidth: uiModel.layout.borderWidth)
        }
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let width: CGFloat = progressBarSize.dimension(isWidth: uiModel.layout.direction.isHorizontal)

        return value * width
    }
}

// MARK: - Preview
struct VProgressBar_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var value: Double = 0
        
        var body: some View {
            PreviewContainer(content: {
                VProgressBar(value: value)
                    .padding()
            })
                .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
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
        
        @State private var value: Double = 0
        
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Left-to-Right",
                    content: {
                        VProgressBar(
                            uiModel: {
                                var uiModel: VProgressBarUIModel = .init()
                                uiModel.layout.direction = .leftToRight
                                return uiModel
                            }(),
                            value: value
                        )
                            .frame(width: dimension)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Right-to-Left",
                    content: {
                        VProgressBar(
                            uiModel: {
                                var uiModel: VProgressBarUIModel = .init()
                                uiModel.layout.direction = .rightToLeft
                                return uiModel
                            }(),
                            value: value
                        )
                            .frame(width: dimension)
                    }
                )
                
                HStack(content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Top-to-Bottom",
                        content: {
                            VProgressBar(
                                uiModel: {
                                    var uiModel: VProgressBarUIModel = .init()
                                    uiModel.layout.direction = .topToBottom
                                    return uiModel
                                }(),
                                value: value
                            )
                                .frame(height: dimension)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Bottom-to-Top",
                        content: {
                            VProgressBar(
                                uiModel: {
                                    var uiModel: VProgressBarUIModel = .init()
                                    uiModel.layout.direction = .bottomToTop
                                    return uiModel
                                }(),
                                value: value
                            )
                                .frame(height: dimension)
                        }
                    )
                })
            })
                .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
        }
    }
}
