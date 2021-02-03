//
//  VMenuPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK:- V Menu Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a menu
///
/// Component can be initialized with data, row titles, VPickableItem, or VPickableTitledItem
///
/// Best suited for 5+ items
///
/// State can be passed as parameter
///
/// ```
/// enum PickerRow: Int, VPickableItem {
///     case red, green, blue
///
///     var pickerTitle: String {
///         switch self {
///         case .red: return "Red"
///         case .green: return "Green"
///         case .blue: return "Blue"
///         }
///     }
///
///     var pickerIcon: String { "swift" }
/// }
///
/// @State var selection: PickerRow = .red
///
/// var body: some View {
///     VMenuPicker(
///         preset: .secondary(),
///         selection: $selection,
///         title: "Lorem ipsum",
///         rowContent: { row in
///             .titledSystemIcon(
///                 title: row.pickerTitle,
///                 name: "swift"
///             )
///         }
///     )
/// }
/// ```
///
public struct VMenuPicker<Label, Data>: View
    where
        Label: View,
        Data: RandomAccessCollection,
        Data.Index == Int
{
    // MARK: Properties
    private let menuPickerButtonType: VMenuPickerButtonType
    
    @Binding private var selectedIndex: Int
    
    private let state: VMenuPickerState
    
    private let label: () -> Label
    private let data: Data
    private let rowContent: (Data.Element) -> VMenuPickerRow

    // MARK: Initializers: View Builder and Preset
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    ) {
        self.menuPickerButtonType = menuPickerButtonPreset.buttonType
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        title: String,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    )
        where Label == VText
    {
        self.init(
            preset: menuPickerButtonPreset,
            selectedIndex: selectedIndex,
            state: state,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: data,
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: View Builder and Custom
    public init(
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    ) {
        self.menuPickerButtonType = .custom
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    // MARK: Initializers: Row Titles and Preset
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.menuPickerButtonType = menuPickerButtonPreset.buttonType
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = rowTitles
        self.rowContent = { title in .titled(title: title) }
    }
    
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        title: String,
        rowTitles: [String]
    )
        where
            Label == VText,
            Data == Array<String>
    {
        self.init(
            preset: menuPickerButtonPreset,
            selectedIndex: selectedIndex,
            state: state,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowTitles: rowTitles
        )
    }
    
    // MARK: Initializers: Row Titles and Custom
    public init(
        selectedIndex: Binding<Int>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.init(
            selectedIndex: selectedIndex,
            state: state,
            label: label,
            data: rowTitles,
            rowContent: { title in .titled(title: title) }
        )
    }
    
    // MARK: Initializers: Pickable Item and Preset
    public init<Item>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (Item) -> VMenuPickerRow
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            preset: menuPickerButtonPreset,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: label,
            data: .init(Item.allCases),
            rowContent: rowContent
        )
    }
    
    public init<Item>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        title: String,
        rowContent: @escaping (Item) -> VMenuPickerRow
    )
        where
            Label == VText,
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            preset: menuPickerButtonPreset,
            selection: selection,
            state: state,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Pickable Item and Custom
    public init<Item>(
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (Item) -> VMenuPickerRow
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: label,
            data: .init(Item.allCases),
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Pickable Titled Item and Preset
    public init<Item>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<Item>,
            Item: VPickableTitledItem
    {
        self.init(
            preset: menuPickerButtonPreset,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: label,
            data: .init(Item.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
    
    public init<Item>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        title: String
    )
        where
            Label == VText,
            Data == Array<Item>,
            Item: VPickableTitledItem
    {
        self.init(
            preset: menuPickerButtonPreset,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: .init(Item.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
    
    // MARK: Initializers: Pickable Titled Item and Custom
    public init<Item>(
        selection: Binding<Item>,
        state: VMenuPickerState = .enabled,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<Item>,
            Item: VPickableTitledItem
    {
        self.init(
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: label,
            data: .init(Item.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
}

// MARK:- Body
extension VMenuPicker {
    public var body: some View {
        Picker(selection: $selectedIndex, label: labelView, content: {
            ForEach(data.enumeratedArray().reversed(), id: \.offset, content: { (i, row) in
                rowView(rowContent(row))
                    .tag(i)
            })
        })
            .pickerStyle(MenuPickerStyle())
            .disabled(!state.isEnabled) // Luckily, doesn't affect colors
    }
    
    private var labelView: some View {
        VMenuPickerButtonType.pickerButton(
            buttonType: menuPickerButtonType,
            isEnabled: state.isEnabled,
            label: label
        )
    }
    
    @ViewBuilder private func rowView(_ row: VMenuPickerRow) -> some View {
        switch row {
        case .titled(let title):
            Text(title)
            
        case .titledSystemIcon(let title, let name):
            HStack(content: {
                Text(title)
                Image(systemName: name)
            })
        
        case .titledAssetIcon(let title, let name, let bundle):
            HStack(content: {
                Text(title)
                Image(name, bundle: bundle)
            })
        }
    }
}

// MARK:- Preview
struct VMenuPicker_Previews: PreviewProvider {
    @State private static var selection: VSegmentedPicker_Previews.PickerRow = .red
    
    static var previews: some View {
        VMenuPicker(
            preset: .secondary(),
            selection: $selection,
            title: "Lorem ipsum"
        )
    }
}
