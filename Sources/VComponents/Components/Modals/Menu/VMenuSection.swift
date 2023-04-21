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
@available(iOS 15.0, macOS 12.0, *)
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

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuSectionProtocol {
    public func toSections() -> [any VMenuSectionProtocol] { [self] }
}

// MARK: - V Menu Group Section
/// Grouped container view that you can use to add hierarchy to `VMenuRowProtocol`s.
@available(iOS 15.0, macOS 12.0, *)
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
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS 7, *)@available(watchOS, unavailable)
public struct VMenuPickerSection<Data, ID>: VMenuSectionProtocol
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable
{
    // MARK: Properties
    @Binding private var selection: Data.Element
    private let data: [Data.Element]
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> VMenuRowProtocol
    
    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selection, data, id, and row title.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        rowTitle: @escaping (Data.Element) -> String // TODO: Rename
    ) {
        self.title = title
        self._selection = selection
        self.data = Array(data)
        self.id = id
        self.content = { VMenuTitleRow(action: {}, title: rowTitle($0)) } // TODO: Handle
    }

    /// Initializes `VMenuPickerSection` with selection, data, id, and row content.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        content: @escaping (Data.Element) -> VMenuRowProtocol
    ) {
        self.title = title
        self._selection = selection
        self.data = Array(data)
        self.id = id
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VMenuPickerSection` with selection, data, and row title.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        rowTitle: @escaping (Data.Element) -> String
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.title = title
        self._selection = selection
        self.data = Array(data)
        self.id = \.id
        self.content = { VMenuTitleRow(action: {}, title: rowTitle($0)) }
    }

    /// Initializes `VMenuPickerSection` with selection, data, and row content.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        content: @escaping (Data.Element) -> VMenuRowProtocol
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.title = title
        self._selection = selection
        self.data = Array(data)
        self.id = \.id
        self.content = content
    }
    
    // MARK: Initializers - String Representable
    /// Initializes `VSegmentedPicker` with `StringRepresentable` API.
    public init<T>(
        title: String? = nil,
        selection: Binding<T>
    )
        where
            Data == Array<T>,
            T: Identifiable & CaseIterable & StringRepresentable,
            ID == T.ID
    {
        self.title = title
        self._selection = selection
        self.data = Array(T.allCases)
        self.id = \.id
        self.content = { VMenuTitleRow(action: {}, title: $0.stringRepresentation) }
    }
    
    // MARK: Body
    public var title: String?
    
    public func makeBody() -> AnyView {
        .init(
            Picker(
                selection: $selection,
                content: {
                    ForEach(data, id: id, content: { element in
                        content(element).makeBody()
                            .tag(element) // TODO: `Picker` requires tag. Remove this when custom component is added.
                    })
                },
                label: EmptyView.init
            )
            .pickerStyle(.inline)
        )
    }
}
