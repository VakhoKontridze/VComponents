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
///     private let total: Int = 10
///     @State private var selectedIndex: Int = 4
///
///     var body: some View {
///         VPageIndicator(
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VPageIndicator(
///             type: .compact(uiModel: .vertical),
///             total: total,
///             selectedIndex: selectedIndex
///         )
///     }
///
/// You can fully customize dot by passing a `dot` parameter. For instance, we can get a "bullet" shape.
/// `.frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VPageIndicator(
///             type: .standard(uiModel: {
///                 var uiModel: VPageIndicatorStandardUIModel = .init()
///                 uiModel.layout.dotDimensionPrimaryAxis = 15
///                 uiModel.layout.dotDimensionSecondaryAxis = 15
///                 return uiModel
///             }()),
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
/// You can stretch the component on it's primary axis by removing dimension.
/// Standard circular shape doesn't support stretching.
///
///     var body: some View {
///         VPageIndicator(
///             type: .standard(uiModel: {
///                 var uiModel: VPageIndicatorStandardUIModel = .init()
///                 uiModel.layout.dotDimensionPrimaryAxis = nil
///                 uiModel.layout.dotDimensionSecondaryAxis = 5
///                 return uiModel
///             }()),
///             total: total,
///             selectedIndex: selectedIndex,
///             dot: { Rectangle() }
///         )
///             .padding()
///
public struct VPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let pageIndicatorType: VPageIndicatorType
    
    private let total: Int
    private let selectedIndex: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>

    // MARK: Initializers
    /// Initializes component with total and selected index.
    public init(
        type pageIndicatorType: VPageIndicatorType = .default,
        total: Int,
        selectedIndex: Int
    )
        where Content == Never
    {
        self.pageIndicatorType = pageIndicatorType
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .default
    }
    
    /// Initializes component with total, selected index, and custom dot content.
    public init(
        type pageIndicatorType: VPageIndicatorType = .default,
        total: Int,
        selectedIndex: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        self.pageIndicatorType = pageIndicatorType
        self.total = total
        self.selectedIndex = selectedIndex
        self.dotContent = .custom(content: dot)
    }

    // MARK: Body
    public var body: some View {
        Group(content: {
            switch pageIndicatorType._pageIndicatorType {
            case .standard(let uiModel):
                VPageIndicatorStandard(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex,
                    dotContent: dotContent
                )
            
            case .compact(let uiModel):
                VPageIndicatorCompact(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex,
                    dotContent: dotContent
                )
            
            case .automatic(let uiModel):
                VPageIndicatorAutomatic(
                    uiModel: uiModel,
                    total: total,
                    selectedIndex: selectedIndex,
                    dotContent: dotContent
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
