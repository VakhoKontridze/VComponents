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
///     @State private var current: Int = 4
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             total: total,
///             current: current
///         )
///     }
///
/// You can change direction by modifying `direction` in UI models, or passing `vertical` instance:
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             current: current
///         )
///     }
///
/// You can fully customize dot by passing a `dot` parameter. For instance, we can get a "bullet" shape.
/// `.frame()` modifier shouldn't be applied to the dot itself.
///
///     var body: some View {
///         VAutomaticPageIndicator(
///             uiModel: {
///                 var uiModel: VPageIndicatorUIModel = .init()
///                 uiModel.layout.dotWidth = 15
///                 uiModel.layout.dotHeight = 15
///                 return uiModel
///             }(),
///             total: total,
///             current: current,
///             dot: {
///                 ZStack(content: {
///                     Circle()
///                         .stroke(lineWidth: 1)
///                         .padding(1)
///
///                     Circle()
///                         .padding(3)
///                 })
///             }
///         )
///         .padding()
///     }
///
public struct VAutomaticPageIndicator<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VAutomaticPageIndicatorUIModel
    
    private let total: Int
    private let current: Int
    
    private let dotContent: VPageIndicatorDotContent<Content>
    
    // MARK: Initializers
    /// Initializes `VAutomaticPageIndicator` with total and current index.
    public init(
        uiModel: VAutomaticPageIndicatorUIModel = .init(),
        total: Int,
        current: Int
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .empty
    }
    
    /// Initializes `VAutomaticPageIndicator` with total, current index, and custom dot content.
    public init(
        uiModel: VAutomaticPageIndicatorUIModel = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dot: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .content(content: dot)
    }
    
    // MARK: Body
    public var body: some View {
        switch total {
        case ...uiModel.standardDotLimit:
            VPageIndicator(
                uiModel: uiModel.standardPageIndicatorSubUIModel,
                total: total,
                current: current,
                dotContent: dotContent
            )
            
        default:
            VCompactPageIndicator(
                uiModel: uiModel.compactPageIndicatorSubUIModel,
                total: total,
                current: current,
                dotContent: dotContent
            )
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VAutomaticPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicator_Previews.previews
    }
}
