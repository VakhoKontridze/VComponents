//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK:- V Page Indicator
/// Indicator component that indicates selection in page control
///
/// Model and type can be passed as parameters
///
/// There are three possible types:
///
/// 1. `Finite`.
/// Finite number of dots would be displayed.
///
/// 2. `Infinite`.
/// Infinite dots are possible, but only dots specified by `visible` will be displayed.
/// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
/// If odd `visible` and `center` are not passed, layout would invalidate itself, and refuse to draw.
///
/// 3. `Auto`.
/// Switches from `finite` to `infinite` after a `finiteLimit`.
///
/// # Usage Example #
///
/// ```
/// let total: Int = 10
/// @State var selectedIndex: Int = 4
///
/// var body: some View {
///     VPageIndicator(
///         total: 10,
///         selectedIndex: selectedIndex
///     )
/// }
/// ```
///
public struct VPageIndicator: View {
    // MARK: Properties
    private let model: VPageIndicatorModel
    private let pageIndicatorType: VPageIndicatorType
    
    private let total: Int
    
    private let selectedIndex: Int
    @State private var animatableSelectedIndex: Int?

    // MARK: Intializers
    /// Initializes component with total and selected index
    public init(
        model: VPageIndicatorModel = .init(),
        type pageIndicatorType: VPageIndicatorType = .default,
        total: Int,
        selectedIndex: Int
    ) {
        self.model = model
        self.pageIndicatorType = pageIndicatorType
        self.total = total
        self.selectedIndex = selectedIndex
    }
}

// MARK:- Body
extension VPageIndicator {
    public var body: some View {
        performStateSets()
        
        return Group(content: {
            switch pageIndicatorType {
            case .finite:
                VPageIndicatorFinite(
                    model: model,
                    total: total,
                    selectedIndex: animatableSelectedIndex ?? selectedIndex
                )
            
            case .infinite(let visible, let center):
                VPageIndicatorInfinite(
                    model: model,
                    visible: visible,
                    center: center,
                    total: total,
                    selectedIndex: animatableSelectedIndex ?? selectedIndex
                )
            
            case .auto(let visible, let center, let finiteLimit):
                VPageIndicatorAuto(
                    model: model,
                    visible: visible,
                    center: center,
                    finiteLimit: finiteLimit,
                    total: total,
                    selectedIndex: animatableSelectedIndex ?? selectedIndex
                )
            }
        })
    }
}

// MARK:- State Sets
private extension VPageIndicator {
    func performStateSets() {
        DispatchQueue.main.async(execute: {
            withAnimation(model.animations.transition, {
                animatableSelectedIndex = selectedIndex
            })
        })
    }
}

// MARK:- Preview
struct VPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VPageIndicator(type: .finite, total: 9, selectedIndex: 4)
            VPageIndicator(type: .infinite(), total: 100, selectedIndex: 4)
            VPageIndicator(type: .auto(), total: 100, selectedIndex: 4)
        })
    }
}
