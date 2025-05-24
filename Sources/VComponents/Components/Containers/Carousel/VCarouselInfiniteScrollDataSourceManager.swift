//
//  VCarouselInfiniteScrollDataSourceManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.07.24.
//

import Foundation

// MARK: - V Carousel Infinite Scroll Data Source Manager
/// Object that inflates data source to create an illusion of infinite scroll when using `VCarousel`.
///
/// If `data` is represented as `[1, 2, 3]` and `numberOfDuplicateGroups` equals `3`,
/// `dataInflated` will be `[1, 2, 3, 1, 2, 3, 1, 2, 3]`.
///
/// If, with the same data, `initialSelection` is `2`, and `initialGroupIndex` equals `1`,
/// `selectedIndexInflated` will be calculated from the group at index `1`, plus the index of `2` in original `data`, which is `1`.
/// As a result, `selectedIndexInflated` will be `4`, which is in the middle of the `dataInflated`.
///
///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable {
///         case red, green, blue
///
///         var id: Int { rawValue }
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
///     @State private var dataSourceManager: VCarouselInfiniteScrollDataSourceManager = .init(
///         data: Preview_RGBColor.allCases,
///         numberOfDuplicateGroups: 9,
///         initialGroupIndex: 4,
///         initialSelection: RGBColor.red
///     )
///
///     var body: some View {
///         VStack(spacing: 15, content: {
///             VCarousel(
///                 selection: $dataSourceManager.selectedIndexInflated,
///                 data: 0..<dataSourceManager.countInflated,
///                 id: \.self,
///                 content: {
///                     dataSourceManager.element(atInflatedIndex: $0)
///                         .color
///                         .clipShape(.rect(cornerRadius: 15))
///                 }
///             )
///             .frame(height: 200)
///
///             VCompactPageIndicator(
///                 total: dataSourceManager.countInflated,
///                 current: dataSourceManager.selectedIndexInflated
///             )
///         })
///     }
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(tvOS, unavailable)
@Observable
@MainActor
public final class VCarouselInfiniteScrollDataSourceManager<Element> where Element: Hashable {
    // MARK: Properties - Data
    /// Original data.
    public var data: [Element]

    /// Inflated data.
    public var dataInflated: [Element] {
        Array(repeating: data, count: numberOfDuplicateGroups)
            .flatMap { $0 }
    }

    /// Number of duplicate groups.
    public var numberOfDuplicateGroups: Int

    // MARK: Properties - Count
    /// Count of original data.
    public var count: Int { data.count }

    /// Count of inflated data.
    public var countInflated: Int {
        Self.countInflated(
            count: count,
            numberOfDuplicateGroups: numberOfDuplicateGroups
        )
    }

    // MARK: Properties - Selected Index
    /// Index of selected element in original data.
    public var selectedIndex: Int {
        Self.index(
            count: count,
            indexInflated: selectedIndexInflated
        )
    }

    /// Index of selected element in inflated data.
    public var selectedIndexInflated: Int

    // MARK: Properties - Selection
    /// Selected element.
    public var selection: Element {
        element(atInflatedIndex: selectedIndexInflated)
    }

    // MARK: Initializers
    /// Initializes `VCarouselInfiniteScrollDataSourceManager` with data and inflation parameters.
    public init(
        data: [Element],
        numberOfDuplicateGroups: Int,
        initialGroupIndex: Int,
        initialSelection: Element
    ) {
        self.data = data

        self.numberOfDuplicateGroups = numberOfDuplicateGroups

        self.selectedIndexInflated = Self.indexInflated(
            count: data.count,
            groupIndex: initialGroupIndex,
            index: data.firstIndex(of: initialSelection) ?? 0
        )
    }

    // MARK: Subscript
    /// Retrieves element at an inflated index.
    public func element(atInflatedIndex indexInflated: Int) -> Element {
        let index: Int = Self.index(
            count: count,
            indexInflated: indexInflated
        )

        return data[index]
    }

    // MARK: Helpers
    private static func countInflated(
        count: Int,
        numberOfDuplicateGroups: Int
    ) -> Int {
        count * numberOfDuplicateGroups
    }

    private static func index(
        count: Int,
        indexInflated: Int
    ) -> Int {
        indexInflated % count
    }

    private static func indexInflated(
        count: Int,
        groupIndex: Int,
        index: Int
    ) -> Int {
        groupIndex * count + index
    }
}
