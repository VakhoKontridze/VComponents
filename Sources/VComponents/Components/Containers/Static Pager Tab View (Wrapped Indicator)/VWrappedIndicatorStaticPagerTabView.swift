//
//  VWrappedIndicatorStaticPagerTabView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
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
///         var tabItemTitle: String { .init(describing: self).capitalized }
///         var color: Color {
///             switch self {
///             case .red: return Color.red
///             case .green: return Color.green
///             case .blue: return Color.blue
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
///             tabItemTitle: { $0.tabItemTitle },
///             content: { $0.color }
///         )
///         .padding()
///     }
///
@available(macOS, unavailable) // No `PageTabViewStyle` support
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VWrappedIndicatorStaticPagerTabView<Data, ID, TabItemLabel, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        TabItemLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VWrappedIndicatorStaticPagerTabViewUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: Properties - State - Tab Item
    private func tabItemInternalState(_ baseButtonState: SwiftUIBaseButtonState) -> VWrappedIndicatorStaticPagerTabViewTabItemInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Selection
    @Binding private var selection: Data.Element
    private var selectedIndex: Data.Index { data.firstIndex(of: selection)! } // Force-unwrap
    private var selectedIndexInt: Int { data.distance(from: data.startIndex, to: selectedIndex) }

    // MARK: Properties - Data
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let tabItemLabel: VWrappedIndicatorStaticPagerTabViewTabItemLabel<Data.Element, TabItemLabel>
    private let content: (Data.Element) -> Content

    // MARK: Properties - Frame
    private var tabBarCoordinateSpaceName: String { "VWrappedIndicatorStaticPagerTabView.TabBar" }
    @State private var tabBarItemWidths: [Int: CGFloat] = [:]
    @State private var tabBarItemPositions: [Int: CGFloat] = [:]

    @State private var selectedTabIndicatorWidth: CGFloat = 0
    @State private var selectedTabIndicatorOffset: CGFloat = 0

    // MARK: Properties - Flags
    // Prevents animation when view appears for the first time
    @State private var enablesSelectedTabIndicatorAnimations: Bool = false

    // MARK: Initializers
    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, tab item title, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
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

    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, tab item label, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder tabItemLabel: @escaping (VWrappedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> TabItemLabel,
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
            TabItemLabel == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.data = data
        self.id = \.id
        self.tabItemLabel = .title(title: tabItemTitle)
        self.content = content
    }

    /// Initializes `VWrappedIndicatorStaticPagerTabView` with selection, data, id, tab item label, and content.
    public init(
        uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init(),
        selection: Binding<Data.Element>,
        data: Data,
        @ViewBuilder tabItemLabel: @escaping (VWrappedIndicatorStaticPagerTabViewTabItemInternalState, Data.Element) -> TabItemLabel,
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
        VStack(spacing: 0, content: {
            tabBar
            tabIndicatorStrip
        })
        .background(content: { uiModel.headerBackgroundColor })

        .clipped() // Prevents bouncing tab indicator from overflowing
        .drawingGroup() // Prevents clipped tab indicator from disappearing
    }

    private var tabBar: some View {
        HStack(
            alignment: uiModel.tabBarAlignment,
            spacing: 0,
            content: {
                ForEach(data, id: id, content: { element in
                    SwiftUIBaseButton(
                        action: { selection = element },
                        label: { baseButtonState in
                            let tabItemInternalState: VWrappedIndicatorStaticPagerTabViewTabItemInternalState = tabItemInternalState(baseButtonState)

                            tabItem(
                                tabItemInternalState: tabItemInternalState,
                                element: element
                            )
                        }
                    )
                })
            }
        )
        .coordinateSpace(name: tabBarCoordinateSpaceName)
    }

    private func tabItem(
        tabItemInternalState: VWrappedIndicatorStaticPagerTabViewTabItemInternalState,
        element: Data.Element
    ) -> some View {
        VStack(content: { // Used as container
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
            .getFrame(in: .named(tabBarCoordinateSpaceName), { frame in
                tabBarItemWidths[element.hashValue] = frame.size.width
                tabBarItemPositions[element.hashValue] = frame.minX
            })
        })
        .padding(uiModel.tabItemMargins)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    private var tabIndicatorStrip: some View {
        ZStack(
            alignment: Alignment(
                horizontal: .leading,
                vertical: uiModel.tabIndicatorStripAlignment
            ),
            content: {
                tabIndicatorTrack
                selectedTabIndicator
            }
        )
    }

    private var tabIndicatorTrack: some View {
        Rectangle()
            .frame(height: uiModel.tabIndicatorTrackHeight)
            .foregroundColor(uiModel.tabIndicatorTrackColor)
    }

    private var selectedTabIndicator: some View {
        RoundedRectangle(cornerRadius: uiModel.selectedTabIndicatorCornerRadius)
            .frame(width: selectedTabIndicatorWidth)
            .frame(height: uiModel.selectedTabIndicatorHeight)

            .offset(x: selectedTabIndicatorOffset)

            .foregroundColor(uiModel.selectedTabIndicatorColor)

            .animation(enablesSelectedTabIndicatorAnimations ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorWidth)
            .animation(enablesSelectedTabIndicatorAnimations ? uiModel.selectedTabIndicatorAnimation : nil, value: selectedTabIndicatorOffset)
    }

    private var tabView: some View {
        GeometryReader(content: { tabViewProxy in
            TabView(selection: $selection, content: {
                ForEach(data, id: id, content: { element in
                    content(element)
                        .tag(element)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures that small content doesn't break page indicator calculation
                        .getFrame(in: .global, { frame in
                            guard element == selection else { return }

                            calculateIndicatorFrame(
                                frame: frame,
                                tabViewProxy: tabViewProxy
                            )
                        })
                })
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(content: { uiModel.tabViewBackgroundColor })
        })
    }

    // MARK: Selected Tab Indicator Frame
    private func calculateIndicatorFrame(
        frame: CGRect,
        tabViewProxy: GeometryProxy
    ) {
        let contentOffset: CGFloat =
            frame.size.width * CGFloat(selectedIndexInt) -
            frame.minX +
            tabViewProxy.frame(in: .global).minX // Accounts for `TabView` padding
        
        let tabContentOffsets: [CGFloat] = (0..<data.count)
            .compactMap { CGFloat($0) * tabViewProxy.size.width }

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

        if !enablesSelectedTabIndicatorAnimations {
            DispatchQueue.main.async(execute: { enablesSelectedTabIndicatorAnimations = true })
        }
    }

    private func calculateLinearInterpolation(
        from dataSource: [CGFloat],
        contentOffset: CGFloat,
        tabContentOffsets: [CGFloat]
    ) -> CGFloat? {
        guard dataSource.count == tabContentOffsets.count else {
            VCoreLogWarning("Invalid layout in 'VWrappedIndicatorStaticPagerTabView'", module: "VComponents")
            return nil
        }

        if contentOffset <= tabContentOffsets[0] {
            // Clamping to min
            return dataSource[0]

        } else if
            let index: Int = (1..<dataSource.count)
                .first(where: { contentOffset <= tabContentOffsets[$0] })
        {
            return linearInterpolation(
                x1: tabContentOffsets[index-1], y1: dataSource[index-1],
                x2: tabContentOffsets[index], y2: dataSource[index],
                x: contentOffset
            )

        } else {
            // Clamping to max
            return dataSource[dataSource.count-1]
        }
    }

    private func linearInterpolation<T>(
        x1: T, y1: T,
        x2: T, y2: T,
        x: T
    ) -> T
        where T: BinaryFloatingPoint
    {
        y1 + ((y2-y1) / (x2-x1)) * (x-x1)
    }

}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VWrappedIndicatorStaticPagerTabView_Previews: PreviewProvider {
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
        .preferredColorScheme(colorScheme)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
    }

    // Data
    private enum RGBColor: Int, Hashable, Identifiable, CaseIterable {
        case red, green, blue

        var id: Int { rawValue }

        var tabItemTitle: String { .init(describing: self).capitalized.pseudoRTL(languageDirection) }
        var color: Color {
            switch self {
            case .red: return Color.red
            case .green: return Color.green
            case .blue: return Color.blue
            }
        }
    }
    private static var selection: RGBColor { .red }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: RGBColor = VWrappedIndicatorStaticPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VWrappedIndicatorStaticPagerTabView(
                    selection: $selection,
                    data: RGBColor.allCases,
                    tabItemTitle: { $0.tabItemTitle },
                    content: { $0.color }
                )
                .padding()
            })
        }
    }

    private struct CustomTabBarPreview: View {
        @State private var selection: RGBColor = VWrappedIndicatorStaticPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VWrappedIndicatorStaticPagerTabView(
                    uiModel: {
                        var uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init()
                        uiModel.headerBackgroundColor = ColorBook.layerGray.opacity(0.5)
                        uiModel.tabItemMargins.top *= 1.5
                        return uiModel
                    }(),
                    selection: $selection,
                    data: RGBColor.allCases,
                    tabItemTitle: { $0.tabItemTitle },
                    content: { $0.color }
                )
                .applyModifier({
#if canImport(UIKit)
                    $0.cornerRadius(20, corners: .topCorners)
#else
                    $0
#endif
                })
                .padding()
            })
        }
    }

    private struct CustomTabIndicatorPreview: View {
        @State private var selection: RGBColor = VWrappedIndicatorStaticPagerTabView_Previews.selection

        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VWrappedIndicatorStaticPagerTabView(
                    uiModel: {
                        var uiModel: VWrappedIndicatorStaticPagerTabViewUIModel = .init()
                        uiModel.tabIndicatorTrackHeight = 1
                        uiModel.tabIndicatorTrackColor = ColorBook.layerGray
                        uiModel.selectedTabIndicatorHeight = 3
                        return uiModel
                    }(),
                    selection: $selection,
                    data: RGBColor.allCases,
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
