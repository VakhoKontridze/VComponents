//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - V Page Indicator
/// Indicator component that indicates selection in page control.
///
/// Type can be passed as parameter.
///
///     let total: Int = 10
///     @State var selectedIndex: Int = 4
///
///     var body: some View {
///         VPageIndicator(
///             total: 10,
///             selectedIndex: selectedIndex
///         )
///     }
///
public struct VPageIndicator: View {
    // MARK: Properties
    private let pageIndicatorType: VPageIndicatorType
    
    private let total: Int
    
    private let selectedIndex: Int

    // MARK: Initializers
    /// Initializes component with total and selected index.
    public init(
        type pageIndicatorType: VPageIndicatorType = .default,
        total: Int,
        selectedIndex: Int
    ) {
        self.pageIndicatorType = pageIndicatorType
        self.total = total
        self.selectedIndex = selectedIndex
    }

    // MARK: Body
    public var body: some View {
        Group(content: {
            switch pageIndicatorType._pageIndicatorType {
            case .standard(let uiModel):
                VPageIndicatorStandard(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex
                )
            
            case .compact(let uiModel):
                VPageIndicatorCompact(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex
                )
            
            case .automatic(let uiModel):
                VPageIndicatorAutomatic(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex
                )
            }
        })
    }
}

// MARK: - Preview
struct VPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VPageIndicator(type: .standard(), total: 9, selectedIndex: 4)
            VPageIndicator(type: .compact(), total: 100, selectedIndex: 4)
            VPageIndicator(type: .automatic(), total: 100, selectedIndex: 4)
        })
    }
}
