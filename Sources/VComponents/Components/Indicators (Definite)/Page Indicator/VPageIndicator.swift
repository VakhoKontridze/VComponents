//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator
/// Indicator component that represents selection in page control.
///
///     private let total: Int = 10
///     @State private var current: Int = 4
///
///     var body: some View {
///         VPageIndicator(
///             total: total,
///             current: current
///         )
///     }
///
/// Direction can be changed via `direction` in UI models, or passing `vertical` instance.
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: .vertical,
///             total: total,
///             current: current
///         )
///     }
///
/// Component can dynamically switch to `VCompactPageIndicator` using `ViewThatFits`.
///
///     var body: some View {
///         ViewThatFits(in: .horizontal) {
///             VPageIndicator(
///                 total: total,
///                 current: current
///             )
///
///             VCompactPageIndicator(
///                 total: total,
///                 current: current
///             )
///         }
///     }
///
/// Dots can be fully customized. For instance, we can get a "bullet" shape.
/// `frame()` modifier shouldn't be applied to the dot itself.
///
///     private let pageIndicatorUIModel: VPageIndicatorUIModel = {
///         var uiModel: VPageIndicatorUIModel = .init()
///         uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(16)
///         uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(16)
///         return uiModel
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: pageIndicatorUIModel,
///             total: total,
///             current: current)
///          ) { (internalState, _) in
///             ZStack {
///                 Circle()
///                     .stroke(lineWidth: 1)
///                     .padding(1)
///
///                 Circle()
///                     .padding(3)
///             }
///             .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
///         }
///     }
///
/// Component can be stretched on its primary axis by removing primary dimension.
/// Standard circular shape doesn't support stretching.
///
///     private let pageIndicatorUIModel: VPageIndicatorUIModel = {
///         var uiModel: VPageIndicatorUIModel = .init()
///         uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(nil)
///         uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(4)
///         return uiModel
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             uiModel: pageIndicatorUIModel,
///             total: total,
///             current: current
///         ) { (internalState, _) in
///             RoundedRectangle(cornerRadius: 2)
///                 .foregroundStyle(pageIndicatorUIModel.dotColors.value(for: internalState))
///         }
///         .padding()
///     }
///
public struct VPageIndicator<CustomDotContent>: View where CustomDotContent: View {
    // MARK: Properties - UI Model
    private let uiModel: VPageIndicatorUIModel

    // MARK: Properties - State
    private func dotInternalState(
        _ index: Int
    ) -> VPageIndicatorDotInternalState {
        .init(
            isSelected: index == current
        )
    }

    // MARK: Properties - Data
    private let total: Int
    private let current: Int

    // MARK: Properties - Dot Content
    private let dotContent: VPageIndicatorDotContent<CustomDotContent>

    // MARK: Initializers - Internal
    init(
        uiModel: VPageIndicatorUIModel,
        total: Int,
        current: Int,
        dotContent: VPageIndicatorDotContent<CustomDotContent>
    ) {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = dotContent
    }

    // MARK: Initializers - Public
    /// Initializes `VPageIndicator` with total and current index.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        current: Int
    )
        where CustomDotContent == Never
    {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .standard
    }
    
    /// Initializes `VPageIndicator` with total, current index, and custom dot content.
    public init(
        uiModel: VPageIndicatorUIModel = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dotContent customDotContent: @escaping (VPageIndicatorDotInternalState, Int) -> CustomDotContent
    ) {
        self.uiModel = uiModel
        self.total = total
        self.current = current
        self.dotContent = .custom(custom: customDotContent)
    }
    
    // MARK: Body
    public var body: some View {
        let range: [Int] = (0..<total)
            .reversedArray(uiModel.direction.isReversed)
        
        let layout: AnyLayout = uiModel.direction
            .stackLayout(spacing: uiModel.spacing)
        
        return layout {
            ForEach(range, id: \.self, content: dotContentView)
        }
        .applyIf(uiModel.appliesTransitionAnimation) { $0.animation(uiModel.transitionAnimation, value: current) }
    }
    
    private func dotContentView(
        index: Int
    ) -> some View {
        let internalState: VPageIndicatorDotInternalState = dotInternalState(index)

        return Group {
            switch dotContent {
            case .standard:
                ZStack {
                    RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                        .foregroundStyle(uiModel.dotColors.value(for: internalState))
                    
                    let borderWidth: CGFloat = uiModel.dotBorderWidths.value(for: internalState)
                    if borderWidth > 0 {
                        RoundedRectangle(cornerRadius: uiModel.dotCornerRadii.value(for: internalState))
                            .strokeBorder(uiModel.dotBorderColors.value(for: internalState), lineWidth: borderWidth)
                    }
                }
                
            case .custom(let custom):
                custom(internalState, index)
            }
        }
        .frame(
            width:
                uiModel.direction.isHorizontal ?
                uiModel.dotWidths.value(for: internalState) :
                uiModel.dotHeights.value(for: internalState),
            height:
                uiModel.direction.isHorizontal ?
                uiModel.dotHeights.value(for: internalState) :
                uiModel.dotWidths.value(for: internalState)
        )
    }
}

