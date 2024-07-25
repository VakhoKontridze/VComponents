//
//  VCompactPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import OSLog
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
///             dotContent: { (internalState, _) in
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
public struct VCompactPageIndicator<CustomDotContent>: View where CustomDotContent: View {
    // MARK: Properties - UI Model
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

    // MARK: Properties - Dot Content
    private let dotContent: VCompactPageIndicatorDotContent<CustomDotContent>

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
        where CustomDotContent == Never
    {
        Self.validate(uiModel: uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .standard
    }
    
    /// Initializes `VCompactPageIndicator` with total, current index, and custom dot content.
    public init(
        uiModel: VCompactPageIndicatorUIModel = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dotContent customDotContent: @escaping (VCompactPageIndicatorDotInternalState, Int) -> CustomDotContent
    ) {
        Self.validate(uiModel: uiModel)

        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .custom(custom: customDotContent)
    }
    
    // MARK: Body
    public var body: some View {
        // `VPageIndicator` is needed, because if total number of dots are not more that visible,
        // `0`-sizes dots would offset the page indicator.
        Group(content: {
            if total > visible {
                compactBody
                
            } else {
                VPageIndicator<CustomDotContent>(
                    uiModel: uiModel.standardPageIndicatorSubUIModel,
                    total: total,
                    current: current,
                    dotContent: {
                        switch dotContent {
                        case .standard: VPageIndicatorDotContent.standard
                        case .custom(let custom): VPageIndicatorDotContent.custom(custom: custom)
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

        return uiModel.direction
            .stackLayout(spacing: uiModel.spacing)
            .callAsFunction({ ForEach(range, id: \.self, content: dotContentView) })
            .frame(size: size)
            .offset(
                x: uiModel.direction.isHorizontal ? offset : 0,
                y: uiModel.direction.isHorizontal ? 0 : offset
            )
            .clipped() // Clips off-bound dots
            .applyIf(uiModel.appliesTransitionAnimation, transform: {
                $0.animation(uiModel.transitionAnimation, value: current)
            })
    }

    private func dotContentView(
        index: Int
    ) -> some View {
        let internalState: VCompactPageIndicatorDotInternalState = dotInternalState(index)

        return Group(content: {
            switch dotContent {
            case .standard:
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                        .foregroundStyle(uiModel.dotColors.value(for: internalState))

                    let borderWidth: CGFloat = uiModel.dotBorderWidths.value(for: internalState)
                    if borderWidth > 0 {
                        RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                            .strokeBorder(uiModel.dotBorderColors.value(for: internalState), lineWidth: borderWidth)
                    }
                })

            case .custom(let custom):
                custom(internalState, index)
            }
        })
        .frame(
            width: uiModel.direction.isHorizontal ? uiModel.dotWidth : uiModel.dotHeight,
            height: uiModel.direction.isHorizontal ? uiModel.dotHeight : uiModel.dotWidth
        )
        .scaleEffect(scale(at: index))
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
        let scaleStep: CGFloat = uiModel.edgeDotScale / CGFloat(side) // Division is safe
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
    
    // MARK: Validation
    private static func validate(
        uiModel: VCompactPageIndicatorUIModel
    ) {
        guard uiModel.visibleDots.isOdd else {
            Logger.compactPageIndicator.critical("'visible' count must be odd in 'VCompactPageIndicator'")
            fatalError()
        }
        
        guard uiModel.centerDots.isOdd else {
            Logger.compactPageIndicator.critical("'center' count must be odd in 'VCompactPageIndicator'")
            fatalError()
        }
        
        guard uiModel.visibleDots > uiModel.centerDots else {
            Logger.compactPageIndicator.critical("'visible' must be greater than 'center' in 'VCompactPageIndicator'")
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
#if DEBUG

#Preview("*", body: {
    struct ContentView: View {
        private let total: Int = 10
        @State private var current: Int = 0

        var body: some View {
            PreviewContainer(content: {
                VCompactPageIndicator(
                    total: total,
                    current: current
                )
            })
            .onReceiveOfTimerIncrement($current, to: total-1)
        }
    }

    return ContentView()
})

#Preview("Layout Directions", body: {
    struct ContentView: View {
        private let total: Int = 10
        @State private var current: Int = 0

        var body: some View {
            PreviewContainer(content: {
                PreviewRow("Left-to-Right", content: {
                    VCompactPageIndicator(
                        uiModel: {
                            var uiModel: VCompactPageIndicatorUIModel = .init()
                            uiModel.direction = .leftToRight
                            return uiModel
                        }(),
                        total: total,
                        current: current
                    )
                })

                PreviewRow("Right-to-Left", content: {
                    VCompactPageIndicator(
                        uiModel: {
                            var uiModel: VCompactPageIndicatorUIModel = .init()
                            uiModel.direction = .rightToLeft
                            return uiModel
                        }(),
                        total: total,
                        current: current
                    )
                })

                HStack(spacing: 20, content: {
                    PreviewRow("Top-to-Bottom", content: {
                        VCompactPageIndicator(
                            uiModel: {
                                var uiModel: VCompactPageIndicatorUIModel = .init()
                                uiModel.direction = .topToBottom
                                return uiModel
                            }(),
                            total: total,
                            current: current
                        )
                    })

                    PreviewRow("Bottom-to-Top", content: {
                        VCompactPageIndicator(
                            uiModel: {
                                var uiModel: VCompactPageIndicatorUIModel = .init()
                                uiModel.direction = .bottomToTop
                                return uiModel
                            }(),
                            total: total,
                            current: current
                        )
                    })
                })
            })
            .onReceiveOfTimerIncrement($current, to: total-1)
        }
    }

    return ContentView()
})

#Preview("Zero", body: {
    struct ContentView: View {
        var body: some View {
            PreviewContainer(content: {
                VCompactPageIndicator(
                    total: 0,
                    current: 0
                )
            })
        }
    }

    return ContentView()
})

#endif
