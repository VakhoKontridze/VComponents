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
            track
            progress
            border
        })
        .clipShape(RoundedRectangle(cornerRadius: uiModel.cornerRadius))
        .frame(
            width: uiModel.direction.isHorizontal ? nil : uiModel.height,
            height: uiModel.direction.isHorizontal ? uiModel.height : nil
        )
        .getSize({ progressBarSize = $0 })
        .applyIf(uiModel.appliesProgressAnimation, transform: {
            $0.animation(uiModel.progressAnimation, value: value)
        })
    }
    
    private var track: some View {
        Rectangle()
            .foregroundStyle(uiModel.trackColor)
    }
    
    private var progress: some View {
        Rectangle()
            .frame(
                width: uiModel.direction.isHorizontal ? progressWidth : nil,
                height: uiModel.direction.isHorizontal ? nil : progressWidth
            )
            .cornerRadius(uiModel.cornerRadius, corners: uiModel.progressViewRoundedCorners)
            .foregroundStyle(uiModel.progressColor)
    }
    
    @ViewBuilder private var border: some View {
        if uiModel.borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColor, lineWidth: uiModel.borderWidth)
        }
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let width: CGFloat = progressBarSize.dimension(isWidth: uiModel.direction.isHorizontal)
        
        return value * width
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct VProgressBar_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            BorderPreview().previewDisplayName("Border")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
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

    private struct BorderPreview: View {
        @State private var value: Double = 0

        var body: some View {
            PreviewContainer(content: {
                VProgressBar(
                    uiModel: {
                        var uiModel: VProgressBarUIModel = .init()
                        uiModel.borderWidth = 1
                        uiModel.borderColor = uiModel.trackColor.darken(by: 0.3)
                        return uiModel
                    }(),
                    value: value
                )
                .padding()
            })
            .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
        }
    }
    
    private struct LayoutDirectionsPreview: View {
        private let dimension: CGFloat = {
#if os(iOS)
            250
#elseif os(macOS)
            300
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
                                uiModel.direction = .leftToRight
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
                                uiModel.direction = .rightToLeft
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
                                    uiModel.direction = .topToBottom
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
                                    uiModel.direction = .bottomToTop
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
