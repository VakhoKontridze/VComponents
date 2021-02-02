//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content horizontally
///
/// Component can be initialized with data, row titles, VPickableItem, or VPickableTitledItem
///
/// Best suited for 2 – 3 items
///
/// Model, state, header, footer, and disabled indexes can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// enum PickerRow: Int, VPickableTitledItem {
///     case red, green, blue
///
///     var pickerTitle: String {
///         switch self {
///         case .red: return "Red"
///         case .green: return "Green"
///         case .blue: return "Blue"
///         }
///     }
/// }
///
/// @State var selection: PickerRow = .red
///
/// var body: some View {
///     VSegmentedPicker(
///         selection: $selection,
///         headerTitle: "Lorem ipsum dolor sit amet",
///         footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
///     )
/// }
/// ```
///
public struct VSegmentedPicker<Data, RowContent>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        RowContent: View
{
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Binding private var selectedIndex: Int
    @State private var animatableSelectedIndex: Int?
    
    private let state: VSegmentedPickerState
    @State private var pressedIndex: Int?
    private func rowState(for index: Int) -> VSegmentedPickerRowState { .init(
        isEnabled: state.isEnabled && !disabledIndexes.contains(index),
        isPressed: pressedIndex == index
    ) }
    
    private let headerTitle: String?
    private let footerTitle: String?
    private let disabledIndexes: Set<Int>
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers: View Builder
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledIndexes = disabledIndexes
        self.data = data
        self.rowContent = rowContent
    }

    // MARK: Initializers: Row Titles
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
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
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            disabledIndexes: disabledIndexes,
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

    // MARK: Initializers: Pickable Item
    public init<Item>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Item>,
        state: VSegmentedPickerState = .enabled,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledItems: Set<Item> = .init(),
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
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
            data: .init(Item.allCases),
            rowContent: rowContent
        )
    }

    // MARK: Initializers: Pickable Titled Item
    public init<Item>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Item>,
        state: VSegmentedPickerState = .enabled,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledItems: Set<Item> = .init()
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
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
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
extension VSegmentedPicker {
    public var body: some View {
        performStateSets()
        
        return VStack(alignment: .leading, spacing: model.layout.headerFooterSpacing, content: {
            headerView
            pickerView
            footerView
        })
    }
    
    private var pickerView: some View {
        ZStack(alignment: .leading, content: {
            background
            indicator
            rows
            dividers
        })
            .frame(height: model.layout.height)
            .cornerRadius(model.layout.cornerRadius)
    }
    
    @ViewBuilder private var headerView: some View {
        if let headerTitle = headerTitle, !headerTitle.isEmpty {
            VText(
                type: .oneLine,
                font: model.fonts.header,
                color: model.colors.header.for(state),
                title: headerTitle
            )
                .padding(.horizontal, model.layout.headerFooterMarginHor)
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
                .padding(.horizontal, model.layout.headerFooterMarginHor)
                .opacity(model.colors.content.for(state))
        }
    }
    
    private var background: some View {
        model.colors.background.for(state)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(animatableSelectedIndex ?? selectedIndex))
            .foregroundColor(model.colors.indicator.for(state))
            .shadow(
                color: model.colors.indicatorShadow.for(state),
                radius: model.layout.indicatorShadowRadius,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    private var rows: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                VBaseButton(
                    isEnabled: state.isEnabled && !disabledIndexes.contains(i),
                    action: { setSelectedIndex(to: i) },
                    onPress: { pressedIndex = $0 ? i : nil },
                    content: {
                        rowContent(data[i])
                            .padding(model.layout.actualRowContentMargin)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            .opacity(contentOpacity(for: i))

                            .readSize(onChange: { rowWidth = $0.width })
                    }
                )
            })
        })
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                Spacer()

                if i <= data.count-2 {
                    Divider()
                        .opacity(dividerOpacity(for: i))
                        .frame(height: model.layout.dividerHeight)
                }
            })
        })
    }
}

// MARK:- State Sets
private extension VSegmentedPicker {
    func performStateSets() {
        DispatchQueue.main.async(execute: {
            setAnimatableSelectedIndex()
        })
    }
}

// MARK:- Actions
private extension VSegmentedPicker {
    func setSelectedIndex(to index: Int) {
        withAnimation(model.animations.selection, { animatableSelectedIndex = index })
        selectedIndex = index
    }
    
    func setAnimatableSelectedIndex() {
        if animatableSelectedIndex == nil || animatableSelectedIndex != selectedIndex {
            withAnimation(model.animations.selection, { animatableSelectedIndex = selectedIndex })
        }
    }
}

// MARK:- State Indication
private extension VSegmentedPicker {
    var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    func contentOpacity(for index: Int) -> Double {
        model.colors.content.for(rowState(for: index))
    }
    
    func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndex
        
        switch isBeforeIndicator {
        case false: return index - selectedIndex < 1 ? 0 : 1
        case true: return selectedIndex - index <= 1 ? 0 : 1
        }
    }
}

// MARK:- Preview
struct VSegmentedPicker_Previews: PreviewProvider {
    @State private static var selection: PickerRow = .red
    
    enum PickerRow: Int, VPickableTitledItem {
        case red, green, blue
    
        var pickerTitle: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
    }

    static var previews: some View {
        VSegmentedPicker(
            selection: $selection,
            headerTitle: "Lorem ipsum dolor sit amet",
            footerTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
            .padding(20)
    }
}
