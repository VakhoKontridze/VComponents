//
//  VMenuSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 30.06.22.
//

import SwiftUI
import VCore

// MARK: - V Menu Group Section
/// Grouped container view that you can use to add hierarchy to `VMenuGroupRowProtocol`s.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuGroupSection: VMenuSectionProtocol {
    // MARK: Properties
    public var title: String?
    private let rows: () -> [any VMenuGroupRowProtocol]
    
    // MARK: Initializers
    /// Initializes `VMenuGroupSection` with rows.
    public init(
        title: String? = nil,
        @VMenuGroupRowBuilder rows: @escaping () -> [any VMenuGroupRowProtocol]
    ) {
        self.title = title
        self.rows = rows
    }
    
    // MARK: Section Protocol
    //public var title: String?
    
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
/// Container view with picker that you can use to add hierarchy to `VMenuPickerRowProtocol`s.
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
    public var title: String?

    @Binding private var selection: Data.Element

    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> VMenuPickerRowProtocol

    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selection, data, id, and row content.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        content: @escaping (Data.Element) -> VMenuPickerRowProtocol
    ) {
        self.title = title
        self._selection = selection
        self.data = data
        self.id = id
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VMenuPickerSection` with selection, data, and row content.
    public init(
        title: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        content: @escaping (Data.Element) -> VMenuPickerRowProtocol
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.title = title
        self._selection = selection
        self.data = data
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
        self.content = { VMenuPickerRow(title: $0.stringRepresentation) }
    }
    
    // MARK: Section Protocol
    //public var title: String?
    
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
