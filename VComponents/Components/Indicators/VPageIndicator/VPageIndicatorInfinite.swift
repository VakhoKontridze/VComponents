//
//  VPageIndicaatorInfinite.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator Infinite
struct VPageIndicatorInfinite: View {
    // MARK: Properties
    private let model: VPageIndicatorModel
    private let visible: Int
    private let center: Int
    private var side: Int { (visible - center) / 2 }
    private var middle: Int { visible / 2 }
    
    private let total: Int
    private let selectedIndex: Int
    
    private var region: Region {
        .init(selectedIndex: selectedIndex, total: total, middle: middle)
    }
    
    private let isLayoutValid: Bool

    // MARK: Intializers
    init(
        model: VPageIndicatorModel,
        visible: Int,
        center: Int,
        total: Int,
        selectedIndex: Int
    ) {
        self.model = model
        self.visible = visible
        self.center = center
        self.total = total
        self.selectedIndex = selectedIndex
        
        self.isLayoutValid = visible > center && visible.isOdd && center.isOdd
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch (isLayoutValid, total) {
        case (false, _): EmptyView()
        case (true, ...visible): VPageIndicatorFinite(model: model, total: total, selectedIndex: selectedIndex)
        case (true, _): validBody
        }
    }
    
    private var validBody: some View {
        frame
            .overlay(dots)
            .clipped()
    }
    
    private var frame: some View {
        ColorBook.clear
            .frame(size: .init(width: visibleWidth, height: model.layout.dotDimension))
    }
    
    private var dots: some View {
        HStack(spacing: model.layout.spacing, content: {
            ForEach(0..<total, content: { i in
                Circle()
                    .foregroundColor(selectedIndex == i ? model.colors.selectedDot : model.colors.dot)
                    .frame(dimension: model.layout.dotDimension)
                    .scaleEffect(scale(at: i), anchor: .center)
            })
        })
            .offset(x: offset)
    }

    // MARK: Widths
    private var visibleWidth: CGFloat {
        let dots: CGFloat = .init(visible) * model.layout.dotDimension
        let spacings: CGFloat = .init(visible - 1) * model.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }
    
    private var totalWidth: CGFloat {
        let dots: CGFloat = .init(total) * model.layout.dotDimension
        let spacings: CGFloat = .init(total - 1) * model.layout.spacing
        let total: CGFloat = dots + spacings
        return total
    }

    // MARK: Animation Offset
    private var offset: CGFloat {
        let rawOffset: CGFloat = (totalWidth - visibleWidth) / 2
        
        switch region {
        case .leftEdge:
            return rawOffset
        
        case .center:
            let incrementalOffset: CGFloat = -.init(selectedIndex - middle) * (model.layout.dotDimension + model.layout.spacing)
            return rawOffset + incrementalOffset
        
        case .rightEdge:
            return -rawOffset
        }
    }

    // MARK: Animation Scale
    private func scale(at index: Int) -> CGFloat {
        switch region {
        case .leftEdge:
            guard
                let leftEdgeVisibleIndex: Int = leftEdgeVisibleIndex(at: index),
                let leftEdgeRightSideIndex: Int = leftEdgeRightSideIndex(at: leftEdgeVisibleIndex)
            else {
                return 1
            }

            return leftEdgeRightSideScale(at: leftEdgeRightSideIndex)

        case .center:
            guard
                let visibleIndex: Int = centerVisibleIndex(at: index),
                let centerIndexAbsolute: Int = centerIndexAbsolute(at: visibleIndex)
            else {
                return 1
            }

            return centerScale(at: centerIndexAbsolute)

        case .rightEdge:
            guard
                let rightEdgeVisibleIndex: Int = rightEdgeVisibleIndex(at: index),
                let rightEdgeleftSideIndex: Int = rightEdgeleftSideIndex(at: rightEdgeVisibleIndex)
            else {
                return 1
            }

            return rightEdgeLeftSideScale(at: rightEdgeleftSideIndex)
        }
    }
    
    // LEFT
    private func leftEdgeVisibleIndex(at index: Int) -> Int? {
        switch index {
        case 0..<visible: return index
        default: return nil
        }
    }
    
    private func leftEdgeRightSideIndex(at index: Int) -> Int? {
        // (5 6) -> (0 1)
        switch index {
        case visible-side..<visible: return side + index - visible
        default: return nil
        }
    }
    
    private func leftEdgeRightSideScale(at index: Int) -> CGFloat {
        let scaleStep: CGFloat = model.layout.infiniteEdgeDotScale / .init(side)
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
        rightEdgeLeftSideScale(at: index)
    }
    
    // RIGHT
    private func rightEdgeVisibleIndex(at index: Int) -> Int? {
        switch index {
        case total-visible..<total: return visible - total + index
        default: return nil
        }
    }
    
    private func rightEdgeleftSideIndex(at index: Int) -> Int? {
        // (0 1) -> (0 1)
        switch index {
        case 0..<side: return index
        default: return nil
        }
    }
    
    private func rightEdgeLeftSideScale(at index: Int) -> CGFloat {
        let scaleStep: CGFloat = model.layout.infiniteEdgeDotScale / .init(side)
        let incrementalScale: CGFloat = model.layout.infiniteEdgeDotScale + .init(index) * scaleStep
        return incrementalScale
    }

    // MARK: Region
    private enum Region {
        // MARK: Cases
        case leftEdge
        case center
        case rightEdge
        
        // MARK: Initializers
        init(selectedIndex: Int, total: Int, middle: Int) {
            switch selectedIndex {
            case 0..<middle+1: self = .leftEdge
            case total-middle-1..<total: self = .rightEdge
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
        VPageIndicatorInfinite(
            model: .init(),
            visible: 7,
            center: 3,
            total: 20,
            selectedIndex: 4
        )
    }
}
