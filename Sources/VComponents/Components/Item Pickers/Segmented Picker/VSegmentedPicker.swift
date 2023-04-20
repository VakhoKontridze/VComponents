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
/// Best suited for `2` – `3` items.
///
/// UI Model, header, footer, and disabled values can be passed as parameters.
///
/// There are three possible ways of initializing `VSegmentedPicker`.
///
/// [1] Data, Selection, and Title/Content:
///
///     private enum RGBColor: CaseIterable {
///         case red, green, blue
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VSegmentedPicker(
///             selection: $selection,
///             data: RGBColor.allCases,
///             title: { String(describing: $0) }
///         )
///         .padding()
///     }
///
/// [2] `HashableEnumeration` API - Title/Content:
///
///     private enum RGBColor: HashableEnumeration {
///         case red, green, blue
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VSegmentedPicker(
///             selection: $selection,
///             title: { String(describing: $0) }
///         )
///         .padding()
///     }
///
/// [3] `StringRepresentableHashableEnumeration` API:
///
///     private enum RGBColor: StringRepresentableHashableEnumeration {
///         case red, green, blue
///
///         var stringRepresentation: String {
///             String(describing: self)
///         }
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VSegmentedPicker(
///             selection: $selection
///         )
///         .padding()
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support.
@available(watchOS, unavailable)
public struct VSegmentedPicker<SelectionValue, Content>: View
    where
        SelectionValue: Hashable,
        Content: View
{
    // MARK: Properties
    private let uiModel: VSegmentedPickerUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var pressedValue: SelectionValue?
    private var internalState: VSegmentedPickerInternalState { .init(isEnabled: isEnabled) }
    private var indicatorInternalState: VSegmentedPickerSelectionIndicatorInternalState {
        .init(
            isEnabled: isEnabled, // `isEnabled` check is required
            isPressed: pressedValue == selection
        )
    }
    private func rowInternalState(element: SelectionValue) -> VSegmentedPickerRowInternalState {
        .init(
            isEnabled: isEnabled && !disabledValues.contains(element), // `isEnabled` check is required
            isSelected: selection == element,
            isPressed: pressedValue == element
        )
    }
    
    @Binding private var selection: SelectionValue
    private var selectedIndex: Int { content.firstIndex(of: selection) }
    
    private let headerTitle: String?
    private let footerTitle: String?
    private let disabledValues: Set<SelectionValue>
    
    private let content: VSegmentedPickerContent<SelectionValue, Content>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers
    /// Initializes `VSegmentedPicker` with selection value, data, and row title.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        data: [SelectionValue],
        title: @escaping (SelectionValue) -> String
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.content = .title(data: data, title: title)
    }
    
    /// Initializes `VSegmentedPicker` with selection value, data, and row content.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        data: [SelectionValue],
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, SelectionValue) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.content = .content(data: data, content: content)
    }
    
    // MARK: Initializers - Hashable Enumeration
    /// Initializes `VSegmentedPicker` with `HashableEnumeration` and row title.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        title: @escaping (SelectionValue) -> String
    )
        where
            Content == Never,
            SelectionValue: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.content = .title(data: Array(SelectionValue.allCases), title: title)
    }
    
    /// Initializes `VSegmentedPicker` with `HashableEnumeration` and row content.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, SelectionValue) -> Content
    )
        where SelectionValue: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.content = .content(data: Array(SelectionValue.allCases), content: content)
    }
    
    // MARK: Initializers - String Representable Hashable Enumeration
    /// Initializes `VSegmentedPicker` with `StringRepresentableHashableEnumeration`.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = []
    )
        where
            Content == Never,
            SelectionValue: StringRepresentableHashableEnumeration
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.content = .title(data: Array(SelectionValue.allCases), title: { $0.stringRepresentation })
    }
    
    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: uiModel.layout.headerPickerFooterSpacing, content: {
            header
            picker
            footer
        })
        .applyIf(uiModel.animations.appliesSelectionAnimation, transform: {
            $0
                .animation(uiModel.animations.selection, value: internalState)
                .animation(uiModel.animations.selection, value: selection)
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            VText(
                type: uiModel.layout.headerTextLineType,
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
                type: uiModel.layout.footerTextLineType,
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
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
            .background(uiModel.colors.background.value(for: internalState))
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.indicatorCornerRadius)
            .padding(uiModel.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale, anchor: indicatorScaleAnchor)
            .offset(x: rowWidth * CGFloat(selectedIndex))
            .foregroundColor(uiModel.colors.indicator.value(for: indicatorInternalState))
            .shadow(
                color: uiModel.colors.indicatorShadow.value(for: indicatorInternalState),
                radius: uiModel.colors.indicatorShadowRadius,
                offset: uiModel.colors.indicatorShadowOffset
            )
    }
    
    @ViewBuilder private var rows: some View {
        switch content {
        case .title(let data, let title):
            HStack(spacing: 0, content: {
                ForEach(data, id: \.hashValue, content: { element in
                    SwiftUIGestureBaseButton(
                        onStateChange: { stateChangeHandler(element: element, gestureState: $0) },
                        label: {
                            VText(
                                minimumScaleFactor: uiModel.layout.rowTitleMinimumScaleFactor,
                                color: uiModel.colors.rowTitle.value(for: rowInternalState(element: element)),
                                font: uiModel.fonts.rows,
                                text: title(element)
                            )
                            .padding(uiModel.layout.indicatorMargin)
                            .padding(uiModel.layout.contentMargin)
                            .frame(maxWidth: .infinity)
                            .scaleEffect(rowContentScale, anchor: rowContentScaleAnchor(element: element))
                            
                            .onSizeChange(perform: { rowWidth = $0.width })
                        }
                    )
                    .disabled(disabledValues.contains(element))
                })
            })
            
        case .content(let data, let content):
            HStack(spacing: 0, content: {
                ForEach(data, id: \.hashValue, content: { element in
                    SwiftUIGestureBaseButton(
                        onStateChange: { stateChangeHandler(element: element, gestureState: $0) },
                        label: {
                            content(rowInternalState(element: element), element)
                                .padding(uiModel.layout.indicatorMargin)
                                .padding(uiModel.layout.contentMargin)
                                .frame(maxWidth: .infinity)
                                .scaleEffect(rowContentScale, anchor: rowContentScaleAnchor(element: element))
                            
                                .onSizeChange(perform: { rowWidth = $0.width })
                        }
                    )
                    .disabled(disabledValues.contains(element))
                })
            })
        }
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(content.indices, id: \.self, content: { i in
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
    private func stateChangeHandler(element: SelectionValue, gestureState: GestureBaseButtonGestureState) {
        // Doesn't work as modifier
        // Not affected by animation flag
        withAnimation(uiModel.animations.indicatorPress, {
            pressedValue = gestureState.isPressed ? element : nil
        })
        
        if gestureState.isClicked {
            playHapticEffect()
            selection = element
        }
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playSelection()
#endif
    }
    
    // MARK: State Indication
    private var indicatorScale: CGFloat {
        switch selection {
        case pressedValue: return uiModel.animations.indicatorPressedScale
        case _: return 1
        }
    }
    
    public var indicatorScaleAnchor: UnitPoint {
        switch selectedIndex {
        case 0: return .leading
        case content.count-1: return .trailing
        default: return .center
        }
    }
    
    public var rowContentScale: CGFloat {
        switch selection {
        case pressedValue: return uiModel.animations.rowContentPressedScale
        case _: return 1
        }
    }
    
    public func rowContentScaleAnchor(element: SelectionValue) -> UnitPoint {
        guard element == selection else { return .center }
        return indicatorScaleAnchor
    }
    
    private func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndex
        
        if isBeforeIndicator {
            return selectedIndex - index <= 1 ? 0 : 1
        } else {
            return index - selectedIndex < 1 ? 0 : 1
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VSegmentedPicker_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    
    private enum PickerRow: Int, StringRepresentableHashableEnumeration {
        case red, green, blue
        
        var stringRepresentation: String { _stringRepresentation.pseudoRTL(languageDirection) }
        private var _stringRepresentation: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
    }
    private static var selection: PickerRow { .red }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: PickerRow = VSegmentedPicker_Previews.selection
        
        var body: some View {
            PreviewContainer(content: {
                VSegmentedPicker(
                    selection: $selection,
                    headerTitle: headerTitle,
                    footerTitle: footerTitle
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(
                embeddedInScrollViewOnPlatforms: [.macOS],
                content: {
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            VSegmentedPicker(
                                selection: .constant(selection),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle
                            )
                        }
                    )
                    
                    // Color is also applied to other rows.
                    // Scale effect cannot be shown.
                    PreviewRow(
                        axis: .vertical,
                        title: "Pressed (Row)",
                        content: {
                            VSegmentedPicker(
                                uiModel: {
                                    var uiModel: VSegmentedPickerUIModel = .init()
                                    uiModel.colors.rowTitle.selected = uiModel.colors.rowTitle.pressedSelected
                                    return uiModel
                                }(),
                                selection: .constant(selection),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle
                            )
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Disabled",
                        content: {
                            VSegmentedPicker(
                                selection: .constant(selection),
                                headerTitle: headerTitle,
                                footerTitle: footerTitle
                            )
                            .disabled(true)
                        }
                    )
                    
                    PreviewSectionHeader("Native")
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Enabled",
                        content: {
                            Picker("", selection: .constant(selection), content: {
                                ForEach(PickerRow.allCases.enumeratedArray(), id: \.element, content: { (i, row) in
                                    Text(row.stringRepresentation)
                                })
                            })
                            .labelsHidden()
                            .pickerStyle(.segmented)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        title: "Disabled",
                        content: {
                            Picker("", selection: .constant(selection), content: {
                                ForEach(PickerRow.allCases.enumeratedArray(), id: \.element, content: { (i, row) in
                                    Text(row.stringRepresentation)
                                })
                            })
                            .labelsHidden()
                            .pickerStyle(.segmented)
                            .disabled(true)
                        }
                    )
                }
            )
        }
    }
}
