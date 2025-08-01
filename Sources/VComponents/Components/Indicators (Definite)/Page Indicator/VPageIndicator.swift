//
//  VPageIndicator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

/// Indicator component that represents selection in page control.
///
///     @State private var current: Int = 4
///     private let total: Int = 10
///
///     var body: some View {
///         VPageIndicator(
///             current: current,
///             total: total
///         )
///     }
///
/// Direction can be changed via `direction` in Appearance, or passing `vertical` instance.
///
///     var body: some View {
///         VPageIndicator(
///             appearance: .vertical,
///             current: current,
///             total: total
///         )
///     }
///
/// Component can dynamically switch to `VCompactPageIndicator` using `ViewThatFits`.
///
///     var body: some View {
///         ViewThatFits(in: .horizontal) {
///             VPageIndicator(
///                 current: current,
///                 total: total
///             )
///
///             VCompactPageIndicator(
///                 current: current,
///                 total: total
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
///             current: current),
///             total: total
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
///             current: current,
///             total: total
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
    private let current: Int
    private let total: Int

    // MARK: Properties - Dot Content
    private let dotContent: VPageIndicatorDotContent<CustomDotContent>

    // MARK: Initializers - Internal
    init(
        appearance: VPageIndicatorAppearance,
        current: Int,
        total: Int,
        dotContent: VPageIndicatorDotContent<CustomDotContent>
    ) {
        self.appearance = appearance
        self.current = current
        self.total = total
        self.dotContent = dotContent
    }

    // MARK: Initializers - Public
    /// Initializes `VPageIndicator` with total and current index.
    public init(
        appearance: VPageIndicatorAppearance = .init(),
        current: Int,
        total: Int
    )
        where CustomDotContent == Never
    {
        self.appearance = appearance
        self.current = current
        self.total = total
        self.dotContent = .standard
    }
    
    /// Initializes `VPageIndicator` with current index, total number, and custom dot content.
    public init(
        appearance: VPageIndicatorAppearance = .init(),
        current: Int,
        total: Int,
        @ViewBuilder dotContent customDotContent: @escaping (VPageIndicatorDotInternalState, Int) -> CustomDotContent
    ) {
        self.appearance = appearance
        self.current = current
        self.total = total
        self.dotContent = .custom(builder: customDotContent)
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
                
            case .custom(let builder):
                builder(internalState, index)
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

#if DEBUG

#Preview("*") {
    @Previewable @State var current: Int = 0 // '@Previewable' items must be at the beginning of the preview block
    let total: Int = 10

    PreviewContainer {
        VPageIndicator(
            current: current,
            total: total
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
                current: current,
                total: total
            )
        }

        PreviewRow("Right-to-Left") {
            VPageIndicator(
                appearance: {
                    var appearance: VPageIndicatorAppearance = .init()
                    appearance.direction = .rightToLeft
                    return appearance
                }(),
                current: current,
                total: total
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
                    current: current,
                    total: total
                )
            }

            PreviewRow("Bottom-to-Top") {
                VPageIndicator(
                    appearance: {
                        var appearance: VPageIndicatorAppearance = .init()
                        appearance.direction = .bottomToTop
                        return appearance
                    }(),
                    current: current,
                    total: total
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
            current: current,
            total: total
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
            current: current,
            total: total
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
            current: 0,
            total: 0
        )
    }
}

#endif
