//
//  VWrappedIndicatorStaticPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import OSLog
import VCore

// MARK: - V Wrapped-Indicator Static Pager Tab View
/// Container component that switches between child views and is attributed with static pager with wrapped rectangular indicator.
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
///         VWrappedIndicatorStaticPagerTabView(
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
public struct VWrappedIndicatorStaticPagerTabView<Data, ID, CustomTabItemLabel, Content>: View, Sendable
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        Data.Element: Sendable,
        ID: Hashable,
        CustomTabItemLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VWrappedIndicatorStaticPagerTabViewUIModel
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    @State private var tabBarWidth: CGFloat = 0

    @State private var tabBarItemWidths: [Int: CGFloat] = [:]
    @State private var tabBarItemPositions: [Int: CGFloat] = [:]

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
    private let tabItemLabel: VWrappedIndicatorStaticPagerTabViewTabItemLabel<Data.Element, CustomTabItemLabel>
    private let content: (Data.Element) -> Content
    
    // MARK: Properties - Tab Indicator
    private var tabBarCoordinateSpaceName: String { "VWrappedIndicatorStaticPagerTabView.TabBar" }
    
    // Used to disable animations when view appears for the first time
    @State private var tabIndicatorAnimationIsEnabled: Bool = false
    
    // MARK: Properties - Scrolling
    @State private var isBeingScrolled: Bool = false

    // MARK: Initializers - Standard
    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
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

    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VWrappedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
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
    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
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

    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VWrappedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
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
                            let tabItemInternalState: VWrappedIndicatorStaticPagerTabViewTabItemInternalState = tabItemInternalState(baseButtonState, element)

                            tabItemView(
                                tabItemInternalState: tabItemInternalState,
                                element: element
                            )
                        }
                    )
                })
            }
        )
        .coordinateSpace(name: tabBarCoordinateSpaceName)
        .getWidth(assignTo: $tabBarWidth)
    }

    private func tabItemView(
        tabItemInternalState: VWrappedIndicatorStaticPagerTabViewTabItemInternalState,
        element: Data.Element
    ) -> some View {
        ZStack(content: {
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
            .getFrame(in: .named(tabBarCoordinateSpaceName), { [layoutDirection, tabBarWidth, $tabBarItemWidths, $tabBarItemPositions] frame in
                $tabBarItemWidths.wrappedValue[element.hashValue] = frame.size.width

                $tabBarItemPositions.wrappedValue[element.hashValue] = {
                    if layoutDirection.isRightToLeft {
                        // `min` and `max` start from left side of the screen, regardless of layout direction.
                        // So, mapping is required.
                        tabBarWidth - frame.maxX
                    } else {
                        frame.minX
                    }
                }()
            })
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

            .animation(tabIndicatorAnimationIsEnabled ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorWidth)
            .animation(tabIndicatorAnimationIsEnabled ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorOffset)
    }

    private var tabView: some View {
        GeometryReader(content: { geometryProxy in
            // `GeometryProxy` isn't `Sendable`, so data needs to be extracted beforehand
            let tabViewMinX: CGFloat = geometryProxy.frame(in: .global).minX // Accounts for `TabView` padding
            let tabViewWidth: CGFloat = geometryProxy.size.width
            
            Group(content: {
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    ScrollView(.horizontal, content: {
                        LazyHStack( // `scrollPosition(id:)` doesn't work with `HStack`
                            spacing: 0,
                            content: {
                                ForEach(data, id: id, content: { element in
                                    content(element)
                                        .tag(element)
                                        .frame(width: geometryProxy.size.width) // Ensures that small content doesn't break page indicator calculation
                                        .frame(maxHeight: .infinity)
                                        .getFrame(in: .global, { [selection, selectedIndexInt] frame in // `selectedIndexInt` needs to be captured as well
                                            guard element == selection else { return }
                                            
                                            Task(operation: { @MainActor in
                                                calculateIndicatorFrame(
                                                    selectedIndexInt: selectedIndexInt,
                                                    tabViewMinX: tabViewMinX,
                                                    tabViewWidth: tabViewWidth,
                                                    interstitialOffset: frame.minX
                                                )
                                            })
                                        })
                                })
                            }
                        )
                        .scrollTargetLayout()
                    })
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: selectionIDBinding)
                    .applyModifier({
                        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                            $0
                                .onScrollPhaseChange({ (_, newValue) in
                                    isBeingScrolled = newValue == .interacting
                                })
                        } else {
                            $0
                        }
                    })
                    
                    .background(content: { uiModel.tabViewBackgroundColor })
                    
                    .scrollIndicators(.hidden)
                    
                    .scrollDisabled(!uiModel.isTabViewScrollingEnabled)
                    
                } else {
                    TabView(selection: $selection, content: {
                        ForEach(data, id: id, content: { element in
                            content(element)
                                .tag(element)
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures that small content doesn't break page indicator calculation
                                .getFrame(in: .global, { [selection, selectedIndexInt] frame in // `selectedIndexInt` needs to be captured as well
                                    guard element == selection else { return }
                                    
                                    Task(operation: { @MainActor in
                                        calculateIndicatorFrame(
                                            selectedIndexInt: selectedIndexInt,
                                            tabViewMinX: tabViewMinX,
                                            tabViewWidth: tabViewWidth,
                                            interstitialOffset: frame.minX
                                        )
                                    })
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
                                guard !isBeingScrolled else { return }
                                
                                Task(operation: { @MainActor in // `MainActor` is needed to sync with call from `View.getFrame(...)`
                                    calculateIndicatorFrame(
                                        selectedIndexInt: newValue,
                                        tabViewMinX: tabViewMinX,
                                        tabViewWidth: tabViewWidth,
                                        interstitialOffset: 0
                                    )
                                })
                            }
                        )

                } else {
                    $0
                        .onAppear(perform: {
                            Task(operation: { @MainActor in // `MainActor` is needed to sync with call from `View.getFrame(...)`
                                calculateIndicatorFrame(
                                    selectedIndexInt: selectedIndexInt,
                                    tabViewMinX: tabViewMinX,
                                    tabViewWidth: tabViewWidth,
                                    interstitialOffset: 0
                                )
                            })
                        })
                        .onChange(of: selectedIndexInt, perform: { newValue in
                            guard !isBeingScrolled else { return }
                            
                            Task(operation: { @MainActor in // `MainActor` is needed to sync with call from `View.getFrame(...)`
                                calculateIndicatorFrame(
                                    selectedIndexInt: newValue,
                                    tabViewMinX: tabViewMinX,
                                    tabViewWidth: tabViewWidth,
                                    interstitialOffset: 0
                                )
                            })
                        })
                }
            })
        })
    }

    // MARK: Selected Tab Indicator Frame
    private func calculateIndicatorFrame(
        selectedIndexInt: Int?,
        tabViewMinX: CGFloat,
        tabViewWidth: CGFloat,
        interstitialOffset: CGFloat
    ) {
        let contentOffset: CGFloat = {
            guard let selectedIndexInt else { return 0 }

            let accumulatedOffset: CGFloat = tabViewWidth * CGFloat(selectedIndexInt)

            if layoutDirection.isRightToLeft {
                return accumulatedOffset + interstitialOffset - tabViewMinX // Frame of reference begins on the right side
            } else {
                return accumulatedOffset - interstitialOffset + tabViewMinX
            }
        }()

        let tabContentOffsets: [CGFloat] = (0..<data.count)
            .compactMap { CGFloat($0) * tabViewWidth }

        if let value: CGFloat = calculateLinearInterpolation(
            from: data.compactMap { tabBarItemWidths[$0.hashValue] },
            contentOffset: contentOffset,
            tabContentOffsets: tabContentOffsets
        ) {
            selectedTabIndicatorWidth = value
        }

        if let value: CGFloat = calculateLinearInterpolation(
            from: data.compactMap { tabBarItemPositions[$0.hashValue] },
            contentOffset: contentOffset,
            tabContentOffsets: tabContentOffsets
        ) {
            selectedTabIndicatorOffset = value
        }

        if !tabIndicatorAnimationIsEnabled {
            Task(operation: { @MainActor in
                tabIndicatorAnimationIsEnabled = true
            })
        }
    }

    private func calculateLinearInterpolation(
        from dataSource: [CGFloat],
        contentOffset: CGFloat,
        tabContentOffsets: [CGFloat]
    ) -> CGFloat? {
        guard dataSource.count == tabContentOffsets.count else {
            Logger.wrappedIndicatorStaticPagerTabView.warning("Invalid layout in 'VWrappedIndicatorStaticPagerTabView'")
            return nil
        }

        if contentOffset <= tabContentOffsets[0] { // Index is safe, as non-emptiness is checked in `body`
            // Clamping to min
            return dataSource[0]

        } else if
            let index: Int = (1..<dataSource.count)
                .first(where: { contentOffset < tabContentOffsets[$0] })
        {
            return contentOffset
                .linearInterpolation(
                    x1: tabContentOffsets[index-1], y1: dataSource[index-1],
                    x2: tabContentOffsets[index], y2: dataSource[index]
                )

        } else {
            // Clamping to max
            return dataSource[dataSource.count-1]
        }
    }
}

// MARK: - Helpers
extension FloatingPoint {
    fileprivate func linearInterpolation(
        x1: Self, y1: Self,
        x2: Self, y2: Self
    ) -> Self {
        let denominator: Self = y2 - y1
        let numerator: Self = x2 - x1
        let result: Self = y1 + (denominator / numerator) * (self - x1)
        return result
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("*", body: {
    @Previewable @State var selection: Preview_RGBColor = .red

    PreviewContainer(layer: .secondary, content: {
        VWrappedIndicatorStaticPagerTabView(
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
        VWrappedIndicatorStaticPagerTabView(
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
