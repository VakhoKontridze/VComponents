//
//  VCarousel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.07.24.
//

import SwiftUI
import VCore

// MARK: - V Carousel
/// Container component that paginates between child views horizontally.
///
///     private enum WeekDay: Int, Hashable, Identifiable, CaseIterable {
///         case monday, tuesday, wednesday, thursday, friday, saturday, sunday
///
///         var id: Int { rawValue }
///
///         var color: Color {
///             switch rawValue.quotientAndRemainder(dividingBy: 3).remainder {
///             case 0: Color.red
///             case 1: Color.green
///             case 2: Color.blue
///             default: fatalError()
///             }
///         }
///     }
///
///     @State private var selection: WeekDay = .monday
///     private var selectedIndex: Int? { WeekDay.allCases.firstIndex(of: selection) }
///
///     var body: some View {
///         VStack(spacing: 15, content: {
///             VCarousel(
///                 selection: $selection,
///                 data: WeekDay.allCases,
///                 content: {
///                     $0
///                         .color
///                         .clipShape(.rect(cornerRadius: 15))
///                 }
///             )
///             .frame(height: 200)
///
///             VPageIndicator(
///                 total: 7,
///                 current: selectedIndex ?? 0
///             )
///         })
///     }
///
/// `VCarousel` also supports infinite scroll. Fore more info, refer to `VCarouselInfiniteScrollDataSourceManager`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(tvOS, unavailable) // `scrollPosition(id:)` API doesn't work
public struct VCarousel<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VCarouselUIModel

    // MARK: Properties - State - Card
    private func cardInternalState(
        isSelected: Bool
    ) -> VCarouselCardInternalState {
        .init(
            isSelected: isSelected
        )
    }

    // MARK: Properties - Selection
    @Binding private var selection: Data.Element

    private var selectionIDBinding: Binding<ID?> {
        .init(
            get: {
                selection[keyPath: id]
            },
            set: { newValue in
                if let element: Data.Element = data.first(where: { $0[keyPath: id] == newValue }) {
                    selection = element
                }
            }
        )
    }

    // MARK: Properties - Data
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content

    // MARK: Initializers
    /// Initializes `VCarousel` with selection, data, id, and content.
    public init(
        uiModel: VCarouselUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.content = content
    }

    /// Initializes `VCarousel` with selection, data, and content.
    public init(
        uiModel: VCarouselUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = \.id
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        GeometryReader(content: { geometryProxy in
            ScrollViewReader(content: { scrollViewProxy in
                ScrollView(.horizontal, content: {
                    LazyHStack( // `scrollPosition(id:)` doesn't work with `HStack`
                        alignment: uiModel.cardsAlignment,
                        spacing: uiModel.cardsSpacing,
                        content: {
                            ForEach(data, id: id, content: { element in
                                cardView(
                                    geometryProxy: geometryProxy,
                                    element: element
                                )
                                .id(element[keyPath: id])
                            })
                    })
                    .scrollTargetLayout()
                })
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: selectionIDBinding)

                .contentMargins(.horizontal, uiModel.cardMarginHorizontal, for: .scrollContent)
                .contentMargins(.top, uiModel.cardMarginTop, for: .scrollContent)
                .contentMargins(.bottom, uiModel.cardMarginBottom, for: .scrollContent)

                .scrollDisabled(!uiModel.isScrollingEnabled)
                .scrollIndicators(.hidden)

                .applyIf(uiModel.appliesSelectionAnimation, transform: {
                    $0.animation(uiModel.selectionAnimation, value: selection)
                })

                .onFirstAppear(perform: {
                    Task(operation: { @MainActor in // Fixes glitch on some platforms
                        scrollViewProxy.scrollTo(selection[keyPath: id]) // Doesn't have an animation
                    })
                })
            })
        })
        .clipped() // Clips off-bound content that appears on some platforms
    }

    private func cardView(
        geometryProxy: GeometryProxy,
        element: Data.Element
    ) -> some View {
        // These properties cannot be extracted within `scrollTransition(transition:`,
        // as they are `MainActor`, while method is not.
        let cardState: VCarouselCardInternalState = cardInternalState(isSelected: selection == element)
        let scaleEffect: CGFloat = uiModel.cardHeightScales.value(for: cardState)
        let opacity: CGFloat = uiModel.cardOpacities.value(for: cardState)
        
        return ZStack(content: {
            content(element)
        })
        .frame(
            width: {
                let width: CGFloat = geometryProxy.size.width - uiModel.cardMarginHorizontal*2
                guard width > 0 else { return nil }
                return width
            }()
        )

        .containerRelativeFrame(.horizontal)
        .scrollTransition(transition: { (view, _) in
            view
                .scaleEffect(y: scaleEffect)
                .opacity(opacity)
        })

        .shadow(
            color: uiModel.cardShadowColor,
            radius: uiModel.cardShadowRadius,
            offset: uiModel.cardShadowOffset
        )
    }
}

// MARK: - Preview
#if DEBUG

#if !os(tvOS)

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("*", body: {
    @Previewable @State var selection: Preview_Weekday = .monday
    var selectedIndex: Int? { Preview_Weekday.allCases.firstIndex(of: selection) }

    PreviewContainer(content: {
        VStack(spacing: 15, content: {
            VCarousel(
                selection: $selection,
                data: Preview_Weekday.allCases,
                content: {
                    $0
                        .color
                        .clipShape(.rect(cornerRadius: preview_CornerRadius))
                }
            )
            .frame(height: preview_Height)

            VPageIndicator(
                total: 7,
                current: selectedIndex ?? 0
            )
        })
    })
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("No Items", body: {
    @Previewable @State var selection: Preview_Weekday = .monday

    PreviewContainer(content: {
        VCarousel(
            selection: $selection,
            data: [],
            content: {
                $0
                    .color
                    .clipShape(.rect(cornerRadius: preview_CornerRadius))
            }
        )
        .frame(height: preview_Height)
    })
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Infinite Items", body: {
    @Previewable @State var dataSourceManager: VCarouselInfiniteScrollDataSourceManager = .init(
        data: Preview_RGBColor.allCases,
        numberOfDuplicateGroups: 9,
        initialGroupIndex: 4,
        initialSelection: Preview_RGBColor.red
    )

    PreviewContainer(content: {
        VStack(spacing: 15, content: {
            VCarousel(
                selection: $dataSourceManager.selectedIndexInflated,
                data: 0..<dataSourceManager.countInflated,
                id: \.self,
                content: {
                    dataSourceManager.element(atInflatedIndex: $0)
                        .color
                        .clipShape(.rect(cornerRadius: preview_CornerRadius))
                }
            )
            .frame(height: preview_Height)

            VCompactPageIndicator(
                total: dataSourceManager.countInflated,
                current: dataSourceManager.selectedIndexInflated
            )
        })
    })
})

private var preview_Height: CGFloat {
#if os(iOS)
    200
#elseif os(macOS)
    200
#elseif os(watchOS)
    70
#elseif os(visionOS)
    300
#else
    fatalError() // Not supported
#endif
}

private var preview_CornerRadius: CGFloat {
#if os(iOS)
    15
#elseif os(macOS)
    15
#elseif os(watchOS)
    10
#elseif os(visionOS)
    15
#else
    fatalError() // Not supported
#endif
}

#endif

#endif
