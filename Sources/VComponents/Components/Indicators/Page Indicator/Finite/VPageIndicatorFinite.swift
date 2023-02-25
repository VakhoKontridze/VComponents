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
        let layout: AnyLayout = {
            switch uiModel.layout.axis {
            case .horizontal: return .init(HStackLayout(spacing: uiModel.layout.spacing))
            case .vertical: return .init(VStackLayout(spacing: uiModel.layout.spacing))
            }
        }()
        
        return layout.callAsFunction({
            ForEach(0..<total, id: \.self, content: { i in
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
            ForEach(Axis.allCases, id: \.rawValue, content: { axis in
                VPageIndicatorFinite(
                    uiModel: {
                        var uiModel: VPageIndicatorFiniteUIModel = .init()
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
