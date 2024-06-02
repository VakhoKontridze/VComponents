//
//  VDynamicPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Dynamic Pager Tab View
/// Container component that switches between child views and is attributed with dynamic pager with rectangular indicator.
///
/// Best suited for `5`+ items.
///
///     private enum WeekDay: Int, Hashable, Identifiable, CaseIterable {
///         case monday, tuesday, wednesday, thursday, friday, saturday, sunday
///
///         var id: Int { rawValue }
///
///         var tabItemTitle: String { .init(describing: self).capitalized }
///         var color: Color {
///             switch rawValue.remainderReportingOverflow(dividingBy: 3).0 {
///             case 0: Color.red
///             case 1: Color.green
///             case 2: Color.blue
///             default: fatalError()
///             }
///         }
///     }
///
///     @State private var selection: WeekDay = .thursday
///
///     var body: some View {
///         VDynamicPagerTabView(
///             selection: $selection,
///             data: WeekDay.allCases,
///             tabItemTitle: { $0.tabItemTitle },
///             content: { $0.color }
///         )
///     }
///
@available(macOS, unavailable) // No `PageTabViewStyle`
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VDynamicPagerTabView<Data, ID, TabItemLabel, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        TabItemLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VDynamicPagerTabViewUIModel
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection

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

    // MARK: Properties - Data
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let tabItemLabel: VDynamicPagerTabViewTabItemLabel<Data.Element, TabItemLabel>
    private let content: (Data.Element) -> Content

    // MARK: Properties - Frame
    @Namespace private var selectedTabIndicatorNamespace: Namespace.ID
    private var selectedTabIndicatorNamespaceName: String { "VDynamicPagerTabView.SelectedTabIndicator" }

    private var tabIndicatorContainerHeight: CGFloat {
        max(uiModel.tabIndicatorTrackHeight, uiModel.selectedTabIndicatorHeight)
    }

    @State private var didPositionSelectionIndicatorInitially: Bool = false

    // MARK: Initializers - Standard
    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        tabItemTitle: @escaping (Data.Element) -> String,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where TabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item label, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> TabItemLabel,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .label(label: tabItemLabel)
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        tabItemTitle: @escaping (Data.Element) -> String,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            TabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item label, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> TabItemLabel,
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
        self.tabItemLabel = .label(label: tabItemLabel)
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
        tabBarAndTabIndicatorStripView
            .background(content: { uiModel.headerBackgroundColor })
    }

    private var tabBarAndTabIndicatorStripView: some View {
        ZStack(alignment: .bottom, content: {
            tabIndicatorTrackView

            ScrollViewReader(content: { proxy in
                ScrollView(
                    .horizontal,
                    showsIndicators: false,
                    content: {
                        HStack(
                            alignment: uiModel.tabBarAlignment,
                            spacing: uiModel.tabItemSpacing,
                            content: {
                                ForEach(data, id: id, content: { element in
                                    ZStack(alignment: .bottom, content: {
                                        SwiftUIBaseButton(
                                            action: { selection = element },
                                            label: { baseButtonState in
                                                let tabItemInternalState: VDynamicPagerTabViewTabItemInternalState = tabItemInternalState(baseButtonState, element)

                                                tabItemView(
                                                    tabItemInternalState: tabItemInternalState,
                                                    element: element
                                                )
                                            }
                                        )

                                        selectedTabIndicatorViewSlice(element)
                                    })
                                    .padding(.bottom, tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
                                    .id(element)
                                })
                            }
                        )
                    }
                )
                .onAppear(perform: { positionSelectedTabIndicatorInitially(in: proxy) })
                .onChange(of: selection, perform: { positionSelectedTabIndicator($0, in: proxy) })
            })
        })
    }

    private func tabItemView(
        tabItemInternalState: VDynamicPagerTabViewTabItemInternalState,
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

            case .label(let label):
                label(tabItemInternalState, element)
            }
        })
        .fixedSize(horizontal: true, vertical: false)
        .padding(uiModel.tabItemMargins)
        .padding(.leading, isFirstElement(element) ? uiModel.tabBarMarginHorizontal : 0)
        .padding(.trailing, isLastElement(element) ? uiModel.tabBarMarginHorizontal : 0)
        .contentShape(.rect)
    }

    private var tabIndicatorTrackView: some View {
        ZStack(content: {
            Rectangle()
                .frame(height: uiModel.tabIndicatorTrackHeight)
                .foregroundStyle(uiModel.tabIndicatorTrackColor)
        })
        .frame(
            height: tabIndicatorContainerHeight,
            alignment: Alignment(
                horizontal: .center,
                vertical: uiModel.tabIndicatorStripAlignment
            )
        )
    }

    private func selectedTabIndicatorViewSlice(
        _ element: Data.Element
    ) -> some View {
        ZStack(content: {
            ZStack(content: {
                if selection == element {
                    RoundedRectangle(cornerRadius: uiModel.selectedTabIndicatorCornerRadius)
                        .matchedGeometryEffect(id: selectedTabIndicatorNamespaceName, in: selectedTabIndicatorNamespace)
                }
            })
            .frame(height: uiModel.selectedTabIndicatorHeight)
            .padding(
                .leading, uiModel.tabSelectionIndicatorWidthType.padsSelectionIndicator ?
                uiModel.tabItemMargins.leading + (isFirstElement(element) ? uiModel.tabBarMarginHorizontal : 0) :
                0
            )
            .padding(
                .trailing,
                uiModel.tabSelectionIndicatorWidthType.padsSelectionIndicator ?
                uiModel.tabItemMargins.trailing + (isLastElement(element) ? uiModel.tabBarMarginHorizontal : 0) :
                0
            )
            .foregroundStyle(uiModel.selectedTabIndicatorColor)
            .animation(uiModel.selectedTabIndicatorAnimation, value: selection) // Needed alongside `withAnimation(_:completionCriteria:_:completion:)`
        })
        .frame(height: tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
        .offset(y: tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
    }

    private var tabView: some View {
        TabView(selection: $selection, content: {
            ForEach(data, id: id, content: { element in
                content(element)
                    .tag(element)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures that small content doesn't break page indicator calculation
            })
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(content: { uiModel.tabViewBackgroundColor })
    }

    // MARK: Selected Tab Indicator Frame
    private func positionSelectedTabIndicatorInitially(
        in proxy: ScrollViewProxy
    ) {
        guard !didPositionSelectionIndicatorInitially else { return }
        didPositionSelectionIndicatorInitially = true

        _positionSelectedTabIndicator(selection, in: proxy)
    }

    private func positionSelectedTabIndicator(
        _ newElement: Data.Element,
        in proxy: ScrollViewProxy
    ) {
        withAnimation( // Needed alongside `animation(_:value:)` to maintain proper `ScrollView` offset
            uiModel.selectedTabIndicatorAnimation,
            { _positionSelectedTabIndicator(newElement, in: proxy) }
        )
    }

    private func _positionSelectedTabIndicator(
        _ newElement: Data.Element,
        in proxy: ScrollViewProxy
    ) {
        proxy.scrollTo( // TODO: Wait for iOS issue to be resolved for RTL layout, when using few items
            newElement,
            anchor: uiModel.selectedTabIndicatorScrollAnchor
        )
    }

    // MARK: Helpers
    private func isFirstElement(_ element: Data.Element) -> Bool {
        data.firstIndex(of: element) == data.startIndex
    }

    private func isLastElement(_ element: Data.Element) -> Bool {
        data.lastIndex(of: element) == data.index(before: data.endIndex)
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("Many Items", body: {
    struct ContentView: View {
        @State private var selection: Preview_Weekday = .thursday

        var body: some View {
            PreviewContainer(layer: .secondary, content: {
                ForEach(
                    VDynamicPagerTabViewUIModel.TabSelectionIndicatorWidthType.allCases,
                    id: \.self,
                    content: { widthType in
                        VDynamicPagerTabView(
                            uiModel: {
                                var uiModel: VDynamicPagerTabViewUIModel = .init()
                                uiModel.tabSelectionIndicatorWidthType = widthType
                                return uiModel
                            }(),
                            selection: $selection,
                            data: Preview_Weekday.allCases,
                            tabItemTitle: { $0.title },
                            content: { $0.color }
                        )
                        .padding(.horizontal)
                        .frame(height: 150)
                    }
                )
            })
        }
    }

    return ContentView()
})

#Preview("Few Items", body: {
    struct ContentView: View {
        @State private var selection: Preview_Weekday = .monday

        var body: some View {
            PreviewContainer(layer: .secondary, content: {
                ForEach(
                    VDynamicPagerTabViewUIModel.TabSelectionIndicatorWidthType.allCases,
                    id: \.self,
                    content: { widthType in
                        VDynamicPagerTabView(
                            uiModel: {
                                var uiModel: VDynamicPagerTabViewUIModel = .init()
                                uiModel.tabSelectionIndicatorWidthType = widthType
                                return uiModel
                            }(),
                            selection: $selection,
                            data: Preview_Weekday.allCases.prefix(3),
                            tabItemTitle: { $0.title },
                            content: { $0.color }
                        )
                        .padding(.horizontal)
                        .frame(height: 150)
                    }
                )
            })
        }
    }

    return ContentView()
})

#Preview("No Items", body: {
    struct ContentView: View {
        @State private var selection: Preview_Weekday = .thursday

        var body: some View {
            PreviewContainer(layer: .secondary, content: {
                ForEach(
                    VDynamicPagerTabViewUIModel.TabSelectionIndicatorWidthType.allCases,
                    id: \.self,
                    content: { widthType in
                        VDynamicPagerTabView(
                            uiModel: {
                                var uiModel: VDynamicPagerTabViewUIModel = .init()
                                uiModel.tabSelectionIndicatorWidthType = widthType
                                return uiModel
                            }(),
                            selection: $selection,
                            data: [],
                            tabItemTitle: { $0.title },
                            content: { $0.color }
                        )
                        .padding(.horizontal)
                        .frame(height: 150)
                    }
                )
            })
        }
    }

    return ContentView()
})

#endif

#endif
