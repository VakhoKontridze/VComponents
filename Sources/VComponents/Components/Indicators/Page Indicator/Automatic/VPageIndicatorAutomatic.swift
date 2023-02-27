//
//  VPageIndicatorAutomatic.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator Automatic
struct VPageIndicatorAutomatic: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorAutomaticUIModel
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Initializers
    init(
        uiModel: VPageIndicatorAutomaticUIModel,
        total: Int,
        selectedIndex: Int
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    var body: some View {
        switch total {
        case ...uiModel.layout.standardDotLimit:
            VPageIndicatorStandard(
                uiModel: uiModel.standardSubModel,
                total: total,
                selectedIndex: selectedIndex
            )
            
        default:
            VPageIndicatorCompact(
                uiModel: uiModel.compactSubModel,
                total: total,
                selectedIndex: selectedIndex
            )
        }
    }
}

// MARK: - Preview
struct VPageIndicatorAutomatic_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20, content: {
            ForEach(OmniLayoutDirection.allCases, id: \.self, content: { direction in
                ForEach([9, 15], id: \.self, content: { total in
                    VPageIndicatorAutomatic(
                        uiModel: {
                            var uiModel: VPageIndicatorAutomaticUIModel = .init()
                            uiModel.layout.direction = direction
                            return uiModel
                        }(),
                        total: total,
                        selectedIndex: 4
                    )
                })
            })
        })
    }
}
