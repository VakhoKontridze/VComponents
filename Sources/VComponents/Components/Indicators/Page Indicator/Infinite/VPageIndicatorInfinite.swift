//
//  VPageIndicatorInfinite.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator Infinite
struct VPageIndicatorInfinite: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorInfiniteUIModel
    
    private let total: Int
    private var visible: Int { uiModel.layout.visibleDots }
    private var center: Int { uiModel.layout.centerDots }
    private var side: Int { uiModel.layout.sideDots }
    private var middle: Int { uiModel.layout.middleDots }
    private let selectedIndex: Int
    
    private var region: Region {
        .init(selectedIndex: selectedIndex, total: total, middle: middle)
    }

    // MARK: Initializers
    init(
        uiModel: VPageIndicatorInfiniteUIModel,
        total: Int,
        selectedIndex: Int
    ) {
        assert(uiModel.layout.visibleDots.isOdd, "`VPageIndicator`'s `visible` count must be odd")
        assert(uiModel.layout.centerDots.isOdd, "`VPageIndicator`'s `center` count must be odd")
        assert(uiModel.layout.visibleDots > uiModel.layout.centerDots, "`VPageIndicator`'s `visible` must be greater than `center`")
        
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    public var body: some View {
        switch total {
        case ...visible:
            VPageIndicatorFinite(
                uiModel: uiModel.finiteSubModel,
                total: total,
                selectedIndex: selectedIndex
            )
        
        case _:
            infiniteBody
        }
    }
    
    private var infiniteBody: some View {
        frame
            .overlay(dots)
            .clipped()
    }
    
    private var frame: some View {
        let size: CGSize = {
            switch uiModel.layout.axis {
            case .horizontal: return .init(width: visibleDimensionMainAxis, height: uiModel.layout.dotDimension)
            case .vertical: return .init(width: uiModel.layout.dotDimension, height: visibleDimensionMainAxis)
            }
        }()
        
        return Color.clear
            .frame(size: size)
    }
    
    private var dots: some View {
        let layout: AnyLayout = {
            switch uiModel.layout.axis {
            case .horizontal: return .init(HStackLayout(spacing: uiModel.layout.spacing))
            case .vertical: return .init(VStackLayout(spacing: uiModel.layout.spacing))
            }
        }()
        
        let offset2D: CGSize = {
            switch uiModel.layout.axis {
            case .horizontal: return .init(width: offset, height: 0)
            case .vertical: return .init(width: 0, height: offset)
            }
        }()
        
        return layout.callAsFunction({
            ForEach(0..<total, id: \.self, content: { i in
                Circle()
                    .foregroundColor(selectedIndex == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
                    .frame(dimension: uiModel.layout.dotDimension)
                    .scaleEffect(scale(at: i), anchor: .center)
            })
        })
            .offset(offset2D)
            .animation(uiModel.animations.transition, value: selectedIndex)
    }

    // MARK: Dimension on Main Axis
    private var visibleDimensionMainAxis: CGFloat {
        let dots: CGFloat = .init(visible) * uiModel.layout.dotDimension
        let spacings: CGFloat = .init(visible - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }
    
    private var totalDimensionMainAxis: CGFloat {
        let dots: CGFloat = .init(total) * uiModel.layout.dotDimension
        let spacings: CGFloat = .init(total - 1) * uiModel.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }

    // MARK: Animation Offset
    private var offset: CGFloat {
        let rawOffset: CGFloat = (totalDimensionMainAxis - visibleDimensionMainAxis) / 2
        
        switch region {
        case .start:
            return rawOffset
        
        case .center:
            let incrementalOffset: CGFloat = -.init(selectedIndex - middle) * (uiModel.layout.dotDimension + uiModel.layout.spacing)
            return rawOffset + incrementalOffset
        
        case .end:
            return -rawOffset
        }
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
        switch index {
        case 0..<visible: return index
        default: return nil
        }
    }
    
    private func startEdgeEndSideIndex(at index: Int) -> Int? {
        // (5 6) -> (0 1)
        switch index {
        case visible-side..<visible: return side + index - visible
        default: return nil
        }
    }
    
    private func startEdgeEndSideScale(at index: Int) -> CGFloat {
        let scaleStep: CGFloat = uiModel.layout.edgeDotScale / .init(side)
        let incrementalScale: CGFloat = .init(index + 1) * scaleStep
        return 1 - incrementalScale
    }
    
    // CENTER
    private func centerVisibleIndex(at index: Int) -> Int? {
        let offset: Int = selectedIndex - (side+1)
        
        switch index {
        case offset..<visible+offset: return index - offset
        default: return nil
        }
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
        switch index {
        case total-visible..<total: return visible - total + index
        default: return nil
        }
    }
    
    private func endEdgeStartSideIndex(at index: Int) -> Int? {
        // (0 1) -> (0 1)
        switch index {
        case 0..<side: return index
        default: return nil
        }
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
}

// MARK: - Helpers
extension Int {
    fileprivate var isEven: Bool { self % 2 == 0 }
    
    fileprivate var isOdd: Bool { !isEven }
}

// MARK: - Preview
struct VPageIndicatorInfinite_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20, content: {
            ForEach(Axis.allCases, id: \.rawValue, content: { axis in
                VPageIndicatorInfinite(
                    uiModel: {
                        var uiModel: VPageIndicatorInfiniteUIModel = .init()
                        uiModel.layout.axis = axis
                        return uiModel
                    }(),
                    total: 9,
                    selectedIndex: 4
                )
            })
        })
    }
}
