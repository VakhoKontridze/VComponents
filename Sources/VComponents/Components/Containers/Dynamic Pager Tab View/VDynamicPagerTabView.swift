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
public struct VDynamicPagerTabView<Data, ID, CustomTabItemLabel, Content>: View, Sendable
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        CustomTabItemLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VDynamicPagerTabViewUIModel
    
    private var tabIndicatorContainerHeight: CGFloat {
        max(uiModel.tabIndicatorTrackHeight, uiModel.selectedTabIndicatorHeight)
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

    // MARK: Properties - Data
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let tabItemLabel: VDynamicPagerTabViewTabItemLabel<Data.Element, CustomTabItemLabel>
    private let content: (Data.Element) -> Content

    // MARK: Properties - Tab Indicator
    @Namespace private var selectedTabIndicatorNamespace: Namespace.ID
    private var selectedTabIndicatorNamespaceName: String { "VDynamicPagerTabView.SelectedTabIndicator" }
    
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
        where CustomTabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
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
            CustomTabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VDynamicPagerTabView` with selection, data, id, custom tab item label, and content.
    public init(
        uiModel: VDynamicPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel customTabItemLabel: @escaping (VDynamicPagerTabViewTabItemInternalState, Data.Element) -> CustomTabItemLabel,
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
        tabBarAndTabIndicatorStripView
            .background(content: { uiModel.headerBackgroundColor })
    }

    private var tabBarAndTabIndicatorStripView: some View {
        ZStack(alignment: .bottom, content: {
            tabIndicatorTrackView

            ScrollViewReader(content: { scrollViewProxy in
                ScrollView(.horizontal, content: {
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
                })
                .scrollIndicators(.hidden)
                
                .scrollDisabled(!uiModel.isTabBarScrollingEnabled)
                
                .onAppear(perform: { positionSelectedTabIndicatorInitially(scrollViewProxy: scrollViewProxy) })
                .onChange(of: selection, perform: { positionSelectedTabIndicator($0, scrollViewProxy: scrollViewProxy) })
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
                    .applyIfLet(uiModel.tabItemTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

            case .custom(let custom):
                custom(tabItemInternalState, element)
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
                .leading, 
                uiModel.tabSelectionIndicatorWidthType.padsSelectionIndicator ?
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

    @ViewBuilder
    private var tabView: some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            GeometryReader(content: { geometryProxy in
                ScrollView(.horizontal, content: {
                    LazyHStack( // `scrollPosition(id:)` doesn't work with `HStack`
                        spacing: 0,
                        content: {
                            ForEach(data, id: id, content: { element in
                                content(element)
                                    .tag(element)
                                    .frame(width: geometryProxy.size.width) // Ensures that small content doesn't break page indicator calculation
                                    .frame(maxHeight: .infinity)
                            })
                        }
                    )
                    .scrollTargetLayout()
                })
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: selectionIDBinding)
                
                .background(content: { uiModel.tabViewBackgroundColor })
                
                .scrollIndicators(.hidden)
                
                .scrollDisabled(!uiModel.isTabViewScrollingEnabled)
            })
            
        } else {
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
            uiModel.selectedTabIndicatorAnimation,
            { _positionSelectedTabIndicator(newElement, scrollViewProxy: scrollViewProxy) }
        )
    }

    private func _positionSelectedTabIndicator(
        _ newElement: Data.Element,
        scrollViewProxy: ScrollViewProxy
    ) {
        scrollViewProxy.scrollTo( // TODO: Wait for iOS issue to be resolved for RTL layout, when using few items
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
    @Previewable @State var selection: Preview_Weekday = .thursday

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
})

#Preview("Few Items", body: {
    @Previewable @State var selection: Preview_Weekday = .monday

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
})

#Preview("No Items", body: {
    @Previewable @State var selection: Preview_Weekday = .thursday

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
})

#endif

#endif
