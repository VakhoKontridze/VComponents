//
//  VDynamicPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Static Pager Tab View (Stretched Indicator)
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
///             case 0: return Color.red
///             case 1: return Color.green
///             case 2: return Color.blue
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
///         .padding()
///     }
///
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `PageTabViewStyle` support
@available(tvOS 14.0, *)@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS 8.0, *)@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
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

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: Properties - State - Tab Item
    private func tabItemInternalState(_ baseButtonState: SwiftUIBaseButtonState) -> VDynamicPagerTabViewTabItemInternalState {
        .init(
            isEnabled: isEnabled,
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

    private var tabIndicatorStripHeight: CGFloat {
        max(uiModel.tabIndicatorTrackHeight, uiModel.selectedTabIndicatorHeight)
    }

    @State private var didPositionSelectionIndicatorInitially: Bool = false

    // MARK: Initializers
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
        VStack(
            spacing: uiModel.tabBarAndTabViewSpacing,
            content: {
                header
                tabView
            }
        )
    }

    private var header: some View {
        tabBarAndTabIndicatorStrip
            .background(uiModel.headerBackgroundColor)
    }

    private var tabBarAndTabIndicatorStrip: some View {
        ScrollViewReader(content: { proxy in
            ScrollView(
                .horizontal,
                showsIndicators: false,
                content: {
                    HStack(
                        alignment: uiModel.tabBarAlignment,
                        spacing: 0,
                        content: {
                            ForEach(data, id: id, content: { element in
                                ZStack(alignment: .bottom, content: {
                                    SwiftUIBaseButton(
                                        action: { selection = element },
                                        label: { baseButtonState in
                                            let tabItemInternalState: VDynamicPagerTabViewTabItemInternalState = tabItemInternalState(baseButtonState)

                                            tabItem(
                                                tabItemInternalState: tabItemInternalState,
                                                element: element
                                            )
                                        }
                                    )

                                    tabIndicatorStripSection(element)
                                })
                                .padding(.bottom, tabIndicatorStripHeight) // Needed for `VStack`-like layout in `ZStack`
                                .id(element)
                            })
                        }
                    )
                }
            )
            .onChange(of: selection, perform: { positionSelectedTabIndicator($0, in: proxy) })
            .onAppear(perform: { positionSelectedTabIndicatorInitially(in: proxy) })
        })
    }

    private func tabIndicatorStripSection(
        _ element: Data.Element
    ) -> some View {
        ZStack(content: {
            tabIndicatorTrackSection
            selectedTabIndicator(element)
        })
        .frame(
            height: tabIndicatorStripHeight, // Needed for `VStack`-like layout in `ZStack`
            alignment: Alignment(
                horizontal: .center,
                vertical: uiModel.tabIndicatorStripAlignment
            )
        )
        .offset(y: tabIndicatorStripHeight) // Needed for `VStack`-like layout in `ZStack`
    }

    private func tabItem(
        tabItemInternalState: VDynamicPagerTabViewTabItemInternalState,
        element: Data.Element
    ) -> some View {
        Group(content: {
            switch tabItemLabel {
            case .title(let title):
                Text(title(element))
                    .lineLimit(1)
                    .minimumScaleFactor(uiModel.tabItemTextMinimumScaleFactor)
                    .foregroundColor(uiModel.tabItemTextColors.value(for: tabItemInternalState))
                    .font(uiModel.tabItemTextFont)

            case .label(let label):
                label(tabItemInternalState, element)
            }
        })
        .padding(uiModel.tabItemMargins)
        .padding(.leading, data.firstIndex(of: element) == data.startIndex ? uiModel.tabBarMarginHorizontal : 0)
        .padding(.trailing, data.lastIndex(of: element) == data.index(before: data.endIndex) ? uiModel.tabBarMarginHorizontal : 0)
        .fixedSize(horizontal: true, vertical: false)
        .contentShape(Rectangle())
    }

    private var tabIndicatorTrackSection: some View {
        Rectangle()
            .frame(height: uiModel.tabIndicatorTrackHeight)
            .foregroundColor(uiModel.tabIndicatorTrackColor)
    }

    private func selectedTabIndicator(
        _ element: Data.Element
    ) -> some View {
        Group(content: {
            if selection == element {
                RoundedRectangle(cornerRadius: uiModel.selectedTabIndicatorCornerRadius)
                    .matchedGeometryEffect(id: selectedTabIndicatorNamespaceName, in: selectedTabIndicatorNamespace)
            }
        })
        .frame(height: uiModel.selectedTabIndicatorHeight)
        .foregroundColor(uiModel.selectedTabIndicatorColor)
        .animation(uiModel.selectedTabIndicatorAnimation, value: selection) // Needed alongside `withAnimation(_:_:)`
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
        .background(uiModel.tabViewBackgroundColor)
    }

    // MARK: Selected Tab Indicator Frame
    private func positionSelectedTabIndicatorInitially(
        in proxy: ScrollViewProxy
    ) {
        guard !didPositionSelectionIndicatorInitially else { return }
        didPositionSelectionIndicatorInitially = true

        proxy.scrollTo(
            selection,
            anchor: uiModel.selectedTabIndicatorScrollAnchor
        )
    }

    private func positionSelectedTabIndicator(
        _ newElement: Data.Element,
        in proxy: ScrollViewProxy
    ) {
        withAnimation( // Needed alongside `animation(_:value:)`
            uiModel.selectedTabIndicatorAnimation,
            {
                proxy.scrollTo(
                    newElement,
                    anchor: uiModel.selectedTabIndicatorScrollAnchor
                )
            }
        )
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VDynamicPagerTabView_Previews: PreviewProvider { // Preview may have difficulties with `ScrollViewReader`
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            CustomTabBarPreview().previewDisplayName("Custom Tab Bar")
            CustomTabIndicatorPreview().previewDisplayName("Custom Tab Indicator")
        })
        .colorScheme(colorScheme)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
    }

    // Data
    private enum WeekDay: Int, Hashable, Identifiable, CaseIterable {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday

        var id: Int { rawValue }

        var tabItemTitle: String { .init(describing: self).capitalized.pseudoRTL(languageDirection) }
        var color: Color {
            switch rawValue.remainderReportingOverflow(dividingBy: 3).0 {
            case 0: return Color.red
            case 1: return Color.green
            case 2: return Color.blue
            default: fatalError()
            }
        }
    }
    private static var selection: WeekDay { .thursday }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: WeekDay = VDynamicPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VDynamicPagerTabView(
                    selection: $selection,
                    data: WeekDay.allCases,
                    tabItemTitle: { $0.tabItemTitle },
                    content: { $0.color }
                )
                .padding()
            })
        }
    }

    private struct CustomTabBarPreview: View {
        @State private var selection: WeekDay = VDynamicPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VDynamicPagerTabView(
                    uiModel: {
                        var uiModel: VDynamicPagerTabViewUIModel = .init()
                        uiModel.headerBackgroundColor = ColorBook.layerGray.opacity(0.5)
                        uiModel.tabItemMargins.top *= 1.5
                        return uiModel
                    }(),
                    selection: $selection,
                    data: WeekDay.allCases,
                    tabItemTitle: { $0.tabItemTitle },
                    content: { $0.color }
                )
                .applyModifier({
#if canImport(UIKit)
                    $0.cornerRadius(20, uiCorners: .topCorners)
#else
                    $0
#endif
                })
                .padding()
            })
        }
    }

    private struct CustomTabIndicatorPreview: View {
        @State private var selection: WeekDay = VDynamicPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VDynamicPagerTabView(
                    uiModel: {
                        var uiModel: VDynamicPagerTabViewUIModel = .init()
                        uiModel.tabIndicatorTrackHeight = 1
                        uiModel.tabIndicatorTrackColor = ColorBook.layerGray
                        uiModel.selectedTabIndicatorHeight = 3
                        return uiModel
                    }(),
                    selection: $selection,
                    data: WeekDay.allCases,
                    tabItemTitle: { $0.tabItemTitle },
                    content: {
                        Text($0.tabItemTitle)
                            .foregroundColor($0.color)
                    }
                )
                .padding()
            })
        }
    }
}
