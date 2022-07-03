//
//  VWheelPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Wheel Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a scrollable wheel.
///
/// Component can be initialized with data, row titles, `HashableEnumeration`, or `StringRepresentableHashableEnumeration`.
///
/// Best suited for `5`+ items.
///
/// UI Model, header, and footer can be passed as parameters.
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
public struct VWheelPicker<Data, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    private let uiModel: VWheelPickerUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VWheelPickerInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var selectedIndex: Int
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let content: VWheelPickerContent<Data, Content>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers - Index
    /// Initializes component with selected index, data, and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: data, content: content)
    }

    /// Initializes component with selected index and row titles.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<Never>,
            Content == Never
    {
        self.uiModel = uiModel
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable
    /// Initializes component with selection value, data, and row content.
    public init<SelectionValue>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: Hashable
    {
        self.uiModel = uiModel
        self._selectedIndex = .init(
            get: { data.firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = data[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: data, content: content)
    }
    
    /// Initializes component with selection value and row titles.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<String>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rowTitles: [String]
    )
        where
            Data == Array<Never>,
            Content == Never
    {
        self.uiModel = uiModel
        self._selectedIndex = .init(
            get: { rowTitles.firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = rowTitles[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable Enumeration & String Representable Hashable Enumeration
    /// Initializes component with `HashableEnumeration` and row content.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder content: @escaping (T) -> Content
    )
        where
            Data == Array<T>,
            T: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selectedIndex = .init(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .custom(data: Array(T.allCases), content: content)
    }
    
    /// Initializes component with `StringRepresentableHashableEnumeration`.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<Never>,
            Content == Never,
            T: StringRepresentableHashableEnumeration
    {
        self.uiModel = uiModel
        self._selectedIndex = .init(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // fatalError
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .titles(titles: Array(T.allCases).map { $0.stringRepresentation })
    }

    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: uiModel.layout.headerPickerFooterSpacing, content: {
            header
            picker
            footer
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, lineLimit: uiModel.layout.headerLineLimit),
                color: uiModel.colors.header.value(for: internalState),
                font: uiModel.fonts.header,
                text: headerTitle
            )
                .padding(.horizontal, uiModel.layout.headerMarginHorizontal)
        }
    }
    
    @ViewBuilder private var footer: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, lineLimit: uiModel.layout.footerLineLimit),
                color: uiModel.colors.footer.value(for: internalState),
                font: uiModel.fonts.footer,
                text: footerTitle
            )
                .padding(.horizontal, uiModel.layout.headerMarginHorizontal)
        }
    }
    
    private var picker: some View {
        Picker(
            selection: $selectedIndex,
            content: rows,
            label: EmptyView.init
        )
            .pickerStyle(.wheel)
            .disabled(!internalState.isEnabled) // Luckily, doesn't affect colors
            .background(uiModel.colors.background.value(for: internalState).cornerRadius(uiModel.layout.cornerRadius))
    }
    
    @ViewBuilder private func rows() -> some View {
        switch content {
        case .titles(let titles):
            ForEach(titles.indices, id: \.self, content: { i in
                VText(
                    color: uiModel.colors.title.value(for: internalState),
                    font: uiModel.fonts.rows,
                    text: titles[i]
                )
                    .tag(i)
            })
            
        case .custom(let data, let content):
            ForEach(data.indices, id: \.self, content: { i in
                content(data[i])
                    .opacity(uiModel.colors.customContentOpacities.value(for: internalState))
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
