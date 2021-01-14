//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content horizontally
public struct VSegmentedPicker<Data, RowContent>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        RowContent: View
{
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Binding private var selectedIndex: Int
    
    private let state: VSegmentedPickerState
    @State private var pressedIndex: Int? = nil
    private func rowState(for index: Int) -> VSegmentedPickerRowState { .init(
        isEnabled: !state.isDisabled && !disabledIndexes.contains(index),
        isPressed: pressedIndex == index
    ) }
    
    private let title: String?
    private let subtitle: String?
    private let disabledIndexes: Set<Int>
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    /// Initializes component with selected index, data, and row content
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var selectedIndex: Int = 0
    /// @State var data: [Color] = [.red, .green, .blue]
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         selectedIndex: $selectedIndex,
    ///         data: data,
    ///         rowContent: { color in
    ///             Image(systemName: "swift")
    ///                 .resizable()
    ///                 .frame(width: 15, height: 15)
    ///                 .foregroundColor(color)
    ///         }
    ///     )
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VSegmentedPickerModel = .init()
    /// @State var selectedIndex: Int = 0
    /// @State var state: VSegmentedPickerState = .enabled
    /// @State var disabledIndexes: Set<Int> = []
    /// @State var data: [Color] = [.red, .green, .blue]
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         model: model,
    ///         selectedIndex: $selectedIndex,
    ///         state: state,
    ///         title: "Lorem ipsum dolor sit amet",
    ///         subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///         disabledIndexes: disabledIndexes,
    ///         data: data,
    ///         rowContent: { color in
    ///             Image(systemName: "swift")
    ///                 .resizable()
    ///                 .frame(width: 15, height: 15)
    ///                 .foregroundColor(color)
    ///         }
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - selectedIndex: Index of the selected item
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - title: Title that describes purpose of picker
    ///   - subtitle: Subtitle that describes purpose of picker
    ///   - disabledIndexes: Indexes that disable selection
    ///   - data: Data that represents picker items
    ///   - rowContent: View that represents picker item
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
        data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.title = title
        self.subtitle = subtitle
        self.disabledIndexes = disabledIndexes
        self.data = data
        self.rowContent = rowContent
    }

    /// Initializes component with selected index and titles
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var selectedIndex: Int = 0
    /// @State var titles: [String] = ["Red", "Green", "Blue"]
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         selectedIndex: $selectedIndex,
    ///         titles: titles
    ///     )
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VSegmentedPickerModel = .init()
    /// @State var selectedIndex: Int = 0
    /// @State var state: VSegmentedPickerState = .enabled
    /// @State var disabledIndexes: Set<Int> = []
    /// @State var titles: [String] = ["Red", "Green", "Blue"]
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         model: model,
    ///         selectedIndex: $selectedIndex,
    ///         state: state,
    ///         title: "Lorem ipsum dolor sit amet",
    ///         subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///         disabledIndexes: disabledIndexes,
    ///         titles: titles
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - selectedIndex: Index of the selected item
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - title: Title that describes purpose of picker
    ///   - subtitle: Subtitle that describes purpose of picker
    ///   - disabledIndexes: Indexes that disable selection
    ///   - titles: Titles that represents picker items
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
        titles: [String]
    )
        where
            Data == Array<String>,
            RowContent == VBaseTitle
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: disabledIndexes,
            data: titles,
            rowContent: { title in
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(for: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }

    /// Initializes component with selected item and row content
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// enum PickerRow: Int, CaseIterable, VPickerEnumerableItem {
    ///     case red, green, blue
    ///
    ///     var color: Color {
    ///         switch self {
    ///         case .red: return .red
    ///         case .green: return .green
    ///         case .blue: return .blue
    ///         }
    ///     }
    /// }
    ///
    /// @State var selection: PickerRow = .red
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         selection: $selection,
    ///         rowContent: { item in
    ///             Image(systemName: "swift")
    ///                 .resizable()
    ///                 .frame(width: 15, height: 15)
    ///                 .foregroundColor(item.color)
    ///         }
    ///     )
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// enum PickerRow: Int, CaseIterable, VPickerEnumerableItem {
    ///     case red, green, blue
    ///
    ///     var color: Color {
    ///         switch self {
    ///         case .red: return .red
    ///         case .green: return .green
    ///         case .blue: return .blue
    ///         }
    ///     }
    /// }
    ///
    /// let model: VSegmentedPickerModel = .init()
    /// @State var selection: PickerRow = .red
    /// @State var state: VSegmentedPickerState = .enabled
    /// @State var disabledItems: Set<PickerRow> = []
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         model: model,
    ///         selection: $selection,
    ///         state: state,
    ///         title: "Lorem ipsum dolor sit amet",
    ///         subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///         disabledItems: disabledItems,
    ///         rowContent: { item in
    ///             Image(systemName: "swift")
    ///                 .resizable()
    ///                 .frame(width: 15, height: 15)
    ///                 .foregroundColor(item.color)
    ///         }
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - selection: Selected item
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - title: Title that describes purpose of picker
    ///   - subtitle: Subtitle that describes purpose of picker
    ///   - disabledItems: Items that disable seelction
    ///   - rowContent: View that represents picker item
    public init<Option>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Option>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledItems: Set<Option> = .init(),
        @ViewBuilder rowContent: @escaping (Option) -> RowContent
    )
        where
            Data == Array<Option>,
            Option: VPickerEnumerableItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Option(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
            data: .init(Option.allCases),
            rowContent: rowContent
        )
    }
    
    /// Initializes component with selected item
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// enum PickerRow: Int, CaseIterable, VPickerTitledEnumerableItem {
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
    ///     VSegmentedPicker(selection: $selection)
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// enum PickerRow: Int, CaseIterable, VPickerTitledEnumerableItem {
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
    /// let model: VSegmentedPickerModel = .init()
    /// @State var selection: PickerRow = .red
    /// @State var state: VSegmentedPickerState = .enabled
    /// @State var disabledItems: Set<PickerRow> = []
    ///
    /// var body: some View {
    ///     VSegmentedPicker(
    ///         model: model,
    ///         selection: $selection,
    ///         state: state,
    ///         title: "Lorem ipsum dolor sit amet",
    ///         subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///         disabledItems: disabledItems
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - selection: Selected item
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - title: Title that describes purpose of picker
    ///   - subtitle: Subtitle that describes purpose of picker
    ///   - disabledItems: Items that disable seelction
    public init<Option>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Option>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledItems: Set<Option> = .init()
    )
        where
            Data == Array<Option>,
            RowContent == VBaseTitle,
            Option: VPickerTitledEnumerableItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Option(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
            data: .init(Option.allCases),
            rowContent: { option in
                VBaseTitle(
                    title: option.pickerTitle,
                    color: model.colors.textColor(for: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }
}

// MARK:- Body
extension VSegmentedPicker {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleSpacing, content: {
            titleView
            pickerView
            subtitleView
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
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VBaseTitle(
                title: title,
                color: model.colors.titleColor(for: state),
                font: model.fonts.title,
                type: .oneLine
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    @ViewBuilder private var subtitleView: some View {
        if let subtitle = subtitle, !subtitle.isEmpty {
            VBaseTitle(
                title: subtitle,
                color: model.colors.subtitleColor(for: state),
                font: model.fonts.subtitle,
                type: .multiLine(limit: nil, alignment: .leading)
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    private var background: some View {
        model.colors.backgroundColor(for: state)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selectedIndex))
            .animation(model.animation)
            
            .foregroundColor(model.colors.indicatorColor(for: state))
            .shadow(
                color: model.colors.indicatorShadowColor(for: state),
                radius: model.layout.indicatorShadowRadius,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    private var rows: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                VBaseButton(
                    isDisabled: state.isDisabled || disabledIndexes.contains(i),
                    action: { selectedIndex = i },
                    onPress: { pressedIndex = $0 ? i : nil },
                    content: {
                        rowContent(data[i])
                            .padding(model.layout.actualRowContentMargin)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            .font(model.fonts.rows)
                            .opacity(foregroundOpacity(for: i))

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

// MARK:- State Indication
private extension VSegmentedPicker {
    var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    func foregroundOpacity(for index: Int) -> Double {
        model.colors.foregroundOpacity(state: rowState(for: index))
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
    @State private static var selection: Options = .one
    private enum Options: Int, CaseIterable, VPickerTitledEnumerableItem {
        case one
        case two
        case three

        var pickerTitle: String {
            switch self {
            case .one: return "One"
            case .two: return "Two"
            case .three: return "Three"
            }
        }
    }

    static var previews: some View {
        VSegmentedPicker(selection: $selection)
            .padding(20)
    }
}
