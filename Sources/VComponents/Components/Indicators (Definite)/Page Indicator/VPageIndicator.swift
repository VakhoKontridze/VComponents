//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator
/// Indicator component that represents selection in page control.
///
///     private let total: Int = 10
///     @State private var current: Int = 4
///
///     var body: some View {
///         VPageIndicator(
///             total: total,
///             current: current
///         )
///     }
///
/// Direction can be changed via `direction` in UI models, or passing `vertical` instance.
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             current: current
///         )
///     }
///
/// Dots can be fully customized. For instance, we can get a "bullet" shape.
/// `frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.dotWidth = 15
///                 uiModel.dotHeight = 15
///                 return uiModel
///             }(),
///             total: total,
///             current: current,
///             dot: {
///                 ZStack(content: {
///                     Circle()
///                         .stroke(lineWidth: 1)
///                         .padding(1)
///
///                     Circle()
///                         .padding(3)
///                 })
///             }
///         )
///         .padding()
///     }
///
/// Component can be stretched on its primary axis by removing primary dimension.
/// Standard circular shape doesn't support stretching.
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.dotWidth = nil
///                 uiModel.dotHeight = 5
///                 return uiModel
///             }(),
///             total: total,
///             current: current,
///             dot: { RoundedRectangle(cornerRadius: 2.5) }
///         )
///         .padding()
///     }
///
public struct VPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorUIModel
    
    private let total: Int
    private let current: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>
    
    // MARK: Initializers
    /// Initializes `VPageIndicator` with total and current index.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        current: Int
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .empty
    }
    
    /// Initializes `VPageIndicator` with total, current index, and custom dot content.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .content(content: dot)
    }
    
    // MARK: Initializers - Internal
    init(
        uiModel: VPageIndicatorUIModel,
        total: Int,
        current: Int,
        dotContent: VPageIndicatorDotContent<Content>
    ) {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = dotContent
    }
    
    // MARK: Body
    public var body: some View {
        let range: [Int] = (0..<total)
            .reversedArray(if: uiModel.direction.isReversed)
        
        return HVStack(
            spacing: uiModel.spacing,
            isHorizontal: uiModel.direction.isHorizontal,
            content: {
                ForEach(range, id: \.self, content: dotContentView)
            }
        )
        .applyIf(uiModel.appliesTransitionAnimation, transform: {
            $0.animation(uiModel.transitionAnimation, value: current)
        })
    }
    
    private func dotContentView(i: Int) -> some View {
        Group(content: {
            switch dotContent {
            case .empty:
                ZStack(content: {
                    Circle()
                        .foregroundColor(current == i ? uiModel.selectedDotColor : uiModel.dotColor)
                    
                    if uiModel.dotBorderWidth > 0 {
                        Circle()
                            .strokeBorder(lineWidth: uiModel.dotBorderWidth)
                            .foregroundColor(current == i ? uiModel.selectedDotBorderColor : uiModel.dotBorderColor)
                    }
                })
                
            case .content(let content):
                content()
                    .foregroundColor(current == i ? uiModel.selectedDotColor : uiModel.dotColor)
            }
        })
        .frame(
            width: uiModel.direction.isHorizontal ? uiModel.dotWidth : uiModel.dotHeight,
            height: uiModel.direction.isHorizontal ? uiModel.dotHeight : uiModel.dotWidth
        )
        .scaleEffect(current == i ? 1 : uiModel.unselectedDotScale)
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VPageIndicator_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
            StretchedPreview().previewDisplayName("Stretched")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var total: Int { 10 }
    private static var current: Int { 0 }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var current: Int = VPageIndicator_Previews.current
        
        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    total: total,
                    current: current
                )
                .onReceiveOfTimerIncrement($current, to: total-1)
            })
        }
    }
    
    private struct LayoutDirectionsPreview: View {
        @State private var current: Int = VPageIndicator_Previews.current
        
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Left-to-Right",
                    content: {
                        VPageIndicator(
                            uiModel: {
                                var uiModel: VPageIndicatorUIModel = .init()
                                uiModel.direction = .leftToRight
                                return uiModel
                            }(),
                            total: total,
                            current: current
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Right-to-Left",
                    content: {
                        VPageIndicator(
                            uiModel: {
                                var uiModel: VPageIndicatorUIModel = .init()
                                uiModel.direction = .rightToLeft
                                return uiModel
                            }(),
                            total: total,
                            current: current
                        )
                    }
                )
                
                HStack(content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Top-to-Bottom",
                        content: {
                            VPageIndicator(
                                uiModel: {
                                    var uiModel: VPageIndicatorUIModel = .init()
                                    uiModel.direction = .topToBottom
                                    return uiModel
                                }(),
                                total: total,
                                current: current
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Bottom-to-Top",
                        content: {
                            VPageIndicator(
                                uiModel: {
                                    var uiModel: VPageIndicatorUIModel = .init()
                                    uiModel.direction = .bottomToTop
                                    return uiModel
                                }(),
                                total: total,
                                current: current
                            )
                        }
                    )
                })
            })
            .onReceiveOfTimerIncrement($current, to: total-1)
        }
    }
    
    private struct StretchedPreview: View {
        @State private var current: Int = VPageIndicator_Previews.current
        
        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    uiModel: {
                        var uiModel: VPageIndicatorUIModel = .init()
                        uiModel.direction = .leftToRight
                        uiModel.dotWidth = nil
                        uiModel.dotHeight = 5
                        return uiModel
                    }(),
                    total: total,
                    current: current,
                    dot: { RoundedRectangle(cornerRadius: 2.5) }
                )
                .padding()
            })
            .onReceiveOfTimerIncrement($current, to: total-1)
        }
    }
}