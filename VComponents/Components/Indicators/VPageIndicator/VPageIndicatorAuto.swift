//
//  VPageIndicatorAuto.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK:- V Page Indicator Auto
struct VPageIndicatorAuto: View {
    // MARK: Properties
    private let model: VPageIndicatorModel
    private let visible: Int
    private let center: Int
    private let finiteLimit: Int
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Intializers
    init(
        model: VPageIndicatorModel,
        visible: Int,
        center: Int,
        finiteLimit: Int,
        total: Int,
        selectedIndex: Int
    ) {
        self.model = model
        self.visible = visible
        self.center = center
        self.finiteLimit = finiteLimit
        self.total = total
        self.selectedIndex = selectedIndex
    }
}

// MARK:- Body
extension VPageIndicatorAuto {
    @ViewBuilder var body: some View {
        switch total {
        case ...finiteLimit:
            VPageIndicatorFinite(model: model, total: total, selectedIndex: selectedIndex)
            
        default:
            VPageIndicatorInfinite(model: model, visible: visible, center: center, total: total, selectedIndex: selectedIndex)
        }
    }
}

// MARK:- Preview
struct VPageIndicatorAuto_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorAuto(
            model: .init(),
            visible: 7,
            center: 3,
            finiteLimit: 10,
            total: 20,
            selectedIndex: 4
        )
    }
}
