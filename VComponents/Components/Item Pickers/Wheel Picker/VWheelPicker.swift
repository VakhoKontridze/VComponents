//
//  VWheelPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Wheel Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a scrollable wheel.
///
/// Component can be initialized with data, row titles, `PickableEnumeration`, or `PickableTitledItem`.
///
/// Best suited for `5`+ items.
///
/// Model, state, header, and footer can be passed as parameters.
///
/// Usage example:
///
///     @State var selectedIndex: Int = 7
///
///     let rowTitles: [String] = [
///         "January", "February", "March",
///         "April", "May", "June",
///         "July", "August", "September",
///         "October", "November", "December"
///     ]
///
///     var body: some View {
///         VWheelPicker(
///             selectedIndex: $selectedIndex,
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///             rowTitles: rowTitles
///         )
///             .padding(20)
///     }
///
public struct VWheelPicker<Data, RowContent>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        RowContent: View
{
    // MARK: Properties
    private let model: VWheelPickerModel
    
    private let state: VWheelPickerState
    
    @Binding private var selectedIndex: Int
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers - View Builder
    /// Initializes component with selected index, header, footer, data, and row content.
    public init(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self.state = state
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = data
        self.rowContent = rowContent
    }

    // MARK: Initializes: Row Titles
    /// Initializes component with selected index, header, footer, and row titles.
    public init(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<String>,
            RowContent == VText
    {
        self.init(
            model: model,
            state: state,
            selectedIndex: selectedIndex,
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: rowTitles,
            rowContent: { title in
                VText(
                    color: model.colors.textContent.for(state),
                    font: model.fonts.rows,
                    title: title
                )
            }
        )
    }

    // MARK: Initialzers: Pickable Item
    /// Initializes component with `PickableEnumeration`, header, footer, and row content.
    public init<PickableItem>(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder rowContent: @escaping (PickableItem) -> RowContent
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self.init(
            model: model,
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: .init(PickableItem.allCases),
            rowContent: rowContent
        )
    }

    // MARK: Initialzers: Pickable Titled Item
    /// Initializes component with `PickableTitledItem`, header, and footer.
    public init<PickableItem>(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<PickableItem>,
            RowContent == VText,
            PickableItem: PickableTitledEnumeration
    {
        self.init(
            model: model,
            state: state,
            selectedIndex: .init(
                get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
                set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
            ),
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: .init(PickableItem.allCases),
            rowContent: { item in
                VText(
                    color: model.colors.textContent.for(state),
                    font: model.fonts.rows,
                    title: item.pickerTitle
                )
            }
        )
    }

    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.headerFooterSpacing, content: {
            headerView
            pickerView
            footerView
        })
    }
    
    private var pickerView: some View {
        Picker(selection: $selectedIndex, label: EmptyView(), content: {
            ForEach(0..<data.count, content: { i in
                rowContent(data[i])
                    .tag(i)
            })
        })
            .pickerStyle(.wheel)
            .labelsHidden()
            
            .disabled(!state.isEnabled) // Luckily, doesn't affect colors
            .opacity(model.colors.content.for(state))
            
            .background(model.colors.background.for(state).cornerRadius(model.layout.cornerRadius))
    }
    
    @ViewBuilder private var headerView: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                color: model.colors.header.for(state),
                font: model.fonts.header,
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerMarginHorizontal)
                .opacity(model.colors.content.for(state))
        }
    }
    
    @ViewBuilder private var footerView: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, limit: nil),
                color: model.colors.footer.for(state),
                font: model.fonts.footer,
                title: footerTitle
            )
                .padding(.horizontal, model.layout.headerMarginHorizontal)
                .opacity(model.colors.content.for(state))
        }
    }
}

// MARK: - Preview
struct VWheelPicker_Previews: PreviewProvider {
    @State private static var selectedIndex: Int = 7
    
    private static var rowTitles: [String] {
        [
            "January", "February", "March",
            "April", "May", "June",
            "July", "August", "September",
            "October", "November", "December"
        ]
    }

    static var previews: some View {
        VWheelPicker(
            selectedIndex: $selectedIndex,
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            rowTitles: rowTitles
        )
            .padding(20)
    }
}
