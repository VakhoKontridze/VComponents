//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator
/// Indicator component that indicates selection in page control.
///
/// UI model can be passed as parameter.
///
///     private let total: Int = 10
///     @State private var selectedIndex: Int = 4
///
///     var body: some View {
///         VPageIndicator(
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can fully customize dot by passing a `dot` parameter. For instance, we can get a "bullet" shape.
/// `.frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VPageIndicator(
///             type: uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.layout.dotDimensionPrimaryAxis = 15
///                 uiModel.layout.dotDimensionSecondaryAxis = 15
///                 return uiModel
///             }(),
///             total: total,
///             selectedIndex: selectedIndex,
///             dot: {
///                 ZStack(content: {
///                     Circle()
///                         .stroke(lineWidth: 1)
///
///                     Circle()
///                         .padding(3)
///                 })
///             }
///         )
///             .padding()
///     }
///
/// You can stretch the component on it's primary axis by removing dimension.
/// Standard circular shape doesn't support stretching.
///
///     var body: some View {
///         VPageIndicator(
///             type: uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.layout.dotDimensionPrimaryAxis = nil
///                 uiModel.layout.dotDimensionSecondaryAxis = 5
///                 return uiModel
///             }(),
///             total: total,
///             selectedIndex: selectedIndex,
///             dot: { RoundedRectangle(cornerRadius: 2.5) }
///         )
///             .padding()
///
public struct VPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorUIModel
    
    private let total: Int
    private let selectedIndex: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>

    // MARK: Initializers
    /// Initializes `VPageIndicator` with total and selected index.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .empty
    }
    
    /// Initializes `VPageIndicator` with total, selected index, and custom dot content.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .content(content: dot)
    }
    
    init(
        uiModel: VPageIndicatorUIModel,
        total: Int,
        selectedIndex: Int,
        dotContent: VPageIndicatorDotContent<Content>
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = dotContent
    }

    // MARK: Body
    public var body: some View {
        let range: [Int] = (0..<total)
            .reversedArray(if: uiModel.layout.direction.isReversed)
        
        return HVStack(
            spacing: uiModel.layout.spacing,
            isHorizontal: uiModel.layout.direction.isHorizontal,
            content: {
                ForEach(range, id: \.self, content: { i in
                    dotContentView
                        .frame(width: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotDimensionPrimaryAxis : uiModel.layout.dotDimensionSecondaryAxis)
                        .frame(height: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotDimensionSecondaryAxis : uiModel.layout.dotDimensionPrimaryAxis)
                        .scaleEffect(selectedIndex == i ? 1 : uiModel.layout.unselectedDotScale)
                        .foregroundColor(selectedIndex == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
                })
            }
        )
            .animation(uiModel.animations.transition, value: selectedIndex)
    }
    
    @ViewBuilder private var dotContentView: some View {
        switch dotContent {
        case .empty:
            Circle()
            
        case .content(let content):
            content()
        }
    }
}

// MARK: - Preview
struct VPageIndicator_Previews: PreviewProvider {
    private static var total: Int { 10 }
    private static var selectedIndex: Int { 0 }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        LayoutDirectionsPreview().previewDisplayName("Layout Directions")
        StretchingPreview().previewDisplayName("Stretching")
    }
    
    private struct Preview: View {
        @State private var selectedIndex: Int = VPageIndicator_Previews.selectedIndex
        
        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    total: total,
                    selectedIndex: selectedIndex
                )
                    .onReceiveOfTimerIncrement($selectedIndex, to: total-1)
            })
        }
    }
    
    private struct LayoutDirectionsPreview: View {
        @State private var selectedIndex: Int = VPageIndicator_Previews.selectedIndex
        
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Left-to-Right",
                    content: {
                        VPageIndicator(
                            uiModel: {
                                var uiModel: VPageIndicatorUIModel = .init()
                                uiModel.layout.direction = .leftToRight
                                return uiModel
                            }(),
                            total: total,
                            selectedIndex: selectedIndex
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
                                uiModel.layout.direction = .rightToLeft
                                return uiModel
                            }(),
                            total: total,
                            selectedIndex: selectedIndex
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Top-to-Bottom",
                    content: {
                        VPageIndicator(
                            uiModel: {
                                var uiModel: VPageIndicatorUIModel = .init()
                                uiModel.layout.direction = .topToBottom
                                return uiModel
                            }(),
                            total: total,
                            selectedIndex: selectedIndex
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
                                uiModel.layout.direction = .bottomToTop
                                return uiModel
                            }(),
                            total: total,
                            selectedIndex: selectedIndex
                        )
                    }
                )
            })
                .onReceiveOfTimerIncrement($selectedIndex, to: total-1)
        }
    }
    
    private struct StretchingPreview: View {
        @State private var selectedIndex: Int = VPageIndicator_Previews.selectedIndex
        
        var body: some View {
            PreviewContainer(content: {
                VPageIndicator(
                    uiModel: {
                        var uiModel: VPageIndicatorUIModel = .init()
                        uiModel.layout.direction = .leftToRight
                        uiModel.layout.dotDimensionPrimaryAxis = nil
                        uiModel.layout.dotDimensionSecondaryAxis = 5
                        return uiModel
                    }(),
                    total: total,
                    selectedIndex: selectedIndex,
                    dot: { RoundedRectangle(cornerRadius: 2.5) }
                )
                    .padding()
            })
                .onReceiveOfTimerIncrement($selectedIndex, to: total-1)
        }
    }
}
