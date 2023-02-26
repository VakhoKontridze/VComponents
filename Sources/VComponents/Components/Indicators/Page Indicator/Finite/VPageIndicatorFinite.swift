//
//  VPageIndicatorFinite.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator Finite
struct VPageIndicatorFinite: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorFiniteUIModel
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Initializers
    init(
        uiModel: VPageIndicatorFiniteUIModel,
        total: Int,
        selectedIndex: Int
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    var body: some View {
        let layout: AnyLayout = uiModel.layout.direction.stackLayout(spacing: uiModel.layout.spacing)
        
        let range: [Int] = (0..<total)
            .reversedArray(if: uiModel.layout.direction.isReversed)
        
        return layout.callAsFunction({
            ForEach(range, id: \.self, content: { i in
                Circle()
                    .foregroundColor(selectedIndex == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
                    .frame(dimension: uiModel.layout.dotDimension)
                    .scaleEffect(selectedIndex == i ? 1 : uiModel.layout.unselectedDotScale)
            })
        })
            .animation(uiModel.animations.transition, value: selectedIndex)
    }
}

// MARK: - Preview
struct VPageIndicatorFinite_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20, content: {
            ForEach(OmniLayoutDirection.allCases, id: \.self, content: { direction in
                VPageIndicatorFinite(
                    uiModel: {
                        var uiModel: VPageIndicatorFiniteUIModel = .init()
                        uiModel.layout.direction = direction
                        return uiModel
                    }(),
                    total: 9,
                    selectedIndex: 4
                )
            })
        })
    }
}
