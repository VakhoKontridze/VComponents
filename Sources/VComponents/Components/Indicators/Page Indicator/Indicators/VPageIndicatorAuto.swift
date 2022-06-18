//
//  VPageIndicatorAuto.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator Auto
struct VPageIndicatorAuto: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorUIModel
    private let visible: Int
    private let center: Int
    private let finiteLimit: Int
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Intializers
    init(
        uiModel: VPageIndicatorUIModel,
        visible: Int,
        center: Int,
        finiteLimit: Int,
        total: Int,
        selectedIndex: Int
    ) {
        self.uiModel = uiModel
        self.visible = visible
        self.center = center
        self.finiteLimit = finiteLimit
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    @ViewBuilder var body: some View {
        switch total {
        case ...finiteLimit:
            VPageIndicatorFinite(uiModel: uiModel, total: total, selectedIndex: selectedIndex)
            
        default:
            VPageIndicatorInfinite(uiModel: uiModel, visible: visible, center: center, total: total, selectedIndex: selectedIndex)
        }
    }
}

// MARK: - Preview
struct VPageIndicatorAuto_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorAuto(
            uiModel: .init(),
            visible: 7,
            center: 3,
            finiteLimit: 10,
            total: 20,
            selectedIndex: 4
        )
    }
}
