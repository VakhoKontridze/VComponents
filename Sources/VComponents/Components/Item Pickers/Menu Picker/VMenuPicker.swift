//
//  VMenuPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Menu Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a menu.
///
/// Component row content can be initialized with data, row titles, or `PickableEnumeration`/`PickableTitledEnumeration`.
///
/// Component label can be used with button components from the library.
///
/// Best suited for `5+` items.
///
/// Model can be passed as parameter.
///
/// Usage example:
///
///     enum PickerRow: Int, PickableTitledEnumeration {
///         case red, green, blue
///
///         var pickerTitle: String {
///             switch self {
///             case .red: return "Red"
///             case .green: return "Green"
///             case .blue: return "Blue"
///             }
///         }
///     }
///
///     @State var selection: PickerRow = .red
///
///     var body: some View {
///         VMenuPicker(
///             selection: $selection,
///             label: {
///                 VPlainButton(
///                     action: {},
///                     title: "Select"
///                 )
///             }
///         )
///     }
///
public struct VMenuPicker<Label, Data>: View
    where
        Label: View,
        Data: RandomAccessCollection,
        Data.Index == Int
{
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VMenuPickerInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var selectedIndex: Int
    
    private let label: () -> Label
    private let data: Data
    private let rowContent: (Data.Element) -> VMenuPickerRowContent

    // MARK: Initializers - View Builder
    /// Initializes component with selected index, label, data, and row content.
    public init(
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRowContent
    ) {
        self._selectedIndex = selectedIndex
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }

    // MARK: Initializers - Row Titles
    /// Initializes component with selected index, label, and row titles.
    public init(
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self._selectedIndex = selectedIndex
        self.label = label
        self.data = rowTitles
        self.rowContent = { .title(title: $0) }
    }
    
    // MARK: Initializers - Pickable Enumeration & Pickable Titled Enumeration
    /// Initializes component with `PickableEnumeration`, label, and row content.
    public init<PickableItem>(
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (PickableItem) -> VMenuPickerRowContent
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self._selectedIndex = .init(
            get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
        )
        self.label = label
        self.data = .init(PickableItem.allCases)
        self.rowContent = rowContent
    }

    /// Initializes component with `PickableTitledItem` and label.
    public init<PickableItem>(
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableTitledEnumeration
    {
        self._selectedIndex = .init(
            get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
        )
        self.label = label
        self.data = .init(PickableItem.allCases)
        self.rowContent = { .title(title: $0.pickerTitle) }
    }

    // MARK: Body
    public var body: some View {
        Menu(
            content: { menuContent },
            label: { label() }
        )
            .disabled(!internalState.isEnabled)
    }
    
    private var menuContent: some View {
        Picker(
            selection: $selectedIndex,
            content: {
                ForEach(data.enumeratedArray().reversed(), id: \.offset, content: { (i, row) in
                    rowView(rowContent(row))
                        .tag(i)
                })
            },
            label: { EmptyView() }
        )
            .pickerStyle(.inline)
    }
    
    @ViewBuilder private func rowView(_ row: VMenuPickerRowContent) -> some View {
        switch row._menuPickerRowContent {
        case .title(let title):
            Text(title)
            
        case .titleAssetIcon(let title, let icon, let bundle):
            HStack(content: {
                Text(title)
                Image(icon, bundle: bundle)
            })
            
        case .titleIcon(let title, let icon):
            HStack(content: {
                Text(title)
                icon
            })
            
        case .titleSystemIcon(let title, let icon):
            HStack(content: {
                Text(title)
                Image(systemName: icon)
            })
        }
    }
}

// MARK: - Preview
struct VMenuPicker_Previews: PreviewProvider {
    @State private static var selection: VSegmentedPicker_Previews.PickerRow = .red

    static var previews: some View {
        VMenuPicker(
            selection: $selection,
            label: {
                VPlainButton(
                    action: {},
                    title: "Select"
                )
            }
        )
    }
}
