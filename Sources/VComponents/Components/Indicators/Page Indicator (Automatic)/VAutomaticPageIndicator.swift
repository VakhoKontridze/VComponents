//
//  VAutomaticPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Automatic Page Indicator
/// Indicator component that indicates selection in page control in standard or compact fashion.
///
/// UI model can be passed as parameter.
///
///     private let total: Int = 10
///     @State private var selectedIndex: Int = 4
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can fully customize dot by passing a `dot` parameter. For instance, we can get a "bullet" shape.
/// `.frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             type: uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.layout.dotDimensionPrimaryAxis = 15
///                 uiModel.layout.dotDimensionSecondaryAxis = 15
///                 return uiModel
///             }(),
///             total: total,
///             selectedIndex: selectedIndex,
///             dot: {
///                 ZStack(content: {
///                     Circle()
///                         .stroke(lineWidth: 1)
///
///                     Circle()
///                         .padding(3)
///                 })
///             }
///         )
///             .padding()
///     }
///
public struct VAutomaticPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VAutomaticPageIndicatorUIModel
    
    private let total: Int
    private let selectedIndex: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>

    // MARK: Initializers
    /// Initializes `VAutomaticPageIndicator` with total and selected index.
    public init(
        uiModel: VAutomaticPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .default
    }
    
    /// Initializes `VAutomaticPageIndicator` with total, selected index, and custom dot content.
    public init(
        uiModel: VAutomaticPageIndicatorUIModel = .init(),
        total: Int,
        selectedIndex: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .custom(content: dot)
    }

    // MARK: Body
    public var body: some View {
        switch total {
        case ...uiModel.layout.standardDotLimit:
            VPageIndicator(
                uiModel: uiModel.standardPageIndicatorSubUIModel,
                total: total,
                selectedIndex: selectedIndex,
                dotContent: dotContent
            )
            
        default:
            VCompactPageIndicator(
                uiModel: uiModel.compactPageIndicatorSubUIModel,
                total: total,
                selectedIndex: selectedIndex,
                dotContent: dotContent
            )
        }
    }
}

// MARK: - Preview
struct VAutomaticPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VPageIndicator_Previews.previews
            
            Divider()
            
            VPageIndicatorCompact_Previews.previews
        })
    }
}
