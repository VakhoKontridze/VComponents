//
//  VPageIndicatorFinite.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator Finite
struct VPageIndicatorFinite: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorUIModel
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Intializers
    init(
        uiModel: VPageIndicatorUIModel,
        total: Int,
        selectedIndex: Int
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    var body: some View {
        HStack(spacing: uiModel.layout.spacing, content: {
            ForEach(0..<total, id: \.self, content: { i in
                Circle()
                    .foregroundColor(selectedIndex == i ? uiModel.colors.selectedDot : uiModel.colors.dot)
                    .frame(dimension: uiModel.layout.dotDimension)
                    .scaleEffect(selectedIndex == i ? 1 : uiModel.layout.finiteDotScale)
            })
        })
    }
}

// MARK: - Preview
struct VPageIndicatorFinite_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorFinite(uiModel: .init(), total: 9, selectedIndex: 4)
    }
}
