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
/// Model, state, title, and description can be passed as parameters
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
///         title: "Lorem ipsum dolor sit amet",
///         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
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
    
    private let title: String?
    private let description: String?
    
    private let data: Data
    private let content: (Data.Element) -> Content
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        title: String? = nil,
        description: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.title = title
        self.description = description
        self.data = data
        self.content = content
    }

    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VWheelPickerState = .enabled,
        title: String? = nil,
        description: String? = nil,
        titles: [String]
    )
        where
            Data == Array<String>,
            Content == VBaseText
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            title: title,
            description: description,
            data: titles,
            content: { title in
                VBaseText(
                    title: title,
                    color: model.colors.textColor(state: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }

    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        title: String? = nil,
        description: String? = nil,
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
            title: title,
            description: description,
            data: .init(Item.allCases),
            content: content
        )
    }

    public init<Item>(
        model: VWheelPickerModel = .init(),
        selection: Binding<Item>,
        state: VWheelPickerState = .enabled,
        title: String? = nil,
        description: String? = nil
    )
        where
            Data == Array<Item>,
            Content == VBaseText,
            Item: VPickableTitledItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            title: title,
            description: description,
            data: .init(Item.allCases),
            content: { item in
                VBaseText(
                    title: item.pickerTitle,
                    color: model.colors.textColor(state: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }
}

// MARK:- Body
extension VWheelPicker {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleSpacing, content: {
            titleView
            pickerView
            descriptionView
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
            .opacity(model.colors.contentOpacity(state: state))
            
            .background(model.colors.backgroundColor(state: state).cornerRadius(model.layout.cornerRadius))
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VBaseText(
                title: title,
                color: model.colors.titleColor(state: state),
                font: model.fonts.title,
                type: .oneLine
            )
                .padding(.horizontal, model.layout.titleMarginHor)
                .opacity(model.colors.contentOpacity(state: state))
        }
    }
    
    @ViewBuilder private var descriptionView: some View {
        if let description = description, !description.isEmpty {
            VBaseText(
                title: description,
                color: model.colors.descriptionColor(state: state),
                font: model.fonts.description,
                type: .multiLine(limit: nil, alignment: .leading)
            )
                .padding(.horizontal, model.layout.titleMarginHor)
                .opacity(model.colors.contentOpacity(state: state))
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
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            titles: titles
        )
            .padding(20)
    }
}
