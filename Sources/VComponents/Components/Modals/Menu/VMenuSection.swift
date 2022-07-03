//
//  VMenuSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 30.06.22.
//

import SwiftUI
import VCore

// MARK: - V Menu Section
/// Container view that you can use to add hierarchy to `VMenuRow`'s.
public protocol VMenuSection: VMenuSectionConvertible {
    /// Section body type.
    typealias Body = AnyView
    
    /// Section title.
    var title: String? { get }
    
    /// Section body.
    var body: Body { get }
}

extension VMenuSection {
    public func toSections() -> [any VMenuSection] { [self] }
}

// MARK: - V Menu Group Section
/// Grouped container view that you can use to add hierarchy to `VMenuRow`'s.
public struct VMenuGroupSection: VMenuSection {
    // MARK: Properties
    private let rows: () -> [any VMenuRow]
    
    // MARK: Initializers
    /// Initializes `VMenuGroupSection` with rows.
    public init(
        title: String? = nil,
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRow]
    ) {
        self.title = title
        self.rows = rows
    }
    
    // MARK: Menu Section
    public var title: String?
    
    public var body: AnyView {
        .init(
            ForEach(rows().enumeratedArray().reversed(), id: \.offset, content: { (_, row) in
                row.body
            })
        )
    }
}

// MARK: - V Menu Picker Section
/// Container view with picker that you can use to add hierarchy to `VMenuRow`'s.
public struct VMenuPickerSection<Data>: VMenuSection
    where
        Data: RandomAccessCollection,
        Data.Index == Int
{
    // MARK: Properties
    private let data: Data
    private let content: (Data.Element) -> VMenuRow
    
    @Binding private var selectedIndex: Int
    
    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selected index, data, and content.
    public init(
        title: String? = nil,
        selectedIndex: Binding<Int>,
        data: Data,
        content: @escaping (Data.Element) -> VMenuRow
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
        content: @escaping (T) -> VMenuRow
    )
        where
            T: HashableEnumeration,
            Data == Array<T>
    {
        self.title = title
        self._selectedIndex = .init(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
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
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.data = Array(T.allCases)
        self.content = { VMenuTitleRow(action: {}, title: $0.stringRepresentation) }
    }
    
    // MARK: Menu Section
    public var title: String?
    
    public var body: AnyView {
        .init(
            Picker(
                selection: $selectedIndex,
                content: {
                    ForEach(data.enumeratedArray().reversed(), id: \.offset, content: { (i, element) in
                        content(element).body
                            .tag(i)
                    })
                },
                label: EmptyView.init
            )
                .pickerStyle(.inline)
        )
    }
}
