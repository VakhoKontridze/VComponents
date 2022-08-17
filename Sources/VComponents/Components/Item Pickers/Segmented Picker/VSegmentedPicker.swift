//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI
import VCore

// MARK: - V Segmented Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content horizontally.
///
/// Component can be initialized with data, row titles, or `HashableEnumeration`/`StringRepresentableHashableEnumeration`.
///
/// Best suited for `2` – `3` items.
///
/// UI Model, header, footer, and disabled indexes can be passed as parameters.
///
///     enum PickerRow: Int, StringRepresentableHashableEnumeration {
///         case red, green, blue
///
///         var stringRepresentation: String {
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
public struct VSegmentedPicker<Data, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    private let uiModel: VSegmentedPickerUIModel
    
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
    
    private let content: VSegmentedPickerContent<Data, Content>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers - Index
    /// Initializes component with selected index, data, and row content.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: data, content: content)
    }

    /// Initializes component with selected index and row titles.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable
    /// Initializes component with selection value, data, and row content.
    public init<SelectionValue>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: data, content: content)
    }
    
    /// Initializes component with selection value and row titles.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<String>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: rowTitles)
    }
    
    // MARK: Initializers - Hashable Enumeration & String Representable Hashable Enumeration
    /// Initializes component with `HashableEnumeration` and row content.
    public init<T>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
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
        self.disabledIndexes = disabledIndexes
        self.content = .custom(data: Array(T.allCases), content: content)
    }
    
    /// Initializes component with `StringRepresentableHashableEnumeration`.
    public init<T>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = []
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
        self.disabledIndexes = disabledIndexes
        self.content = .titles(titles: Array(T.allCases).map { $0.stringRepresentation })
    }
    
    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: uiModel.layout.headerPickerFooterSpacing, content: {
            header
            picker
            footer
        })
            .animation(uiModel.animations.selection, value: internalState)
            .animation(uiModel.animations.selection, value: selectedIndex)
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, lineLimit: uiModel.layout.headerLineLimit),
                color: uiModel.colors.header.value(for: internalState),
                font: uiModel.fonts.header,
                text: headerTitle
            )
                .padding(.horizontal, uiModel.layout.headerFooterMarginHorizontal)
        }
    }
    
    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            VText(
                type: .multiLine(alignment: .leading, lineLimit: uiModel.layout.footerLineLimit),
                color: uiModel.colors.footer.value(for: internalState),
                font: uiModel.fonts.footer,
                text: footerTitle
            )
                .padding(.horizontal, uiModel.layout.headerFooterMarginHorizontal)
        }
    }
    
    private var picker: some View {
        ZStack(alignment: .leading, content: {
            pickerBackground
            indicator
            rows
            dividers
        })
            .frame(height: uiModel.layout.height)
            .cornerRadius(uiModel.layout.cornerRadius)
    }
    
    private var pickerBackground: some View {
        uiModel.colors.background.value(for: internalState)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.indicatorCornerRadius)
            .padding(uiModel.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selectedIndex))
            .foregroundColor(uiModel.colors.indicator.value(for: internalState))
            .shadow(
                color: uiModel.colors.indicatorShadow.value(for: internalState),
                radius: uiModel.layout.indicatorShadowRadius,
                x: uiModel.layout.indicatorShadowOffsetX,
                y: uiModel.layout.indicatorShadowOffsetY
            )
    }
    
    @ViewBuilder private var rows: some View {
        switch content {
        case .titles(let titles):
            HStack(spacing: 0, content: {
                ForEach(titles.indices, id: \.self, content: { i in
                    SwiftUIBaseButton(
                        gesture: { gestureHandler(i: i, gestureState: $0) },
                        label: {
                            VText(
                                minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                                color: uiModel.colors.title.value(for: rowState(for: i)),
                                font: uiModel.fonts.rows,
                                text: titles[i]
                            )
                                .padding(uiModel.layout.indicatorMargin)
                                .padding(uiModel.layout.contentMargin)
                                .frame(maxWidth: .infinity)

                                .readSize(onChange: { rowWidth = $0.width })
                        }
                    )
                        .disabled(!internalState.isEnabled || disabledIndexes.contains(i))
                })
            })
            
        case .custom(let data, let content):
            HStack(spacing: 0, content: {
                ForEach(data.indices, id: \.self, content: { i in
                    SwiftUIBaseButton(
                        gesture: { gestureHandler(i: i, gestureState: $0) },
                        label: {
                            content(data[i])
                                .padding(uiModel.layout.indicatorMargin)
                                .padding(uiModel.layout.contentMargin)
                                .frame(maxWidth: .infinity)

                                .opacity(uiModel.colors.customContentOpacities.value(for: rowState(for: i)))

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
                        .frame(size: uiModel.layout.dividerSize)
                        .foregroundColor(uiModel.colors.divider.value(for: internalState))
                        .opacity(dividerOpacity(for: i))
                }
            })
        })
    }
    
    // MARK: Actions
    private func gestureHandler(i: Int, gestureState: BaseButtonGestureState) {
        pressedIndex = gestureState.isPressed ? i : nil
        if gestureState.isClicked { selectedIndex = i }
    }

    // MARK: State Indication
    private var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return uiModel.layout.indicatorPressedScale
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
    enum PickerRow: Int, StringRepresentableHashableEnumeration {
        case red, green, blue
    
        var stringRepresentation: String {
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
