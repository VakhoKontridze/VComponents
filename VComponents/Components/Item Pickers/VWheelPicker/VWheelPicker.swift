//
//  VWheelPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Wheel Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a scrollable wheel
///
/// Component can be initialized with data, row titles, VPickableItem, or VPickableTitledItem
///
/// Model, state, header, and footer can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var selectedIndex: Int = 7
///
/// let rowTitles: [String] = [
///     "January", "February", "March",
///     "April", "May", "June",
///     "July", "August", "September",
///     "October", "November", "December"
/// ]
///
/// var body: some View {
///     VWheelPicker(
///         selectedIndex: $selectedIndex,
///         header: "Lorem ipsum dolor sit amet",
///         footer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///         rowTitles: rowTitles
///     )
///         .padding(20)
/// }
/// ```
///
public struct VWheelPicker<Data, RowContent>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        RowContent: View
{
    // MARK: Properties
    private let model: VWheelPickerModel
    
    @Binding private var selectedIndex: Int
    private let state: VWheelPickerState
    
    private let header: String?
    private let footer: String?
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers: View Builder
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.header = header
        self.footer = footer
        self.data = data
        self.rowContent = rowContent
    }

    // MARK: Initializes: Row Titles
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<String>,
            RowContent == VText
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            header: header,
            footer: footer,
            data: rowTitles,
            rowContent: { title in
                VText(
                    type: .oneLine,
                    font: model.fonts.rows,
                    color: model.colors.textContent.for(state),
                    title: title
                )
            }
        )
    }

    // MARK: Initialzers: Pickable Item
    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            header: header,
            footer: footer,
            data: .init(Item.allCases),
            rowContent: rowContent
        )
    }

    // MARK: Initialzers: Pickable Titled Item
    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil
    )
        where
            Data == Array<Item>,
            RowContent == VText,
            Item: VPickableTitledItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            header: header,
            footer: footer,
            data: .init(Item.allCases),
            rowContent: { item in
                VText(
                    type: .oneLine,
                    font: model.fonts.rows,
                    color: model.colors.textContent.for(state),
                    title: item.pickerTitle
                )
            }
        )
    }
}

// MARK:- Body
extension VWheelPicker {
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
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            
            .disabled(!state.isEnabled) // Luckily, doesn't affect colors
            .opacity(model.colors.content.for(state))
            
            .background(model.colors.background.for(state).cornerRadius(model.layout.cornerRadius))
    }
    
    @ViewBuilder private var headerView: some View {
        if let header = header, !header.isEmpty {
            VText(
                type: .oneLine,
                font: model.fonts.header,
                color: model.colors.header.for(state),
                title: header
            )
                .padding(.horizontal, model.layout.headerMarginHor)
                .opacity(model.colors.content.for(state))
        }
    }
    
    @ViewBuilder private var footerView: some View {
        if let footer = footer, !footer.isEmpty {
            VText(
                type: .multiLine(limit: nil, alignment: .leading),
                font: model.fonts.footer,
                color: model.colors.footer.for(state),
                title: footer
            )
                .padding(.horizontal, model.layout.headerMarginHor)
                .opacity(model.colors.content.for(state))
        }
    }
}

// MARK:- Preview
struct VWheelPicker_Previews: PreviewProvider {
    @State private static var selectedIndex: Int = 7
    
    private static let rowTitles: [String] = [
        "January", "February", "March",
        "April", "May", "June",
        "July", "August", "September",
        "October", "November", "December"
    ]

    static var previews: some View {
        VWheelPicker(
            selectedIndex: $selectedIndex,
            header: "Lorem ipsum dolor sit amet",
            footer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            rowTitles: rowTitles
        )
            .padding(20)
    }
}