// MARK: - Preview
#if DEBUG

#Preview("*") {
    @Previewable @State var current: Int = 0 // '@Previewable' items must be at the beginning of the preview block
    let total: Int = 10

    PreviewContainer {
        VPageIndicator(
            total: total,
            current: current
        )
    }
    .onReceiveOfTimerIncrement($current, to: total-1)
}

#Preview("Layout Directions") {
    @Previewable @State var current: Int = 0 // '@Previewable' items must be at the beginning of the preview block
    let total: Int = 10
    
    PreviewContainer {
        PreviewRow("Left-to-Right") {
            VPageIndicator(
                uiModel: {
                    var uiModel: VPageIndicatorUIModel = .init()
                    uiModel.direction = .leftToRight
                    return uiModel
                }(),
                total: total,
                current: current
            )
        }

        PreviewRow("Right-to-Left") {
            VPageIndicator(
                uiModel: {
                    var uiModel: VPageIndicatorUIModel = .init()
                    uiModel.direction = .rightToLeft
                    return uiModel
                }(),
                total: total,
                current: current
            )
        }

        HStack(spacing: 20) {
            PreviewRow("Top-to-Bottom") {
                VPageIndicator(
                    uiModel: {
                        var uiModel: VPageIndicatorUIModel = .init()
                        uiModel.direction = .topToBottom
                        return uiModel
                    }(),
                    total: total,
                    current: current
                )
            }

            PreviewRow("Bottom-to-Top") {
                VPageIndicator(
                    uiModel: {
                        var uiModel: VPageIndicatorUIModel = .init()
                        uiModel.direction = .bottomToTop
                        return uiModel
                    }(),
                    total: total,
                    current: current
                )
            }
        }
    }
    .onReceiveOfTimerIncrement($current, to: total-1)
}

#Preview("Different Sizes") {
    @Previewable @State var current: Int = 0 // '@Previewable' items must be at the beginning of the preview block
    let total: Int = 10

    PreviewContainer {
        VPageIndicator(
            uiModel: {
                var uiModel: VPageIndicatorUIModel = .init()
                uiModel.dotWidths.selected? *= 3
                return uiModel
            }(),
            total: total,
            current: current
        )
    }
    .onReceiveOfTimerIncrement($current, to: total-1)
}

#Preview("Stretched") {
    @Previewable @State var current: Int = 0 // '@Previewable' items must be at the beginning of the preview block
    let total: Int = 10

    let uiModel: VPageIndicatorUIModel = {
        var uiModel: VPageIndicatorUIModel = .init()
        uiModel.direction = .leftToRight
        uiModel.dotWidths = VPageIndicatorUIModel.DotStateOptionalDimensions(nil)
        uiModel.dotHeights = VPageIndicatorUIModel.DotStateDimensions(4)
        return uiModel
    }()

    PreviewContainer {
        VPageIndicator(
            uiModel: uiModel,
            total: total,
            current: current
        ) { (internalState, _) in
            RoundedRectangle(cornerRadius: 2)
                .foregroundStyle(uiModel.dotColors.value(for: internalState))
        }
        .padding(.horizontal)
    }
    .onReceiveOfTimerIncrement($current, to: total-1)
}

#Preview("Zero") {
    PreviewContainer {
        VPageIndicator(
            total: 0,
            current: 0
        )
    }
}

#endif
