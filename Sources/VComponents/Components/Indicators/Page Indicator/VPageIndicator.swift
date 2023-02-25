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
/// UI Model and type can be passed as parameters.
///
/// There are three possible types:
///
/// 1. `Finite`.
/// Finite number of dots would be displayed.
///
/// 2. `Infinite`.
/// Infinite dots are possible, but only dots specified by `visible` will be displayed.
/// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
/// `visible` and `center` dots must be odd.
///
/// 3. `Auto`.
/// Switches from `finite` to `infinite` after a `finiteLimit`.
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
            case .finite(let uiModel):
                VPageIndicatorFinite(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex
                )
            
            case .infinite(let uiModel):
                VPageIndicatorInfinite(
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
            VPageIndicator(type: .finite(), total: 9, selectedIndex: 4)
            VPageIndicator(type: .infinite(), total: 100, selectedIndex: 4)
            VPageIndicator(type: .automatic(), total: 100, selectedIndex: 4)
        })
    }
}
