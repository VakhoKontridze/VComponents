//
//  VPageIndicatorAutomatic.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator Automatic
struct VPageIndicatorAutomatic<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VPageIndicatorAutomaticUIModel
    
    private let total: Int
    private let selectedIndex: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>

    // MARK: Initializers
    init(
        uiModel: VPageIndicatorAutomaticUIModel,
        total: Int,
        selectedIndex: Int,
        dotContent: VPageIndicatorDotContent<Content>
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = dotContent
    }

    // MARK: Body
    var body: some View {
        switch total {
        case ...uiModel.layout.standardDotLimit:
            VPageIndicatorStandard(
                uiModel: uiModel.standardPageIndicatorSubUIModel,
                total: total,
                selectedIndex: selectedIndex,
                dotContent: dotContent
            )
            
        default:
            VPageIndicatorCompact(
                uiModel: uiModel.compactPageIndicatorSubUIModel,
                total: total,
                selectedIndex: selectedIndex,
                dotContent: dotContent
            )
        }
    }
}

// MARK: - Preview
struct VPageIndicatorAutomatic_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VPageIndicatorStandard_Previews.previews
            
            Divider()
            
            VPageIndicatorCompact_Previews.previews
        })
    }
}
