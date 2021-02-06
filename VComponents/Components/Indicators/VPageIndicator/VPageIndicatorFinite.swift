//
//  VPageIndicatorFinite.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK:- V Page Indicator Finite
struct VPageIndicatorFinite: View {
    private let model: VPageIndicatorModel
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Intializers
    init(
        model: VPageIndicatorModel,
        total: Int,
        selectedIndex: Int
    ) {
        self.model = model
        self.total = total
        self.selectedIndex = selectedIndex
    }
}

// MARK:- Properties
extension VPageIndicatorFinite {
    var body: some View {
        HStack(spacing: model.layout.spacing, content: {
            ForEach(0..<total, content: { i in
                Circle()
                    .foregroundColor(selectedIndex == i ? model.colors.selectedDot : model.colors.dot)
                    .frame(dimension: model.layout.dotDimension)
                    .scaleEffect(selectedIndex == i ? 1 : model.layout.finiteDotScale)
            })
        })
    }
}

// MARK:- Preview
struct VPageIndicatorFinite_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorFinite(model: .init(), total: 9, selectedIndex: 4)
    }
}
