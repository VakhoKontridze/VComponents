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
public struct VMenuPickerSection<SelectionValue, ID>: VMenuSectionProtocol
    where
        SelectionValue: Hashable,
        ID: Hashable
{
    // MARK: Properties
    @Binding private var selection: SelectionValue
    private let data: [SelectionValue]
    private let id: KeyPath<SelectionValue, ID>
    private let content: (SelectionValue) -> VMenuRowProtocol
    
    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selection, data, id, and row title.
    public init(
        title: String? = nil,
        selection: Binding<SelectionValue>,
        data: [SelectionValue],
        id: KeyPath<SelectionValue, ID>,
        _title: @escaping (SelectionValue) -> String // TODO: Rename
    ) {
        self.title = title
        self._selection = selection
        self.data = data
        self.id = id
        self.content = { VMenuTitleRow(action: {}, title: _title($0)) } // TODO: Handle
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VMenuPickerSection` with selection, data, and row title.
    public init(
        title: String? = nil,
        selection: Binding<SelectionValue>,
        data: [SelectionValue],
        _title: @escaping (SelectionValue) -> String
    )
        where
            SelectionValue: Identifiable,
            ID == SelectionValue.ID
    {
        self.title = title
        self._selection = selection
        self.data = data
        self.id = \.id
        self.content = { VMenuTitleRow(action: {}, title: _title($0)) }
    }
    
    // MARK: Initializers - String Representable
    /// Initializes `VSegmentedPicker` with `StringRepresentable` API.
    public init(
        title: String? = nil,
        selection: Binding<SelectionValue>
    )
        where
            SelectionValue: Identifiable & CaseIterable & StringRepresentable,
            ID == SelectionValue.ID
    {
        self.title = title
        self._selection = selection
        self.data = Array(SelectionValue.allCases)
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
