//
//  VDropDown.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK:- V Drop Down
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
///     VDropDown(
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
public struct VDropDown<Label, Data>: View
    where
        Label: View,
        Data: RandomAccessCollection,
        Data.Index == Int
{
    // MARK: Properties
    private let dropDownButtonType: VDropDownButtonType
    
    @Binding private var selectedIndex: Int
    
    private let state: VDropDownState
    
    private let label: () -> Label
    private let data: Data
    private let rowContent: (Data.Element) -> VDropDownRow

    // MARK: Initializers: View Builder and Preset
    public init(
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VDropDownRow
    ) {
        self.dropDownButtonType = dropDownButtonPreset.buttonType
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    public init(
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
        title: String,
        data: Data,
        rowContent: @escaping (Data.Element) -> VDropDownRow
    )
        where Label == VText
    {
        self.init(
            preset: dropDownButtonPreset,
            selectedIndex: selectedIndex,
            state: state,
            label: { dropDownButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: data,
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: View Builder and Custom
    public init(
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VDropDownRow
    ) {
        self.dropDownButtonType = .custom
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    // MARK: Initializers: Row Titles and Preset
    public init(
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.dropDownButtonType = dropDownButtonPreset.buttonType
        self._selectedIndex = selectedIndex
        self.state = state
        self.label = label
        self.data = rowTitles
        self.rowContent = { title in .titled(title: title) }
    }
    
    public init(
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
        title: String,
        rowTitles: [String]
    )
        where
            Label == VText,
            Data == Array<String>
    {
        self.init(
            preset: dropDownButtonPreset,
            selectedIndex: selectedIndex,
            state: state,
            label: { dropDownButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowTitles: rowTitles
        )
    }
    
    // MARK: Initializers: Row Titles and Custom
    public init(
        selectedIndex: Binding<Int>,
        state: VDropDownState = .enabled,
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
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (Item) -> VDropDownRow
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            preset: dropDownButtonPreset,
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
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
        title: String,
        rowContent: @escaping (Item) -> VDropDownRow
    )
        where
            Label == VText,
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            preset: dropDownButtonPreset,
            selection: selection,
            state: state,
            label: { dropDownButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers: Pickable Item and Custom
    public init<Item>(
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (Item) -> VDropDownRow
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
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<Item>,
            Item: VPickableTitledItem
    {
        self.init(
            preset: dropDownButtonPreset,
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
        preset dropDownButtonPreset: VDropDownButtonPreset,
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
        title: String
    )
        where
            Label == VText,
            Data == Array<Item>,
            Item: VPickableTitledItem
    {
        self.init(
            preset: dropDownButtonPreset,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            label: { dropDownButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: .init(Item.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
    
    // MARK: Initializers: Pickable Titled Item and Custom
    public init<Item>(
        selection: Binding<Item>,
        state: VDropDownState = .enabled,
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
extension VDropDown {
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
        VDropDownButtonType.pickerButton(
            buttonType: dropDownButtonType,
            isEnabled: state.isEnabled,
            label: label
        )
    }
    
    @ViewBuilder private func rowView(_ row: VDropDownRow) -> some View {
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
struct VDropDown_Previews: PreviewProvider {
    @State private static var selection: VSegmentedPicker_Previews.PickerRow = .red
    
    static var previews: some View {
        VDropDown(
            preset: .secondary(),
            selection: $selection,
            title: "Lorem ipsum"
        )
    }
}
