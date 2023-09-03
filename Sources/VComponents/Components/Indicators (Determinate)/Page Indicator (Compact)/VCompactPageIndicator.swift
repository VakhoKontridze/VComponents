//
//  VCompactPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Compact Page Indicator
/// Indicator component that indicates selection in page control in compact fashion.
///
/// UI model can be passed as parameter.
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
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VCompactPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             current: current
///         )
///     }
///
/// You can fully customize dot by passing a `dot` parameter. For instance, we can get a "bullet" shape.
/// `.frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VCompactPageIndicator(
///             uiModel: {
///                 var uiModel: VCompactPageIndicatorUIModel = .init()
///                 uiModel.layout.dotWidth = 15
///                 uiModel.layout.dotHeight = 15
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
public struct VCompactPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VCompactPageIndicatorUIModel
    
    private let total: Int
    private var visible: Int { uiModel.layout.visibleDots }
    private var center: Int { uiModel.layout.centerDots }
    private var side: Int { uiModel.layout.sideDots }
    private var middle: Int { uiModel.layout.middleDots }
    private let current: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>
    
    private var region: Region {
        .init(current: current, total: total, middle: middle)
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
        @ViewBuilder dot: @escaping () -> Content
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .content(content: dot)
    }
    
    // MARK: Initializers - Internal
    init(
        uiModel: VCompactPageIndicatorUIModel,
        total: Int,
        current: Int,
        dotContent: VPageIndicatorDotContent<Content>
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = dotContent
    }
    
    // MARK: Body
    public var body: some View {
        switch total {
        case ...visible:
            VPageIndicator(
                uiModel: uiModel.standardPageIndicatorSubUIModel,
                total: total,
                current: current,
                dotContent: dotContent
            )
            
        case _:
            compactBody
        }
    }
    
    // There's something weird going on with animations here.
    // Ideally, I would combine `dotsHorizontal` and `dotsVertical` into on property,
    // and get rid of `dots()`, since `ForEach` would be declared internally.
    // There, I would rely on `AnyLayout`, or at least, `HVStack` to conditionally change direction.
    // But unlike `VPageIndicator`, they don't work. Animation breaks and some dots disappear.
    // Even wrapping them with if-else with `ViewBuilder`, or `Group` doesn't help it.
    // The only solution I found is to write conditional outside body that defines `HStack`/`VStack`.
    private var compactBody: some View {
        frame
            .applyIf(
                uiModel.layout.direction.isHorizontal,
                ifTransform: { $0.overlay(dotsHorizontal) },
                elseTransform: { $0.overlay(dotsVertical) }
            )
            .clipped()
            .applyIf(uiModel.animations.appliesTransitionAnimation, transform: {
                $0.animation(uiModel.animations.transition, value: current)
            })
    }
    
    private var frame: some View {
        let size: CGSize = .init(
            width: visibleWidth,
            height: uiModel.layout.dotHeight
        )
            .withReversedDimensions(uiModel.layout.direction.isVertical)
        
        return Color.clear
            .frame(size: size)
    }
    
    private var dotsHorizontal: some View {
        HStack(
            spacing: uiModel.layout.spacing,
            content: dots
        )
        .offset(x: offset)
    }
    
    private var dotsVertical: some View {
        VStack(
            spacing: uiModel.layout.spacing,
            content: dots
        )
        .offset(y: offset)
    }
    
    private func dots() -> some View {
        let range: [Int] = (0..<total)
            .reversedArray(if: uiModel.layout.direction.isReversed)
        
        return ForEach(range, id: \.self, content: dotContentView)
    }
    
    private func dotContentView(i: Int) -> some View {
        Group(content: {
            switch dotContent {
            case .empty:
                ZStack(content: {
                    Capsule()
                        .foregroundColor(current == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
                    
                    Capsule()
                        .strokeBorder(lineWidth: uiModel.layout.dotBorderWidth)
                        .foregroundColor(current == i ? uiModel.colors.selectedDotBorder : uiModel.colors.dotBorder)
                })
                
            case .content(let content):
                content()
                    .foregroundColor(current == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
            }
        })
        .frame(
            width: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotWidth : uiModel.layout.dotHeight,
            height: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotHeight : uiModel.layout.dotWidth
        )
        .scaleEffect(scale(at: i))
    }
    
    // MARK: Dimension on Main Axis
    private var visibleWidth: CGFloat {
        let dots: CGFloat = CGFloat(visible) * uiModel.layout.dotWidth
        let spacings: CGFloat = CGFloat(visible - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }
    
    private var totalWidth: CGFloat {
        let dots: CGFloat = CGFloat(total) * uiModel.layout.dotWidth
        let spacings: CGFloat = CGFloat(total - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }
    
    // MARK: Animation Offset
    private var offset: CGFloat {
        let rawOffset: CGFloat = (totalWidth - visibleWidth) / 2
        
        let directionalOffset: CGFloat = {
            switch region {
            case .start:
                return rawOffset
                
            case .center:
                let incrementalOffset: CGFloat = -CGFloat(current - middle) * (uiModel.layout.dotWidth + uiModel.layout.spacing)
                return rawOffset + incrementalOffset
                
            case .end:
                return -rawOffset
            }
        }()
        
        return directionalOffset
            .withOppositeSign(if: uiModel.layout.direction.isReversed)
    }
    
    // MARK: Animation Scale
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
        let scaleStep: CGFloat = uiModel.layout.edgeDotScale / CGFloat(side)
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
        case 0..<side: return index
        case visible-side..<visible: return visible - index - 1
        default: return nil
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
        let scaleStep: CGFloat = uiModel.layout.edgeDotScale / CGFloat(side)
        let incrementalScale: CGFloat = uiModel.layout.edgeDotScale + CGFloat(index) * scaleStep
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
        guard uiModel.layout.visibleDots.isOdd else {
            VCoreFatalError("`VCompactPageIndicator`'s `visible` count must be odd", module: "VComponents")
        }
        
        guard uiModel.layout.centerDots.isOdd else {
            VCoreFatalError("`VCompactPageIndicator`'s `center` count must be odd", module: "VComponents")
        }
        
        guard uiModel.layout.visibleDots > uiModel.layout.centerDots else {
            VCoreFatalError("`VCompactPageIndicator`'s `visible` must be greater than `center`", module: "VComponents")
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
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
                                uiModel.layout.direction = .leftToRight
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
                                uiModel.layout.direction = .rightToLeft
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
                                    uiModel.layout.direction = .topToBottom
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
                                    uiModel.layout.direction = .bottomToTop
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
}
