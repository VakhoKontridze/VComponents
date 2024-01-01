//
//  VCompactPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Compact Page Indicator
/// Indicator component that represents selection in page control in compact fashion.
///
///     private let total: Int = 10
///     @State private var current: Int = 4
///
///     var body: some View {
///         VCompactPageIndicator(
///             total: total,
///             current: current
///         )
///     }
///
/// Direction can be changed via `direction` in UI models, or passing `vertical` instance.
///
///     var body: some View {
///         VCompactPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             current: current
///         )
///     }
///
/// Dots can be fully customized. For instance, we can get a "bullet" shape.
/// `frame()` modifier shouldn't be applied to the dot itself.
///
///     private let pageIndicatorUIModel: VCompactPageIndicatorUIModel = {
///         var uiModel: VCompactPageIndicatorUIModel = .init()
///         uiModel.dotWidth *= 2
///         uiModel.dotHeight *= 2
///         return uiModel
///     }()
///
///     var body: some View {
///         VCompactPageIndicator(
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
///         .padding()
///     }
///
public struct VCompactPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VCompactPageIndicatorUIModel

    // MARK: Properties - State
    private func dotInternalState(
        _ index: Int
    ) -> VCompactPageIndicatorDotInternalState {
        .init(
            isSelected: index == current
        )
    }

    // MARK: Properties - Data
    private let total: Int
    private var visible: Int { uiModel.visibleDots }
    private var center: Int { uiModel.centerDots }
    private var side: Int { uiModel.sideDots }
    private var middle: Int { uiModel.middleDots }
    private let current: Int

    // MARK: Properties - Content
    private let dotContent: VCompactPageIndicatorDotContent<Content>

    // MARK: Frame
    private var region: Region {
        .init(
            current: current,
            total: total,
            middle: middle
        )
    }
    
    // MARK: Initializers
    /// Initializes `VCompactPageIndicator` with total and current index.
    public init(
        uiModel: VCompactPageIndicatorUIModel = .init(),
        total: Int,
        current: Int
    )
        where Content == Never
    {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .empty
    }
    
    /// Initializes `VCompactPageIndicator` with total, current index, and custom dot content.
    public init(
        uiModel: VCompactPageIndicatorUIModel = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dot: @escaping (VCompactPageIndicatorDotInternalState, Int) -> Content
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .content(content: dot)
    }
    
    // MARK: Body
    public var body: some View {
        // `VPageIndicator` is needed, because if total number of dots are not more that visible,
        // `0`-sizes dots would offset the page indicator.
        Group(content: {
            if total > visible {
                compactBody
                
            } else {
                VPageIndicator<Content>(
                    uiModel: uiModel.standardPageIndicatorSubUIModel,
                    total: total,
                    current: current,
                    dotContent: {
                        switch dotContent {
                        case .empty: VPageIndicatorDotContent.empty
                        case .content(let content): VPageIndicatorDotContent.content(content: content)
                        }
                    }()
                )
            }
        })
    }

    private var compactBody: some View {
        let size: CGSize = .init(
            width: visibleWidth,
            height: uiModel.dotHeight
        )
            .withReversedDimensions(uiModel.direction.isVertical)

        let range: [Int] = (0..<total)
            .reversedArray(uiModel.direction.isReversed)

        return Group(content: {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                uiModel.direction
                    .stackLayout(spacing: uiModel.spacing)
                    .callAsFunction({ ForEach(range, id: \.self, content: dotContentView) })
                    .frame(size: size)
                    .offset(
                        x: uiModel.direction.isHorizontal ? offset : 0,
                        y: uiModel.direction.isHorizontal ? 0 : offset
                    )
                    .clipped()
                    .applyIf(uiModel.appliesTransitionAnimation, transform: {
                        $0.animation(uiModel.transitionAnimation, value: current)
                    })

            } else {
                compactBodyFallback
            }
        })
    }

    private func dotContentView(index: Int) -> some View {
        let internalState: VCompactPageIndicatorDotInternalState = dotInternalState(index)

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
                content(internalState, index)
            }
        })
        .frame(
            width: uiModel.direction.isHorizontal ? uiModel.dotWidth : uiModel.dotHeight,
            height: uiModel.direction.isHorizontal ? uiModel.dotHeight : uiModel.dotWidth
        )
        .scaleEffect(scale(at: index))
    }

    private var compactBodyFallback: some View {
        frameFallback
            .applyIf(
                uiModel.direction.isHorizontal,
                ifTransform: { $0.overlay(content: { dotsHorizontalFallback }) },
                elseTransform: { $0.overlay(content: { dotsVerticalFallback }) }
            )
            .clipped()
            .applyIf(uiModel.appliesTransitionAnimation, transform: {
                $0.animation(uiModel.transitionAnimation, value: current)
            })
    }

    private var frameFallback: some View {
        let size: CGSize = .init(
            width: visibleWidth,
            height: uiModel.dotHeight
        )
            .withReversedDimensions(uiModel.direction.isVertical)

        return Color.clear
            .frame(size: size)
    }

    private var dotsHorizontalFallback: some View {
        HStack(
            spacing: uiModel.spacing,
            content: dotsFallback
        )
        .offset(x: offset)
    }

    private var dotsVerticalFallback: some View {
        VStack(
            spacing: uiModel.spacing,
            content: dotsFallback
        )
        .offset(y: offset)
    }

    private func dotsFallback() -> some View {
        let range: [Int] = (0..<total)
            .reversedArray(uiModel.direction.isReversed)

        return ForEach(range, id: \.self, content: dotContentView)
    }
    
    // MARK: Widths
    private var visibleWidth: CGFloat {
        let dots: CGFloat = CGFloat(visible) * uiModel.dotWidth
        let spacings: CGFloat = CGFloat(visible - 1) * uiModel.spacing
        return dots + spacings
    }
    
    private var totalWidth: CGFloat {
        let dots: CGFloat = CGFloat(total) * uiModel.dotWidth
        let spacings: CGFloat = CGFloat(total - 1) * uiModel.spacing
        return dots + spacings
    }
    
    // MARK: Offset
    private var offset: CGFloat {
        let rawOffset: CGFloat = (totalWidth - visibleWidth) / 2
        
        let directionalOffset: CGFloat = {
            switch region {
            case .start:
                return rawOffset
                
            case .center:
                let incrementalOffset: CGFloat = -CGFloat(current - middle) * (uiModel.dotWidth + uiModel.spacing)
                return rawOffset + incrementalOffset
                
            case .end:
                return -rawOffset
            }
        }()
        
        return directionalOffset
            .withOppositeSign(uiModel.direction.isReversed)
    }
    
    // MARK: Scale
    private func scale(at index: Int) -> CGFloat {
        switch region {
        case .start:
            guard
                let startEdgeVisibleIndex: Int = startEdgeVisibleIndex(at: index),
                let startEdgeEndSideIndex: Int = startEdgeEndSideIndex(at: startEdgeVisibleIndex)
            else {
                return 1
            }
            
            return startEdgeEndSideScale(at: startEdgeEndSideIndex)
            
        case .center:
            guard
                let visibleIndex: Int = centerVisibleIndex(at: index),
                let centerIndexAbsolute: Int = centerIndexAbsolute(at: visibleIndex)
            else {
                return 1
            }
            
            return centerScale(at: centerIndexAbsolute)
            
        case .end:
            guard
                let endEdgeVisibleIndex: Int = endEdgeVisibleIndex(at: index),
                let endEdgeStartSideIndex: Int = endEdgeStartSideIndex(at: endEdgeVisibleIndex)
            else {
                return 1
            }
            
            return endEdgeStartSideScale(at: endEdgeStartSideIndex)
        }
    }
    
    // START
    private func startEdgeVisibleIndex(at index: Int) -> Int? {
        guard (0..<visible).contains(index) else { return nil }
        return index
    }
    
    private func startEdgeEndSideIndex(at index: Int) -> Int? {
        guard (visible-side..<visible).contains(index) else { return nil }
        return side + index - visible // (5 6) -> (0 1)
    }
    
    private func startEdgeEndSideScale(at index: Int) -> CGFloat {
        let scaleStep: CGFloat = uiModel.edgeDotScale / CGFloat(side)
        let incrementalScale: CGFloat = CGFloat(index + 1) * scaleStep
        return 1 - incrementalScale
    }
    
    // CENTER
    private func centerVisibleIndex(at index: Int) -> Int? {
        let offset: Int = current - (side+1)
        guard (offset..<visible+offset).contains(index) else { return nil }
        return index - offset
    }
    
    private func centerIndexAbsolute(at index: Int) -> Int? {
        // (0 1 2 3 4 5 6) -> (0 1 _ _ _ 1 0)
        switch index {
        case 0..<side: index
        case visible-side..<visible: visible - index - 1
        default: nil
        }
    }
    
    private func centerScale(at index: Int) -> CGFloat {
        endEdgeStartSideScale(at: index)
    }
    
    // END
    private func endEdgeVisibleIndex(at index: Int) -> Int? {
        guard (total-visible..<total).contains(index) else { return nil }
        return visible - total + index
    }
    
    private func endEdgeStartSideIndex(at index: Int) -> Int? {
        guard (0..<side).contains(index) else { return nil }
        return index // (0 1) -> (0 1)
    }
    
    private func endEdgeStartSideScale(at index: Int) -> CGFloat {
        let scaleStep: CGFloat = uiModel.edgeDotScale / CGFloat(side)
        let incrementalScale: CGFloat = uiModel.edgeDotScale + CGFloat(index) * scaleStep
        return incrementalScale
    }
    
    // MARK: Region
    private enum Region {
        // MARK: Cases
        case start
        case center
        case end
        
        // MARK: Initializers
        init(current: Int, total: Int, middle: Int) {
            switch current {
            case 0..<middle+1: self = .start
            case total-middle-1..<total: self = .end
            default: self = .center
            }
        }
    }
    
    // MARK: Assertion
    private static func assertUIModel(_ uiModel: VCompactPageIndicatorUIModel) {
        guard uiModel.visibleDots.isOdd else {
            VCoreLogError("'VCompactPageIndicator''s 'visible' count must be odd")
            fatalError()
        }
        
        guard uiModel.centerDots.isOdd else {
            VCoreLogError("'VCompactPageIndicator''s 'center' count must be odd")
            fatalError()
        }
        
        guard uiModel.visibleDots > uiModel.centerDots else {
            VCoreLogError("'VCompactPageIndicator''s 'visible' must be greater than 'center'")
            fatalError()
        }
    }
}

