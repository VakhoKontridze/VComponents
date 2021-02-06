//
//  VPageIndicatorDynamic.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK:- V Page Indicator Dynamic
struct VPageIndicatorDynamic: View {
    // MARK: Properties
    private let model: VPageIndicatorModel
    private let visible: Int
    private let center: Int
    private let threshold: Int
    
    private let total: Int
    private let selectedIndex: Int

    // MARK: Intializers
    public init(
        model: VPageIndicatorModel,
        visible: Int,
        center: Int,
        threshold: Int,
        total: Int,
        selectedIndex: Int
    ) {
        self.model = model
        self.visible = visible
        self.center = center
        self.threshold = threshold
        self.total = total
        self.selectedIndex = selectedIndex
    }
}

// MARK:- Body
extension VPageIndicatorDynamic {
    @ViewBuilder var body: some View {
        switch total {
        case ...threshold:
            VPageIndicatorFinite(model: model, total: total, selectedIndex: selectedIndex)
            
        default:
            VPageIndicatorInfinite(model: model, visible: visible, center: center, total: total, selectedIndex: selectedIndex)
        }
    }
}

// MARK:- Preview
struct VPageIndicatorDynamic_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorDynamic(
            model: .init(),
            visible: 7,
            center: 3,
            threshold: 10,
            total: 20,
            selectedIndex: 4
        )
    }
}
