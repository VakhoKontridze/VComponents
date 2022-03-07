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
/// Model, header, and footer can be passed as parameters.
///
/// Usage example:
///
///     @State var selection: String = "January"
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
///             selection: $selection,
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
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VWheelPickerInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var selectedIndex: Int
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let content: VWheelPickerContent<Data, RowContent>
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers - Index
    /// Initializes component with selected index, data, and row content.
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: data, rowContent: rowContent)
    }

    /// Initializes component with selected index and row titles.
    public init(
        model: VWheelPickerModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<Never>,
            RowContent == Never
    {
        self.model = model
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable
    /// Initializes component with selection value, data, and row content.
    public init<SelectionValue>(
        model: VWheelPickerModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: Hashable
    {
        self.model = model
        self._selectedIndex = .init(
            get: { data.firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = data[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: data, rowContent: rowContent)
    }
    
    /// Initializes component with selection value and row titles.
    public init(
        model: VWheelPickerModel = .init(),
        selection: Binding<String>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<Never>,
            RowContent == Never
    {
        self.model = model
        self._selectedIndex = .init(
            get: { rowTitles.firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = rowTitles[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Pickable Enumeration & Pickable Titled Enumeration
    /// Initializes component with `PickableEnumeration` and row content.
    public init<PickableItem>(
        model: VWheelPickerModel = .init(),
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder rowContent: @escaping (PickableItem) -> RowContent
    )
        where
            Data == Array<PickableItem>,
            PickableItem: PickableEnumeration
    {
        self.model = model
        self._selectedIndex = .init(
            get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: Array(PickableItem.allCases), rowContent: rowContent)
    }
    
    /// Initializes component with `PickableTitledEnumeration`.
    public init<PickableItem>(
        model: VWheelPickerModel = .init(),
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<Never>,
            RowContent == Never,
            PickableItem: PickableTitledEnumeration
    {
        self.model = model
        self._selectedIndex = .init(
            get: { Array(PickableItem.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(PickableItem.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: Array(PickableItem.allCases).map { $0.pickerTitle })
    }

    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.headerFooterSpacing, content: {
            header
            picker
            footer
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                color: model.colors.header.for(internalState),
                font: model.fonts.header,
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerMarginHorizontal)
        }
    }
    
    @ViewBuilder private var footer: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, limit: nil),
                color: model.colors.footer.for(internalState),
                font: model.fonts.footer,
                title: footerTitle
            )
                .padding(.horizontal, model.layout.headerMarginHorizontal)
        }
    }
    
    private var picker: some View {
        Picker(
            selection: $selectedIndex,
            content: rows,
            label: { EmptyView() }
        )
            .pickerStyle(.wheel)
            .disabled(!internalState.isEnabled) // Luckily, doesn't affect colors
            .background(model.colors.background.for(internalState).cornerRadius(model.layout.cornerRadius))
    }
    
    @ViewBuilder private func rows() -> some View {
        switch content {
        case .titles(let titles):
            ForEach(0..<titles.count, id: \.self, content: { i in
                VText(
                    color: model.colors.title.for(internalState),
                    font: model.fonts.rows,
                    title: titles[i]
                )
                    .tag(i)
            })
            
        case .custom(let data, let rowContent):
            ForEach(0..<data.count, id: \.self, content: { i in
                rowContent(data[i])
                    .opacity(model.colors.customContentOpacities.for(internalState))
                    .tag(i)
            })
        }
    }
}

// MARK: - Preview
struct VWheelPicker_Previews: PreviewProvider {
    @State private static var selection: String = rowTitles.first!
    
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
            selection: $selection,
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            rowTitles: rowTitles
        )
            .padding(20)
    }
}
