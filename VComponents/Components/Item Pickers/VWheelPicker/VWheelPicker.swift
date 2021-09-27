//
//  VWheelPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Wheel Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a scrollable wheel
///
/// Component can be initialized with data, row titles, `VPickableItem`, or `VPickableTitledItem`
///
/// Best suited for `5`+ items
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
///         headerTitle: "Lorem ipsum dolor sit amet",
///         footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
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
    
    private let state: VWheelPickerState
    
    @Binding private var selectedIndex: Int
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers - View Builder
    /// Initializes component with selected index, header, footer, data, and row content
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
    /// Initializes component with selected index, header, footer, and row titles
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
                    type: .oneLine,
                    font: model.fonts.rows,
                    color: model.colors.textContent.for(state),
                    title: title
                )
            }
        )
    }

    // MARK: Initialzers: Pickable Item
    /// Initializes component with `VPickableItem`, header, footer, and row content
    public init<Item>(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selection: Binding<Item>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            model: model,
            state: state,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: .init(Item.allCases),
            rowContent: rowContent
        )
    }

    // MARK: Initialzers: Pickable Titled Item
    /// Initializes component with `VPickableTitledItem`, header, and footer
    public init<Item>(
        model: VWheelPickerModel = .init(),
        state: VWheelPickerState = .enabled,
        selection: Binding<Item>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<Item>,
            RowContent == VText,
            Item: VPickableTitledItem
    {
        self.init(
            model: model,
            state: state,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            headerTitle: headerTitle,
            footerTitle: footerTitle,
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
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            
            .disabled(!state.isEnabled) // Luckily, doesn't affect colors
            .opacity(model.colors.content.for(state))
            
            .background(model.colors.background.for(state).cornerRadius(model.layout.cornerRadius))
    }
    
    @ViewBuilder private var headerView: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                type: .oneLine,
                font: model.fonts.header,
                color: model.colors.header.for(state),
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerMarginHorizontal)
                .opacity(model.colors.content.for(state))
        }
    }
    
    @ViewBuilder private var footerView: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(limit: nil, alignment: .leading),
                font: model.fonts.footer,
                color: model.colors.footer.for(state),
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
    
    private static let rowTitles: [String] = [
        "January", "February", "March",
        "April", "May", "June",
        "July", "August", "September",
        "October", "November", "December"
    ]

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
