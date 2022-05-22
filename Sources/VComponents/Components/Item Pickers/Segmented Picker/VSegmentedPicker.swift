//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK: - V Segmented Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content horizontally.
///
/// Component can be initialized with data, row titles, or `PickableEnumeration`/`PickableTitledEnumeration`.
///
/// Best suited for `2` – `3` items.
///
/// Model, header, footer, and disabled indexes can be passed as parameters.
///
/// Usage example:
///
///     enum PickerRow: Int, PickableTitledEnumeration {
///         case red, green, blue
///
///         var pickerTitle: String {
///             switch self {
///             case .red: return "Red"
///             case .green: return "Green"
///             case .blue: return "Blue"
///             }
///         }
///     }
///
///     @State var selection: PickerRow = .red
///
///     var body: some View {
///         VSegmentedPicker(
///             selection: $selection,
///             headerTitle: "Lorem ipsum dolor sit amet",
///             footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
///         )
///     }
///
public struct VSegmentedPicker<Data, RowContent>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        RowContent: View
{
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var pressedIndex: Int?
    private var internalState: VSegmentedPickerInternalState { .init(isEnabled: isEnabled) }
    private func rowState(for index: Int) -> VSegmentedPickerRowInternalState {
        .init(
            isEnabled: internalState.isEnabled && !disabledIndexes.contains(index),
            isPressed: pressedIndex == index
        )
    }
    
    @Binding private var selectedIndex: Int
    
    private let headerTitle: String?
    private let footerTitle: String?
    private let disabledIndexes: Set<Int>
    
    private let content: VSegmentedPickerContent<Data, RowContent>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers - Index
    /// Initializes component with selected index, data, and row content.
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: data, rowContent: rowContent)
    }

    /// Initializes component with selected index and row titles.
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable
    /// Initializes component with selection value, data, and row content.
    public init<SelectionValue>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: data, rowContent: rowContent)
    }
    
    /// Initializes component with selection value and row titles.
    public init(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<String>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Pickable Enumeration & Pickable Titled Enumeration
    /// Initializes component with `PickableEnumeration` and row content.
    public init<PickableItem>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: Array(PickableItem.allCases), rowContent: rowContent)
    }
    
    /// Initializes component with `PickableTitledEnumeration`.
    public init<PickableItem>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<PickableItem>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = []
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: Array(PickableItem.allCases).map { $0.pickerTitle })
    }
    
    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.headerPickerFooterSpacing, content: {
            header
            picker
            footer
        })
            .animation(model.animations.selection, value: internalState)
            .animation(model.animations.selection, value: selectedIndex)
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, limit: model.layout.headerLineLimit),
                color: model.colors.header.for(internalState),
                font: model.fonts.header,
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerFooterMarginHorizontal)
        }
    }
    
    @ViewBuilder private var footer: some View {
        if let footerTitle = footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, limit: model.layout.footerLineLimit),
                color: model.colors.footer.for(internalState),
                font: model.fonts.footer,
                title: footerTitle
            )
                .padding(.horizontal, model.layout.headerFooterMarginHorizontal)
        }
    }
    
    private var picker: some View {
        ZStack(alignment: .leading, content: {
            pickerBackground
            indicator
            rows
            dividers
        })
            .frame(height: model.layout.height)
            .cornerRadius(model.layout.cornerRadius)
    }
    
    private var pickerBackground: some View {
        model.colors.background.for(internalState)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selectedIndex))
            .foregroundColor(model.colors.indicator.for(internalState))
            .shadow(
                color: model.colors.indicatorShadow.for(internalState),
                radius: model.layout.indicatorShadowRadius,
                x: model.layout.indicatorShadowOffsetX,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    @ViewBuilder private var rows: some View {
        switch content {
        case .titles(let titles):
            HStack(spacing: 0, content: {
                ForEach(titles.indices, id: \.self, content: { i in
                    VBaseButton(
                        gesture: { gestureHandler(i: i, gestureState: $0) },
                        label: {
                            VText(
                                color: model.colors.title.for(rowState(for: i)),
                                font: model.fonts.rows,
                                title: titles[i]
                            )
                                .padding(model.layout.indicatorMargin)
                                .padding(model.layout.rowContentMargin)
                                .frame(maxWidth: .infinity)

                                .readSize(onChange: { rowWidth = $0.width })
                        }
                    )
                        .disabled(!internalState.isEnabled || disabledIndexes.contains(i))
                })
            })
            
        case .custom(let data, let rowContent):
            HStack(spacing: 0, content: {
                ForEach(data.indices, id: \.self, content: { i in
                    VBaseButton(
                        gesture: { gestureHandler(i: i, gestureState: $0) },
                        label: {
                            rowContent(data[i])
                                .padding(model.layout.indicatorMargin)
                                .padding(model.layout.rowContentMargin)
                                .frame(maxWidth: .infinity)

                                .opacity(model.colors.customContentOpacities.for(rowState(for: i)))

                                .readSize(onChange: { rowWidth = $0.width })
                        }
                    )
                        .disabled(!internalState.isEnabled || disabledIndexes.contains(i))
                })
            })
        }
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<content.count, id: \.self, content: { i in
                Spacer()

                if i <= content.count-2 {
                    Rectangle()
                        .frame(size: model.layout.dividerSize)
                        .foregroundColor(model.colors.divider.for(internalState))
                        .opacity(dividerOpacity(for: i))
                }
            })
        })
    }
    
    // MARK: Actions
    private func gestureHandler(i: Int, gestureState: VBaseButtonGestureState) {
        pressedIndex = gestureState.isPressed ? i : nil
        if gestureState.isClicked { selectedIndex = i }
    }

    // MARK: State Indication
    private var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    private func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndex
        
        switch isBeforeIndicator {
        case false: return index - selectedIndex < 1 ? 0 : 1
        case true: return selectedIndex - index <= 1 ? 0 : 1
        }
    }
}

// MARK: - Preview
struct VSegmentedPicker_Previews: PreviewProvider {
    enum PickerRow: Int, PickableTitledEnumeration {
        case red, green, blue
    
        var pickerTitle: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
    }
    
    @State private static var selection: PickerRow = .red

    static var previews: some View {
        VSegmentedPicker(
            selection: $selection,
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
            .padding(20)
    }
}