// MARK: - Helpers
extension Int {
    fileprivate var isEven: Bool { self % 2 == 0 }
    fileprivate var isOdd: Bool { !isEven }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct VCompactPageIndicator_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            LayoutDirectionsPreview().previewDisplayName("Layout Directions")
            CustomContentPreview().previewDisplayName("Custom Content")
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
        @State private var current: Int = VCompactPageIndicator_Previews.current
        
        var body: some View {
            PreviewContainer(content: {
                VCompactPageIndicator(
                    total: total,
                    current: current
                )
                .onReceiveOfTimerIncrement($current, to: total-1)
            })
        }
    }
    
    private struct LayoutDirectionsPreview: View {
        @State private var current: Int = VCompactPageIndicator_Previews.current
        
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Left-to-Right",
                    content: {
                        VCompactPageIndicator(
                            uiModel: {
                                var uiModel: VCompactPageIndicatorUIModel = .init()
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
                        VCompactPageIndicator(
                            uiModel: {
                                var uiModel: VCompactPageIndicatorUIModel = .init()
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
                            VCompactPageIndicator(
                                uiModel: {
                                    var uiModel: VCompactPageIndicatorUIModel = .init()
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
                            VCompactPageIndicator(
                                uiModel: {
                                    var uiModel: VCompactPageIndicatorUIModel = .init()
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

    private struct CustomContentPreview: View {
        private let pageIndicatorUIModel: VCompactPageIndicatorUIModel = {
            var uiModel: VCompactPageIndicatorUIModel = .init()
            uiModel.dotWidth *= 2
            uiModel.dotHeight *= 2
            return uiModel
        }()

        @State private var current: Int = VCompactPageIndicator_Previews.current

        var body: some View {
            PreviewContainer(content: {
                VCompactPageIndicator(
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
}
