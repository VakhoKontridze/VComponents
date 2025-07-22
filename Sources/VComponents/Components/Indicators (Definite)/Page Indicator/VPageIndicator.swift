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
/// Direction can be changed via `direction` in Appearance, or passing `vertical` instance.
///
///     var body: some View {
///         VPageIndicator(
///             appearance: .vertical,
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
///     private let pageIndicatorAppearance: VPageIndicatorAppearance = {
///         var appearance: VPageIndicatorAppearance = .init()
///         appearance.dotWidths = VPageIndicatorAppearance.DotStateOptionalDimensions(16)
///         appearance.dotHeights = VPageIndicatorAppearance.DotStateDimensions(16)
///         return appearance
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             appearance: pageIndicatorAppearance,
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
///             .foregroundStyle(pageIndicatorAppearance.dotColors.value(for: internalState))
///         }
///     }
///
/// Component can be stretched on its primary axis by removing primary dimension.
/// Standard circular shape doesn't support stretching.
///
///     private let pageIndicatorAppearance: VPageIndicatorAppearance = {
///         var appearance: VPageIndicatorAppearance = .init()
///         appearance.dotWidths = VPageIndicatorAppearance.DotStateOptionalDimensions(nil)
///         appearance.dotHeights = VPageIndicatorAppearance.DotStateDimensions(4)
///         return appearance
///     }()
///
///     var body: some View {
///         VPageIndicator(
///             appearance: pageIndicatorAppearance,
///             total: total,
///             current: current
///         ) { (internalState, _) in
///             RoundedRectangle(cornerRadius: 2)
///                 .foregroundStyle(pageIndicatorAppearance.dotColors.value(for: internalState))
///         }
///         .padding()
///     }
///
public struct VPageIndicator<CustomDotContent>: View where CustomDotContent: View {
    // MARK: Properties - Appearance
    private let appearance: VPageIndicatorAppearance

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
        appearance: VPageIndicatorAppearance,
        total: Int,
        current: Int,
        dotContent: VPageIndicatorDotContent<CustomDotContent>
    ) {
        self.appearance = appearance
        self.total = total
        self.current = current
        self.dotContent = dotContent
    }

    // MARK: Initializers - Public
    /// Initializes `VPageIndicator` with total and current index.
    public init(
        appearance: VPageIndicatorAppearance = .init(),
        total: Int,
        current: Int
    )
        where CustomDotContent == Never
    {
        self.appearance = appearance
        self.total = total
        self.current = current
        self.dotContent = .standard
    }
    
    /// Initializes `VPageIndicator` with total, current index, and custom dot content.
    public init(
        appearance: VPageIndicatorAppearance = .init(),
        total: Int,
        current: Int,
        @ViewBuilder dotContent customDotContent: @escaping (VPageIndicatorDotInternalState, Int) -> CustomDotContent
    ) {
        self.appearance = appearance
        self.total = total
        self.current = current
        self.dotContent = .custom(custom: customDotContent)
    }
    
    // MARK: Body
    public var body: some View {
        let range: [Int] = (0..<total)
            .reversedArray(appearance.direction.isReversed)
        
        let layout: AnyLayout = appearance.direction
            .stackLayout(spacing: appearance.spacing)
        
        return layout {
            ForEach(range, id: \.self, content: dotContentView)
        }
        .applyIf(appearance.appliesTransitionAnimation) { $0.animation(appearance.transitionAnimation, value: current) }
    }
    
    private func dotContentView(
        index: Int
    ) -> some View {
        let internalState: VPageIndicatorDotInternalState = dotInternalState(index)

        return Group {
            switch dotContent {
            case .standard:
                ZStack {
                    RoundedRectangle(cornerRadius: appearance.dotCornerRadii.value(for: internalState))
                        .foregroundStyle(appearance.dotColors.value(for: internalState))
                    
                    let borderWidth: CGFloat = appearance.dotBorderWidths.value(for: internalState)
                    if borderWidth > 0 {
                        RoundedRectangle(cornerRadius: appearance.dotCornerRadii.value(for: internalState))
                            .strokeBorder(appearance.dotBorderColors.value(for: internalState), lineWidth: borderWidth)
                    }
                }
                
            case .custom(let custom):
                custom(internalState, index)
            }
        }
        .frame(
            width:
                appearance.direction.isHorizontal ?
                appearance.dotWidths.value(for: internalState) :
                appearance.dotHeights.value(for: internalState),
            height:
                appearance.direction.isHorizontal ?
                appearance.dotHeights.value(for: internalState) :
                appearance.dotWidths.value(for: internalState)
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
                appearance: {
                    var appearance: VPageIndicatorAppearance = .init()
                    appearance.direction = .leftToRight
                    return appearance
                }(),
                total: total,
                current: current
            )
        }

        PreviewRow("Right-to-Left") {
            VPageIndicator(
                appearance: {
                    var appearance: VPageIndicatorAppearance = .init()
                    appearance.direction = .rightToLeft
                    return appearance
                }(),
                total: total,
                current: current
            )
        }

        HStack(spacing: 20) {
            PreviewRow("Top-to-Bottom") {
                VPageIndicator(
                    appearance: {
                        var appearance: VPageIndicatorAppearance = .init()
                        appearance.direction = .topToBottom
                        return appearance
                    }(),
                    total: total,
                    current: current
                )
            }

            PreviewRow("Bottom-to-Top") {
                VPageIndicator(
                    appearance: {
                        var appearance: VPageIndicatorAppearance = .init()
                        appearance.direction = .bottomToTop
                        return appearance
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
            appearance: {
                var appearance: VPageIndicatorAppearance = .init()
                appearance.dotWidths.selected? *= 3
                return appearance
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

    let appearance: VPageIndicatorAppearance = {
        var appearance: VPageIndicatorAppearance = .init()
        appearance.direction = .leftToRight
        appearance.dotWidths = VPageIndicatorAppearance.DotStateOptionalDimensions(nil)
        appearance.dotHeights = VPageIndicatorAppearance.DotStateDimensions(4)
        return appearance
    }()

    PreviewContainer {
        VPageIndicator(
            appearance: appearance,
            total: total,
            current: current
        ) { (internalState, _) in
            RoundedRectangle(cornerRadius: 2)
                .foregroundStyle(appearance.dotColors.value(for: internalState))
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
