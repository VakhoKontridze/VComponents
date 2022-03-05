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
/// Component can be initialized with data, row titles, `PickableEnumeration`, or `PickableTitledItem`.
///
/// Component can be initialized with content or title.
///
/// Component supports presets or existing button types.
///
/// Best suited for `5+` items.
///
/// State can be passed as parameter.
///
/// Usage example:
///
///     enum PickerRow: Int, PickableEnumeration {
///         case red, green, blue
///
///         var pickerTitle: String {
///             switch self {
///             case .red: return "Red"
///             case .green: return "Green"
///             case .blue: return "Blue"
///             }
///         }
///
///         var pickerIcon: String { "swift" }
///     }
///
///     @State var selection: PickerRow = .red
///
///     var body: some View {
///         VMenuPicker(
///             preset: .secondary(),
///             selection: $selection,
///             title: "Lorem Ipsum",
///             rowContent: { row in
///                 .titledSystemIcon(
///                     title: row.pickerTitle,
///                     name: "swift"
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
    private let menuPickerButtonType: VMenuPickerButtonType
    
    private let state: VMenuPickerState
    
    @Binding private var selectedIndex: Int
    
    private let label: () -> Label
    private let data: Data
    private let rowContent: (Data.Element) -> VMenuPickerRow

    // MARK: Initializers - View Builder and Preset
    /// Initializes component with preset, selected index, content, data, and row content.
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    ) {
        self.menuPickerButtonType = menuPickerButtonPreset.buttonType
        self.state = state
        self._selectedIndex = selectedIndex
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    /// Initializes component with preset, selected index, title, data, and row content.
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        title: String,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    )
        where Label == VText
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selectedIndex: selectedIndex,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: data,
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers - View Builder and Custom
    /// Initializes component with selected index, content, data, and row content.
    public init(
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        data: Data,
        rowContent: @escaping (Data.Element) -> VMenuPickerRow
    ) {
        self.menuPickerButtonType = .custom
        self.state = state
        self._selectedIndex = selectedIndex
        self.label = label
        self.data = data
        self.rowContent = rowContent
    }
    
    // MARK: Initializers - Row Titles and Preset
    /// Initializes component with preset, selected index, content, and row titles.
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.menuPickerButtonType = menuPickerButtonPreset.buttonType
        self.state = state
        self._selectedIndex = selectedIndex
        self.label = label
        self.data = rowTitles
        self.rowContent = { title in .titled(title: title) }
    }
    
    /// Initializes component with preset, selected index, title, and row titles.
    public init(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        title: String,
        rowTitles: [String]
    )
        where
            Label == VText,
            Data == Array<String>
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selectedIndex: selectedIndex,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowTitles: rowTitles
        )
    }
    
    // MARK: Initializers - Row Titles and Custom
    /// Initializes component with selected index, content, and row titles.
    public init(
        state: VMenuPickerState = .enabled,
        selectedIndex: Binding<Int>,
        @ViewBuilder label: @escaping () -> Label,
        rowTitles: [String]
    )
        where Data == Array<String>
    {
        self.init(
            state: state,
            selectedIndex: selectedIndex,
            label: label,
            data: rowTitles,
            rowContent: { title in .titled(title: title) }
        )
    }
    
    // MARK: Initializers - Pickable Item and Preset
    /// Initializes component with preset, `PickableEnumeration`, content, and row content.
    public init<PickableItem>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (PickableItem) -> VMenuPickerRow
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            label: label,
            data: .init(PickableItem.allCases),
            rowContent: rowContent
        )
    }
    
    /// Initializes component with preset, `PickableEnumeration`, title, and row content.
    public init<PickableItem>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        title: String,
        rowContent: @escaping (PickableItem) -> VMenuPickerRow
    )
        where
            Label == VText,
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selection: selection,
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers - Pickable Item and Custom
    /// Initializes component with `PickableEnumeration`, content, and row content.
    public init<PickableItem>(
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label,
        rowContent: @escaping (PickableItem) -> VMenuPickerRow
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self.init(
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            label: label,
            data: .init(PickableItem.allCases),
            rowContent: rowContent
        )
    }
    
    // MARK: Initializers - Pickable Titled Item and Preset
    /// Initializes component with preset, `PickableTitledItem` and content.
    public init<PickableItem>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableTitledEnumeration
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            label: label,
            data: .init(PickableItem.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
    
    /// Initializes component with preset, `PickableTitledItem` and title.
    public init<PickableItem>(
        preset menuPickerButtonPreset: VMenuPickerButtonPreset,
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        title: String
    )
        where
            Label == VText,
            Data == Array<PickableItem>,
            PickableItem: PickableTitledEnumeration
    {
        self.init(
            preset: menuPickerButtonPreset,
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            label: { menuPickerButtonPreset.text(from: title, isEnabled: state.isEnabled) },
            data: .init(PickableItem.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }
    
    // MARK: Initializers - Pickable Titled Item and Custom
    /// Initializes component with `PickableTitledItem` and content.
    public init<PickableItem>(
        state: VMenuPickerState = .enabled,
        selection: Binding<PickableItem>,
        @ViewBuilder label: @escaping () -> Label
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableTitledEnumeration
    {
        self.init(
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            label: label,
            data: .init(PickableItem.allCases),
            rowContent: { item in .titled(title: item.pickerTitle) }
        )
    }

    // MARK: Body
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
        VMenuPickerButtonType.menuPickerButton(
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

// MARK: - Preview
//struct VMenuPicker_Previews: PreviewProvider { // FIXME: Resolve
//    @State private static var selection: VSegmentedPicker_Previews.PickerRow = .red
//
//    static var previews: some View {
//        VMenuPicker(
//            preset: .secondary(),
//            selection: $selection,
//            title: "Lorem Ipsum"
//        )
//    }
//}
