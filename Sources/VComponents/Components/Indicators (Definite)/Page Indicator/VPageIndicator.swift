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
/// Component can dynamically switch to `VCompactPageIndicator` using `ViewThatFits`.
///
///     var body: some View {
///         ViewThatFits(in: .horizontal, content: {
///             VPageIndicator(
///                 total: total,
///                 current: current
///             )
///
///             VCompactPageIndicator(
///                 total: total,
///                 current: current
///             )
///         })
///     }
///
/// Dots can be fully customized. For instance, we can get a "bullet" shape.
/// `frame()` modifier shouldn't be applied to the dot itself.
///
///     private let pageIndicatorUIModel: VPageIndicatorUIModel = {
///         var uiModel: VPageIndicatorUIModel = .init()
///         uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(16)
///         uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(16)
///         return uiModel
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: pageIndicatorUIModel,
///             total: total,
///             current: current,
///             dot: { (internalState, _) in
///                 ZStack(content: {
///                     Circle()
///                         .stroke(lineWidth: 1)
///                         .padding(1)
///
///                     Circle()
///                         .padding(3)
///                 })
///                 .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
///             }
///         )
///     }
///
/// Component can be stretched on its primary axis by removing primary dimension.
/// Standard circular shape doesn't support stretching.
///
///     private let pageIndicatorUIModel: VPageIndicatorUIModel = {
///         var uiModel: VPageIndicatorUIModel = .init()
///         uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(nil)
///         uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(4)
///         return uiModel
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: pageIndicatorUIModel,
///             total: total,
///             current: current,
///             dot: { (internalState, _) in
///                 RoundedRectangle(cornerRadius: 2)
///                     .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
///             }
///         )
///         .padding()
///     }
///
public struct VPageIndicator<Content>: View where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VPageIndicatorUIModel

    // MARK: Properties - State
    private func dotInternalState(i: Int) -> VPageIndicatorDotInternalState {
        .init(
            isSelected: i == current
        )
    }

    // MARK: Properties - Data
    private let total: Int
    private let current: Int

    // MARK: Properties - Content
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
        @ViewBuilder dot: @escaping (VPageIndicatorDotInternalState, Int) -> Content
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
            .reversedArray(uiModel.direction.isReversed)

        return Group(content: {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                uiModel.direction
                    .stackLayout(spacing: uiModel.spacing)
                    .callAsFunction({ ForEach(range, id: \.self, content: dotContentView) })
                    .applyIf(uiModel.appliesTransitionAnimation, transform: {
                        $0.animation(uiModel.transitionAnimation, value: current)
                    })

            } else {
                HVStack(
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
        })
    }
    
    private func dotContentView(i: Int) -> some View {
        let internalState: VPageIndicatorDotInternalState = dotInternalState(i: i)

        return Group(content: {
            switch dotContent {
            case .empty:
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                        .foregroundStyle(uiModel.dotColors.value(for: internalState))
                    
                    if uiModel.dotBorderWidths.value(for: internalState) > 0 {
                        RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                            .strokeBorder(lineWidth: uiModel.dotBorderWidths.value(for: internalState))
                            .foregroundStyle(uiModel.dotBorderColors.value(for: internalState))
                    }
                })
                
            case .content(let content):
                content(internalState, i)
            }
        })
        .frame(
            width:
                uiModel.direction.isHorizontal ?
                uiModel.dotWidths.value(for: internalState) :
                uiModel.dotHeights.value(for: internalState)
            ,
            height:
                uiModel.direction.isHorizontal ?
                uiModel.dotHeights.value(for: internalState) :
                uiModel.dotWidths.value(for: internalState)
        )
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
            DifferentSizesPreview().previewDisplayName("Different Sizes")
            CustomContentPreview().previewDisplayName("Custom Content")
            StretchedPreview().previewDisplayName("Stretched")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
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

    private struct DifferentSizesPreview: View {
        @State private var current: Int = VPageIndicator_Previews.current

        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    uiModel: {
                        var uiModel: VPageIndicatorUIModel = .init()
                        uiModel.dotWidths.selected? *= 3
                        return uiModel
                    }(),
                    total: total,
                    current: current
                )
                .onReceiveOfTimerIncrement($current, to: total-1)
            })
        }
    }

    private struct CustomContentPreview: View {
        private let pageIndicatorUIModel: VPageIndicatorUIModel = {
            var uiModel: VPageIndicatorUIModel = .init()
            uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(16)
            uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(16)
            return uiModel
        }()

        @State private var current: Int = VPageIndicator_Previews.current

        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    uiModel: pageIndicatorUIModel,
                    total: total,
                    current: current,
                    dot: { (internalState, _) in
                        ZStack(content: {
                            Circle()
                                .stroke(lineWidth: 1)
                                .padding(1)

                            Circle()
                                .padding(3)
                        })
                        .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
                    }
                )
                .onReceiveOfTimerIncrement($current, to: total-1)
            })
        }
    }
    
    private struct StretchedPreview: View {
        @State private var current: Int = VPageIndicator_Previews.current

        private let pageIndicatorUIModel: VPageIndicatorUIModel = {
            var uiModel: VPageIndicatorUIModel = .init()
            uiModel.direction = .leftToRight
            uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(nil)
            uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(4)
            return uiModel
        }()

        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    uiModel: pageIndicatorUIModel,
                    total: total,
                    current: current,
                    dot: { (internalState, _) in
                        RoundedRectangle(cornerRadius: 2)
                            .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
                    }
                )
                .padding()
            })
            .onReceiveOfTimerIncrement($current, to: total-1)
        }
    }
}
