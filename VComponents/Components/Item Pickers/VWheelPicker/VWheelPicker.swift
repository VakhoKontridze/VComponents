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
/// Component ca be initialized with data, VPickableItem, or VPickableTitledItem
///
/// Model, state, header, and footer can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var selectedIndex: Int = 7
///
/// let titles: [String] = [
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
///         titles: titles
///     )
///         .padding(20)
/// }
/// ```
///
public struct VWheelPicker<Data, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    private let model: VWheelPickerModel
    
    @Binding private var selectedIndex: Int
    private let state: VWheelPickerState
    
    private let header: String?
    private let footer: String?
    
    private let data: Data
    private let content: (Data.Element) -> Content
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.header = header
        self.footer = footer
        self.data = data
        self.content = content
    }

    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        titles: [String]
    )
        where
            Data == Array<String>,
            Content == VText
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            header: header,
            footer: footer,
            data: titles,
            content: { title in
                VText(
                    type: .oneLine,
                    font: model.fonts.rows,
                    color: model.colors.textContent.for(state),
                    title: title
                )
            }
        )
    }

    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
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
            content: content
        )
    }

    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        header: String? = nil,
        footer: String? = nil
    )
        where
            Data == Array<Item>,
            Content == VText,
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
            content: { item in
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
                content(data[i])
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
    
    private static let titles: [String] = [
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
            titles: titles
        )
            .padding(20)
    }
}
