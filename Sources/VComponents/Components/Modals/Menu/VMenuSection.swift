//
//  VMenuSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 30.06.22.
//

import SwiftUI
import VCore

// MARK: - V Menu Section Protocol
/// Container view that you can use to add hierarchy to `VMenuRowProtocol`s.
@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuSectionProtocol: VMenuSectionConvertible {
    /// Section title.
    var title: String? { get }

    /// Section body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a section.
    func makeBody() -> Body
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuSectionProtocol {
    public func toSections() -> [any VMenuSectionProtocol] { [self] }
}

// MARK: - V Menu Group Section
/// Grouped container view that you can use to add hierarchy to `VMenuRowProtocol`s.
@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuGroupSection: VMenuSectionProtocol {
    // MARK: Properties
    private let rows: () -> [any VMenuRowProtocol]

    // MARK: Initializers
    /// Initializes `VMenuGroupSection` with rows.
    public init(
        title: String? = nil,
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRowProtocol]
    ) {
        self.title = title
        self.rows = rows
    }

    // MARK: Body
    public var title: String?

    public func makeBody() -> AnyView {
        .init(
            ForEach(
                rows().enumeratedArray(),
                id: \.offset,
                content: { (_, row) in row.makeBody() }
            )
        )
    }
}

// MARK: - V Menu Picker Section
/// Container view with picker that you can use to add hierarchy to `VMenuRowProtocol`s.
@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS 7, *)@available(watchOS, unavailable)
public struct VMenuPickerSection<Data>: VMenuSectionProtocol
    where
        Data: RandomAccessCollection,
        Data.Index == Int
{
    // MARK: Properties
    private let data: Data
    private let content: (Data.Element) -> VMenuRowProtocol

    @Binding private var selectedIndex: Int

    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selected index, data, and content.
    public init(
        title: String? = nil,
        selectedIndex: Binding<Int>,
        data: Data,
        content: @escaping (Data.Element) -> VMenuRowProtocol
    ) {
        self.title = title
        self._selectedIndex = selectedIndex
        self.data = data
        self.content = content
    }

    /// Initializes `VMenuPickerSection` with selected index and row titles.
    public init(
        title: String? = nil,
        selectedIndex: Binding<Int>,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.title = title
        self._selectedIndex = selectedIndex
        self.data = rowTitles
        self.content = { VMenuTitleRow(action: {}, title: $0) }
    }

    /// Initializes `VMenuPickerSection` with `HashableEnumeration` and content.
    public init<T>(
        title: String? = nil,
        selection: Binding<T>,
        content: @escaping (T) -> VMenuRowProtocol
    )
        where
            T: HashableEnumeration,
            Data == Array<T>
    {
        self.title = title
        self._selectedIndex = .init(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.data = Array(T.allCases)
        self.content = content
    }

    /// Initializes `VMenuPickerSection` with `StringRepresentableHashableEnumeration`.
    public init<T>(
        title: String? = nil,
        selection: Binding<T>
    )
        where
            T: StringRepresentableHashableEnumeration,
            Data == Array<T>
    {
        self.title = title
        self._selectedIndex = .init(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.data = Array(T.allCases)
        self.content = { VMenuTitleRow(action: {}, title: $0.stringRepresentation) }
    }

    // MARK: Body
    public var title: String?

    public func makeBody() -> AnyView {
        .init(
            Picker(
                selection: $selectedIndex,
                content: {
                    ForEach(
                        data.enumeratedArray(),
                        id: \.offset,
                        content: { (i, element) in
                            content(element).makeBody()
                                .tag(i)
                        }
                    )
                },
                label: EmptyView.init
            )
                .pickerStyle(.inline)
        )
    }
}
