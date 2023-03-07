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
///     @State private var selectedIndex: Int = 4
///
///     var body: some View {
///         VCompactPageIndicator(
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VCompactPageIndicator(
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
///         VCompactPageIndicator(
///             type: uiModel: {
///                 var uiModel: VCompactPageIndicatorUIModel = .init()
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
public struct VCompactPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VCompactPageIndicatorUIModel
    
    private let total: Int
    private var visible: Int { uiModel.layout.visibleDots }
    private var center: Int { uiModel.layout.centerDots }
    private var side: Int { uiModel.layout.sideDots }
    private var middle: Int { uiModel.layout.middleDots }
    private let selectedIndex: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>
    
    private var region: Region {
        .init(selectedIndex: selectedIndex, total: total, middle: middle)
    }

    // MARK: Initializers
    /// Initializes component with total and selected index.
    public init(
        uiModel: VCompactPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int
    )
        where Content == Never
    {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .default
    }
    
    /// Initializes component with total, selected index, and custom dot content.
    public init(
        uiModel: VCompactPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .custom(content: dot)
    }
    
    init(
        uiModel: VCompactPageIndicatorUIModel,
        total: Int,
        selectedIndex: Int,
        dotContent: VPageIndicatorDotContent<Content>
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = dotContent
    }

    // MARK: Body
    public var body: some View {
        switch total {
        case ...visible:
            VPageIndicator(
                uiModel: uiModel.standardPageIndicatorSubUIModel,
                total: total,
                selectedIndex: selectedIndex,
                dotContent: dotContent
            )
        
        case _:
            compactBody
        }
    }
    
    private var compactBody: some View {
        frame
            .overlay(content: { dots })
            .clipped()
    }
    
    private var frame: some View {
        let size: CGSize = .init(
            width: visibleDimensionPrimaryAxis,
            height: uiModel.layout.dotDimensionSecondaryAxis
        )
            .withReversedDimensions(if: uiModel.layout.direction.isVertical)
        
        return Color.clear
            .frame(size: size)
    }
    
    private var dots: some View {
        let layout: AnyLayout = uiModel.layout.direction.stackLayout(spacing: uiModel.layout.spacing)
        
        let range: [Int] = (0..<total)
            .reversedArray(if: uiModel.layout.direction.isReversed)
        
        let offset2D: CGSize = .init(
            width: offset,
            height: 0
        )
            .withReversedDimensions(if: uiModel.layout.direction.isVertical)
        
        return layout.callAsFunction({
            ForEach(range, id: \.self, content: { i in
                dotContentView
                    .frame(width: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotDimensionPrimaryAxis : uiModel.layout.dotDimensionSecondaryAxis)
                    .frame(height: uiModel.layout.direction.isHorizontal ? uiModel.layout.dotDimensionSecondaryAxis : uiModel.layout.dotDimensionPrimaryAxis)
                    .scaleEffect(scale(at: i), anchor: .center)
                    .foregroundColor(selectedIndex == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
            })
        })
            .offset(offset2D)
            .animation(uiModel.animations.transition, value: selectedIndex)
    }
    
    @ViewBuilder private var dotContentView: some View {
        switch dotContent {
        case .default:
            Circle()
        
        case .custom(let content):
            content()
        }
    }

    // MARK: Dimension on Main Axis
    private var visibleDimensionPrimaryAxis: CGFloat {
        let dots: CGFloat = .init(visible) * uiModel.layout.dotDimensionPrimaryAxis
        let spacings: CGFloat = .init(visible - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }
    
    private var totalDimensionPrimaryAxis: CGFloat {
        let dots: CGFloat = .init(total) * uiModel.layout.dotDimensionPrimaryAxis
        let spacings: CGFloat = .init(total - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }

    // MARK: Animation Offset
    private var offset: CGFloat {
        let rawOffset: CGFloat = (totalDimensionPrimaryAxis - visibleDimensionPrimaryAxis) / 2
        
        let directionalOffset: CGFloat = {
            switch region {
            case .start:
                return rawOffset
            
            case .center:
                let incrementalOffset: CGFloat = -.init(selectedIndex - middle) * (uiModel.layout.dotDimensionPrimaryAxis + uiModel.layout.spacing)
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
        let scaleStep: CGFloat = uiModel.layout.edgeDotScale / .init(side)
        let incrementalScale: CGFloat = .init(index + 1) * scaleStep
        return 1 - incrementalScale
    }
    
    // CENTER
    private func centerVisibleIndex(at index: Int) -> Int? {
        let offset: Int = selectedIndex - (side+1)
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
        let scaleStep: CGFloat = uiModel.layout.edgeDotScale / .init(side)
        let incrementalScale: CGFloat = uiModel.layout.edgeDotScale + .init(index) * scaleStep
        return incrementalScale
    }

    // MARK: Region
    private enum Region {
        // MARK: Cases
        case start
        case center
        case end
        
        // MARK: Initializers
        init(selectedIndex: Int, total: Int, middle: Int) {
            switch selectedIndex {
            case 0..<middle+1: self = .start
            case total-middle-1..<total: self = .end
            default: self = .center
            }
        }
    }
    
    // MARK: Assertion
    private static func assertUIModel(_ uiModel: VCompactPageIndicatorUIModel) {
        assert(
            uiModel.layout.visibleDots.isOdd,
            "`VCompactPageIndicator`'s `visible` count must be odd"
        )
        
        assert(
            uiModel.layout.centerDots.isOdd,
            "`VCompactPageIndicator`'s `center` count must be odd"
        )
        
        assert(
            uiModel.layout.visibleDots > uiModel.layout.centerDots,
            "`VCompactPageIndicator`'s `visible` must be greater than `center`"
        )
    }
}

// MARK: - Helpers
extension Int {
    fileprivate var isEven: Bool { self % 2 == 0 }
    
    fileprivate var isOdd: Bool { !isEven }
}

// MARK: - Preview
struct VPageIndicatorCompact_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    private struct Preview: View {
        private let total: Int = 10
        @State private var selectedIndex: Int = 0
        
        var body: some View {
            VStack(spacing: 20, content: {
                ForEach(LayoutDirectionOmni.allCases, id: \.self, content: { direction in
                    VCompactPageIndicator<Never>(
                        uiModel: {
                            var uiModel: VCompactPageIndicatorUIModel = .init()
                            uiModel.layout.direction = direction
                            return uiModel
                        }(),
                        total: total,
                        selectedIndex: selectedIndex,
                        dotContent: .default
                    )
                })
            })
                .onReceive(
                    Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
                    perform: updateValue
                )
        }
        
        private func updateValue(_ output: Date) {
            var valueToSet: Int = selectedIndex + 1
            if valueToSet > total-1 { valueToSet = 0 }
            
            selectedIndex = valueToSet
        }
    }
}
