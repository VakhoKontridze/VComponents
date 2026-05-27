//
//  VDynamicPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

public import SwiftUI
public import VCore

/// Container component that switches between child views and is attributed with dynamic pager with rectangular indicator.
///
/// Best suited for `5`+ items.
///
///     nonisolated private enum WeekDay: Int, Hashable, Identifiable, CaseIterable {
///         case monday, tuesday, wednesday, thursday, friday, saturday, sunday
///
///         var id: Int { rawValue }
///
///         var title: String { .init(describing: self).capitalized }
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
///     @State private var selection: WeekDay = .thursday
///
///     var body: some View {
///         VDynamicPagerTabView(
///             selection: $selection,
///             data: WeekDay.allCases,
///             tabItemTitle: { $0.title },
///             content: { $0.color }
///         )
///     }
///
@available(macOS, unavailable) // No `PageTabViewStyle`
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VDynamicPagerTabView<Data, ID, CustomTabItemLabel, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        CustomTabItemLabel: View,
        Content: View
{
    // MARK: Properties - Appearance
    private let appearance: VDynamicPagerTabViewAppearance
    
    private var tabIndicatorContainerHeight: CGFloat {
        max(appearance.tabIndicatorTrackHeight, appearance.selectedTabIndicatorHeight)
    }

    // MARK: Properties - State - Global
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
    
    private var selectionIDBinding: Binding<ID?> {
        .init(
            get: {
                selection[keyPath: id]
            },
            set: { newValue in
                guard let element: Data.Element = data.first(where: { $0[keyPath: id] == newValue }) else { return }
                selection = element
            }
        )
    }

    // MARK: Properties - Parameters
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    
    // MARK: Properties - Tab Item
    private let tabItemLabel: VDynamicPagerTabViewTabItemLabel<Data.Element, CustomTabItemLabel>
    
    // MARK: Properties - Tab Indicator
    @Namespace private var selectedTabIndicatorNamespace: Namespace.ID
    private var selectedTabIndicatorNamespaceName: String { "VDynamicPagerTabView.SelectedTabIndicator" }
    
    @State private var didPositionSelectionIndicatorInitially: Bool = false
    
    // MARK: Properties - Content
    private let content: (Data.Element) -> Content

    // MARK: Initializers - Standard
    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        appearance: VDynamicPagerTabViewAppearance = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        tabItemTitle: @escaping (Data.Element) -> String,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where CustomTabItemLabel == Never
    {
        self.appearance = appearance
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        appearance: VDynamicPagerTabViewAppearance = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.appearance = appearance
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .custom(builder: customTabItemLabel)
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VDynamicPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        appearance: VDynamicPagerTabViewAppearance = .init(),
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
        self.appearance = appearance
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        appearance: VDynamicPagerTabViewAppearance = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.appearance = appearance
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .custom(builder: customTabItemLabel)
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        if data.isEmpty {
            appearance.tabViewBackgroundColor

        } else {
            VStack(spacing: appearance.tabBarAndTabViewSpacing) {
                tabBar
                tabView
            }
        }
    }

    private var tabBar: some View {
        _tabBarAndTabIndicatorStripView
            .background(appearance.tabBarBackgroundColor)
    }

    private var _tabBarAndTabIndicatorStripView: some View {
        ZStack(alignment: .bottom) {
            tabIndicatorTrackView

            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    HStack(
                        alignment: appearance.tabBarAlignment,
                        spacing: appearance.tabItemSpacing
                    ) {
                        ForEach(data, id: id) { element in
                            ZStack(alignment: .bottom) {
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
                            }
                            .padding(.bottom, tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
                            .id(element)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                .scrollDisabled(!appearance.isTabBarScrollingEnabled)
                
                .onAppear { positionSelectedTabIndicatorInitially(scrollViewProxy: scrollViewProxy) }
                .onChange(of: selection) { positionSelectedTabIndicator($1, scrollViewProxy: scrollViewProxy) }
            }
        }
    }

    private func tabItemView(
        tabItemInternalState: VDynamicPagerTabViewTabItemInternalState,
        element: Data.Element
    ) -> some View {
        Group {
            switch tabItemLabel {
            case .title(let title):
                Text(title(element))
                    .textConfiguration(appearance.tabItemTextConfiguration, state: tabItemInternalState)

            case .custom(let builder):
                builder(tabItemInternalState, element)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding(appearance.tabItemMargins)
        .padding(.leading, isFirstElement(element) ? appearance.tabBarMarginHorizontal : 0)
        .padding(.trailing, isLastElement(element) ? appearance.tabBarMarginHorizontal : 0)
        .contentShape(.rect)
    }

    private var tabIndicatorTrackView: some View {
        ZStack {
            Rectangle()
                .frame(height: appearance.tabIndicatorTrackHeight)
                .foregroundStyle(appearance.tabIndicatorTrackColor)
        }
        .frame(
            height: tabIndicatorContainerHeight,
            alignment: Alignment(
                horizontal: .center,
                vertical: appearance.tabIndicatorStripAlignment
            )
        )
    }

    private func selectedTabIndicatorViewSlice(
        _ element: Data.Element
    ) -> some View {
        ZStack {
            ZStack {
                if selection == element {
                    RoundedRectangle(cornerRadius: appearance.selectedTabIndicatorCornerRadius)
                        .matchedGeometryEffect(id: selectedTabIndicatorNamespaceName, in: selectedTabIndicatorNamespace)
                }
            }
            .frame(height: appearance.selectedTabIndicatorHeight)
            .padding(
                .leading, 
                appearance.tabSelectionIndicatorWidthType.padsSelectionIndicator ?
                appearance.tabItemMargins.leading + (isFirstElement(element) ? appearance.tabBarMarginHorizontal : 0) :
                0
            )
            .padding(
                .trailing,
                appearance.tabSelectionIndicatorWidthType.padsSelectionIndicator ?
                appearance.tabItemMargins.trailing + (isLastElement(element) ? appearance.tabBarMarginHorizontal : 0) :
                0
            )
            .foregroundStyle(appearance.selectedTabIndicatorColor)
            .animation(appearance.selectedTabIndicatorAnimation, value: selection) // Needed alongside `withAnimation(_:completionCriteria:_:completion:)`
        }
        .frame(height: tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
        .offset(y: tabIndicatorContainerHeight) // Needed for `VStack`-like layout in `ZStack`
    }

    private var tabView: some View {
        GeometryReader { geometryProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) { // `scrollPosition(id:)` doesn't work with `HStack`
                    ForEach(data, id: id) { element in
                        ZStack {
                            content(element)
                        }
                        .tag(element)
                        .frame(width: geometryProxy.size.width) // Ensures that small content doesn't break page indicator calculation
                        .frame(maxHeight: .infinity)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: selectionIDBinding)
            
            .background(appearance.tabViewBackgroundColor)
            
            .scrollIndicators(.hidden)
            
            .scrollDisabled(!appearance.isTabViewScrollingEnabled)
        }
    }

    // MARK: Selected Tab Indicator Frame
    private func positionSelectedTabIndicatorInitially(
        scrollViewProxy: ScrollViewProxy
    ) {
        guard !didPositionSelectionIndicatorInitially else { return }
        didPositionSelectionIndicatorInitially = true

        _positionSelectedTabIndicator(selection, scrollViewProxy: scrollViewProxy)
    }

    private func positionSelectedTabIndicator(
        _ newElement: Data.Element,
        scrollViewProxy: ScrollViewProxy
    ) {
        withAnimation( // Needed alongside `animation(_:value:)` to maintain proper `ScrollView` offset
            appearance.selectedTabIndicatorAnimation,
            { _positionSelectedTabIndicator(newElement, scrollViewProxy: scrollViewProxy) }
        )
    }

    private func _positionSelectedTabIndicator(
        _ newElement: Data.Element,
        scrollViewProxy: ScrollViewProxy
    ) {
        scrollViewProxy.scrollTo(
            newElement,
            anchor: appearance.selectedTabIndicatorScrollAnchor
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

#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Many Items") {
    @Previewable @State var selection: Weekday = .thursday

    PreviewContainer(layer: .secondary) {
        ForEach(
            VDynamicPagerTabViewAppearance.TabSelectionIndicatorWidthType.allCases,
            id: \.self
        ) { widthType in
            VDynamicPagerTabView(
                appearance: {
                    var appearance: VDynamicPagerTabViewAppearance = .init()
                    appearance.tabSelectionIndicatorWidthType = widthType
                    return appearance
                }(),
                selection: $selection,
                data: Weekday.allCases,
                tabItemTitle: { $0.title },
                content: { $0.color }
            )
            .padding(.horizontal)
            .frame(height: 150)
        }
    }
}

#Preview("Few Items") {
    @Previewable @State var selection: Weekday = .monday

    PreviewContainer(layer: .secondary) {
        ForEach(
            VDynamicPagerTabViewAppearance.TabSelectionIndicatorWidthType.allCases,
            id: \.self
        ) { widthType in
            VDynamicPagerTabView(
                appearance: {
                    var appearance: VDynamicPagerTabViewAppearance = .init()
                    appearance.tabSelectionIndicatorWidthType = widthType
                    return appearance
                }(),
                selection: $selection,
                data: Weekday.allCases.prefix(3),
                tabItemTitle: { $0.title },
                content: { $0.color }
            )
            .padding(.horizontal)
            .frame(height: 150)
        }
    }
}

#Preview("No Items") {
    @Previewable @State var selection: Weekday = .thursday

    PreviewContainer(layer: .secondary) {
        ForEach(
            VDynamicPagerTabViewAppearance.TabSelectionIndicatorWidthType.allCases,
            id: \.self
        ) { widthType in
            VDynamicPagerTabView(
                appearance: {
                    var appearance: VDynamicPagerTabViewAppearance = .init()
                    appearance.tabSelectionIndicatorWidthType = widthType
                    return appearance
                }(),
                selection: $selection,
                data: [],
                tabItemTitle: { $0.title },
                content: { $0.color }
            )
            .padding(.horizontal)
            .frame(height: 150)
        }
    }
}

#endif

#endif
