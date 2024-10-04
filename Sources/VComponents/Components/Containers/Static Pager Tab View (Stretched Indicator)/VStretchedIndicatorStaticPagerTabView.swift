//
//  VStretchedIndicatorStaticPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched-Indicator Static Pager Tab View
/// Container component that switches between child views and is attributed with static pager with stretched rectangular indicator.
///
/// Best suited for `2` – `5` items.
///
///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable {
///         case red, green, blue
///
///         var id: Int { rawValue }
///
///         var title: String { .init(describing: self).capitalized }
///         
///         var color: Color {
///             switch self {
///             case .red: Color.red
///             case .green: Color.green
///             case .blue: Color.blue
///             }
///         }
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VStretchedIndicatorStaticPagerTabView(
///             selection: $selection,
///             data: RGBColor.allCases,
///             tabItemTitle: { $0.title },
///             content: { $0.color }
///         )
///     }
///
@available(macOS, unavailable) // No `PageTabViewStyle`
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VStretchedIndicatorStaticPagerTabView<Data, ID, CustomTabItemLabel, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        CustomTabItemLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VStretchedIndicatorStaticPagerTabViewUIModel
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    @State private var selectedTabIndicatorWidth: CGFloat = 0
    @State private var selectedTabIndicatorOffset: CGFloat = 0

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: Properties - State - Tab Item
    private func tabItemInternalState(
        _ baseButtonState: SwiftUIBaseButtonState,
        _ element: Data.Element
    ) -> VDynamicPagerTabViewTabItemInternalState {
        .init(
            isEnabled: isEnabled,
            isSelected: element == selection,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Selection
    @Binding private var selection: Data.Element
    
    private var selectedIndex: Data.Index? { data.firstIndex(of: selection) }
    private var selectedIndexInt: Int? { selectedIndex.map { data.distance(from: data.startIndex, to: $0) } }
    
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
    private let tabItemLabel: VStretchedIndicatorStaticPagerTabViewTabItemLabel<Data.Element, CustomTabItemLabel>
    private let content: (Data.Element) -> Content

    // MARK: Properties - Flags
    // Prevents animation when view appears for the first time
    @State private var enablesSelectedTabIndicatorAnimations: Bool = false

    // MARK: Initializers - Standard
    /// Initializes `VStretchedIndicatorStaticPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VStretchedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        tabItemTitle: @escaping (Data.Element) -> String,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where CustomTabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VStretchedIndicatorStaticPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VStretchedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VStretchedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .custom(custom: customTabItemLabel)
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VStretchedIndicatorStaticPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VStretchedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        tabItemTitle: @escaping (Data.Element) -> String,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            CustomTabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VStretchedIndicatorStaticPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VStretchedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VStretchedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
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
        self.tabItemLabel = .custom(custom: customTabItemLabel)
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        if data.isEmpty {
            uiModel.tabViewBackgroundColor

        } else {
            VStack(
                spacing: uiModel.tabBarAndTabViewSpacing,
                content: {
                    headerView
                    tabView
                }
            )
        }
    }

    private var headerView: some View {
        VStack(spacing: 0, content: {
            tabBarView
            tabIndicatorStripView
        })
        .background(content: { uiModel.headerBackgroundColor })

        .clipped() // Prevents bouncing tab indicator from overflowing
        .drawingGroup() // Prevents clipped tab indicator from disappearing
    }

    private var tabBarView: some View {
        HStack(
            alignment: uiModel.tabBarAlignment,
            spacing: 0,
            content: {
                ForEach(data, id: id, content: { element in
                    SwiftUIBaseButton(
                        action: { selection = element },
                        label: { baseButtonState in
                            let tabItemInternalState: VStretchedIndicatorStaticPagerTabViewTabItemInternalState = tabItemInternalState(baseButtonState, element)

                            tabItemView(
                                tabItemInternalState: tabItemInternalState,
                                element: element
                            )
                        }
                    )
                })
            }
        )
    }

    private func tabItemView(
        tabItemInternalState: VStretchedIndicatorStaticPagerTabViewTabItemInternalState,
        element: Data.Element
    ) -> some View {
        Group(content: {
            switch tabItemLabel {
            case .title(let title):
                Text(title(element))
                    .lineLimit(1)
                    .minimumScaleFactor(uiModel.tabItemTextMinimumScaleFactor)
                    .foregroundStyle(uiModel.tabItemTextColors.value(for: tabItemInternalState))
                    .font(uiModel.tabItemTextFont)
                    .applyIfLet(uiModel.tabItemTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

            case .custom(let custom):
                custom(tabItemInternalState, element)
            }
        })
        .padding(uiModel.tabItemMargins)
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
    }

    private var tabIndicatorStripView: some View {
        ZStack(
            alignment: Alignment(
                horizontal: .leading,
                vertical: uiModel.tabIndicatorStripAlignment
            ),
            content: {
                tabIndicatorTrackView
                selectedTabIndicatorView
            }
        )
    }

    private var tabIndicatorTrackView: some View {
        Rectangle()
            .frame(height: uiModel.tabIndicatorTrackHeight)
            .foregroundStyle(uiModel.tabIndicatorTrackColor)
    }

    private var selectedTabIndicatorView: some View {
        RoundedRectangle(cornerRadius: uiModel.selectedTabIndicatorCornerRadius)
            .frame(width: selectedTabIndicatorWidth)
            .frame(height: uiModel.selectedTabIndicatorHeight)

            .offset(x: selectedTabIndicatorOffset)

            .foregroundStyle(uiModel.selectedTabIndicatorColor)

            .animation(enablesSelectedTabIndicatorAnimations ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorWidth)
            .animation(enablesSelectedTabIndicatorAnimations ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorOffset)
    }

    private var tabView: some View {
        GeometryReader(content: { geometryProxy in
            Group(content: {
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    ScrollView(
                        .horizontal,
                        showsIndicators: false,
                        content: {
                            LazyHStack( // `scrollPosition(id:)` doesn't work with `HStack`
                                spacing: 0,
                                content: {
                                    ForEach(data, id: id, content: { element in
                                        content(element)
                                            .tag(element)
                                            .frame(width: geometryProxy.size.width) // Ensures that small content doesn't break page indicator calculation
                                            .frame(maxHeight: .infinity)
                                            .getFrame(in: .global, { frame in
                                                guard element == selection else { return }

                                                calculateIndicatorFrame(
                                                    selectedIndexInt: selectedIndexInt,
                                                    tabViewGeometryProxy: geometryProxy,
                                                    interstitialOffset: frame.minX
                                                )
                                            })
                                    })
                                }
                            )
                            .scrollTargetLayout()
                        }
                    )
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: selectionIDBinding)
                    
                    .background(content: { uiModel.tabViewBackgroundColor })
                    
                    .scrollDisabled(!uiModel.isTabViewScrollingEnabled)
                    
                } else {
                    TabView(selection: $selection, content: {
                        ForEach(data, id: id, content: { element in
                            content(element)
                                .tag(element)
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures that small content doesn't break page indicator calculation
                                .getFrame(in: .global, { frame in
                                    guard element == selection else { return }

                                    calculateIndicatorFrame(
                                        selectedIndexInt: selectedIndexInt,
                                        tabViewGeometryProxy: geometryProxy,
                                        interstitialOffset: frame.minX
                                    )
                                })
                        })
                    })
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(content: { uiModel.tabViewBackgroundColor })
                }
            })
            .applyModifier({
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    $0
                        .onChange(
                            of: selectedIndexInt,
                            initial: true,
                            { (_, newValue) in
                                calculateIndicatorFrame(
                                    selectedIndexInt: newValue,
                                    tabViewGeometryProxy: geometryProxy,
                                    interstitialOffset: 0
                                )
                            }
                        )

                } else {
                    $0
                        .onAppear(perform: {
                            calculateIndicatorFrame(
                                selectedIndexInt: selectedIndexInt,
                                tabViewGeometryProxy: geometryProxy,
                                interstitialOffset: 0
                            )
                        })
                        .onChange(of: selectedIndexInt, perform: { newValue in
                            calculateIndicatorFrame(
                                selectedIndexInt: newValue,
                                tabViewGeometryProxy: geometryProxy,
                                interstitialOffset: 0
                            )
                        })
                }
            })
        })
    }

    // MARK: Selected Tab Indicator Frame
    private func calculateIndicatorFrame(
        selectedIndexInt: Int?,
        tabViewGeometryProxy: GeometryProxy,
        interstitialOffset: CGFloat
    ) {
        let tabViewMinX: CGFloat = tabViewGeometryProxy.frame(in: .global).minX // Accounts for `TabView` padding
        let tabViewWidth: CGFloat = tabViewGeometryProxy.size.width

        selectedTabIndicatorWidth =
            tabViewWidth / CGFloat(data.count) - // Division is safe, as non-emptiness is checked in `body`
            2 * uiModel.selectedTabIndicatorMarginHorizontal

        selectedTabIndicatorOffset = {
            guard let selectedIndexInt else { return 0 }

            var contentOffset: CGFloat = {
                let accumulatedOffset: CGFloat = tabViewWidth * CGFloat(selectedIndexInt)

                if layoutDirection.isRightToLeft {
                    return accumulatedOffset + interstitialOffset - tabViewMinX // Frame of reference begins on the right side
                } else {
                    return accumulatedOffset - interstitialOffset + tabViewMinX
                }
            }()

            if !uiModel.selectedTabIndicatorBounces {
                contentOffset.clamp(
                    min: 0,
                    max: tabViewWidth * CGFloat(data.count-1)
                )
            }

            return
                contentOffset / CGFloat(data.count) + // Division is safe, as non-emptiness is checked in `body`
                uiModel.selectedTabIndicatorMarginHorizontal
        }()

        if !enablesSelectedTabIndicatorAnimations {
            Task(operation: { enablesSelectedTabIndicatorAnimations = true })
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("*", body: {
    @Previewable @State var selection: Preview_RGBColor = .red

    PreviewContainer(layer: .secondary, content: {
        VStretchedIndicatorStaticPagerTabView(
            selection: $selection,
            data: Preview_RGBColor.allCases,
            tabItemTitle: { $0.title },
            content: { $0.color }
        )
        .padding(.horizontal)
        .frame(height: 150)
    })
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("No Items", body: {
    @Previewable @State var selection: Preview_RGBColor = .red

    PreviewContainer(layer: .secondary, content: {
        VStretchedIndicatorStaticPagerTabView(
            selection: $selection,
            data: [],
            tabItemTitle: { $0.title },
            content: { $0.color }
        )
        .padding(.horizontal)
        .frame(height: 150)
    })
})

#endif

#endif
