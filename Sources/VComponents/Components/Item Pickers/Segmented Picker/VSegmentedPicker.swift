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
///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable {
///         case red, green, blue
///
///         var id: Int { rawValue }
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VSegmentedPicker(
///             selection: $selection,
///             data: RGBColor.allCases,
///             title: { String(describing: $0).capitalized }
///         )
///         .padding()
///     }
///
/// If you make selection conform to `CaseIterable` and `StringRepresentable`, you cal use the following API:
///
///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
///         case red, green, blue
///
///         var id: Int { rawValue }
///         var stringRepresentation: String { .init(describing: self).capitalized }
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VSegmentedPicker(selection: $selection)
///             .padding()
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIGestureBaseButton` support.
@available(watchOS, unavailable)
public struct VSegmentedPicker<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        Content: View
{
    // MARK: Properties
    private let uiModel: VSegmentedPickerUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var pressedValue: Data.Element?
    private var internalState: VSegmentedPickerInternalState { .init(isEnabled: isEnabled) }
    private var indicatorInternalState: VSegmentedPickerSelectionIndicatorInternalState {
        .init(
            isEnabled: isEnabled, // `isEnabled` check is required
            isPressed: pressedValue == selection
        )
    }
    private func rowInternalState(element: Data.Element) -> VSegmentedPickerRowInternalState {
        .init(
            isEnabled: isEnabled && !disabledValues.contains(element), // `isEnabled` check is required
            isSelected: selection == element,
            isPressed: pressedValue == element
        )
    }
    
    @Binding private var selection: Data.Element
    private var selectedIndex: Data.Index { data.firstIndex(of: selection)! } // Force-unwrap
    private var selectedIndexInt: Int { data.distance(from: data.startIndex, to: selectedIndex) }
    
    private let headerTitle: String?
    private let footerTitle: String?
    private let disabledValues: Set<Data.Element>

    private let data: Data

    private let id: KeyPath<Data.Element, ID>

    private let content: VSegmentedPickerContent<Data.Element, Content>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers
    /// Initializes `VSegmentedPicker` with selection, data, id, and row title.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<Data.Element> = [],
        data: Data,
        id: KeyPath<Data.Element, ID>,
        title: @escaping (Data.Element) -> String
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.data = data
        self.id = id
        self.content = .title(title: title)
    }
    
    /// Initializes `VSegmentedPicker` with selection, data, id, and row content.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<Data.Element> = [],
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.data = data
        self.id = id
        self.content = .content(content: content)
    }
    
    // MARK: Initializers - Identifiable
    /// Initializes `VSegmentedPicker` with selection, data, and row title.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<Data.Element> = [],
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.data = data
        self.id = \.id
        self.content = .title(title: title)
    }

    /// Initializes `VSegmentedPicker` with selection, data, and row content.
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<Data.Element> = [],
        data: Data,
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.data = data
        self.id = \.id
        self.content = .content(content: content)
    }
    
    // MARK: Initializers - String Representable
    /// Initializes `VSegmentedPicker` with `StringRepresentable` API.
    public init<T>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<T> = []
    )
        where
            Data == Array<T>,
            T: Identifiable & CaseIterable & StringRepresentable,
            ID == T.ID,
            Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.disabledValues = disabledValues
        self.data = Array(T.allCases)
        self.id = \.id
        self.content = .title(title: { $0.stringRepresentation })
    }
    
    // MARK: Body
    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: uiModel.layout.headerPickerAndFooterSpacing,
            content: {
                header
                picker
                footer
            }
        )
        .applyIf(uiModel.animations.appliesSelectionAnimation, transform: {
            $0
                .animation(uiModel.animations.selection, value: internalState)
                .animation(uiModel.animations.selection, value: selection)
        })
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.layout.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.layout.headerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.colors.headerTitleText.value(for: internalState))
                .font(uiModel.fonts.headerTitleText)

                .padding(.horizontal, uiModel.layout.headerAndFooterMarginHorizontal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.layout.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.layout.footerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.colors.footerTitleText.value(for: internalState))
                .font(uiModel.fonts.footerTitleText)

                .padding(.horizontal, uiModel.layout.headerAndFooterMarginHorizontal)
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
            .frame(width: rowWidth)
            .padding(uiModel.layout.indicatorMargin)
            .scaleEffect(indicatorScale, anchor: indicatorScaleAnchor)
            .offset(x: rowWidth * CGFloat(selectedIndexInt))
            .foregroundColor(uiModel.colors.indicator.value(for: indicatorInternalState))
            .shadow(
                color: uiModel.colors.indicatorShadow.value(for: indicatorInternalState),
                radius: uiModel.colors.indicatorShadowRadius,
                offset: uiModel.colors.indicatorShadowOffset
            )
    }
    
    @ViewBuilder private var rows: some View {
        switch content {
        case .title(let title):
            HStack(spacing: 0, content: {
                ForEach(data, id: id, content: { element in
                    SwiftUIGestureBaseButton(
                        onStateChange: { stateChangeHandler(element: element, gestureState: $0) },
                        label: {
                            Text(title(element))
                                .lineLimit(1)
                                .minimumScaleFactor(uiModel.layout.rowTitleTextMinimumScaleFactor)
                                .foregroundColor(uiModel.colors.rowTitleText.value(for: rowInternalState(element: element)))
                                .font(uiModel.fonts.rowTitleText)

                                .frame(maxWidth: .infinity)
                                .padding(uiModel.layout.indicatorMargin)
                                .padding(uiModel.layout.contentMargin)
                                .scaleEffect(rowContentScale, anchor: rowContentScaleAnchor(element: element))

                                .onSizeChange(perform: { rowWidth = $0.width })
                        }
                    )
                    .disabled(disabledValues.contains(element))
                })
            })
            
        case .content(let content):
            HStack(spacing: 0, content: {
                ForEach(data, id: id, content: { element in
                    SwiftUIGestureBaseButton(
                        onStateChange: { stateChangeHandler(element: element, gestureState: $0) },
                        label: {
                            content(rowInternalState(element: element), element)
                                .frame(maxWidth: .infinity)
                                .padding(uiModel.layout.indicatorMargin)
                                .padding(uiModel.layout.contentMargin)
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
            ForEach(0..<data.count, id: \.self, content: { i in
                Spacer()
                
                if i <= data.count-2 {
                    Rectangle()
                        .frame(size: uiModel.layout.dividerSize)
                        .foregroundColor(uiModel.colors.divider.value(for: internalState))
                        .opacity(dividerOpacity(for: i))
                }
            })
        })
    }
    
    // MARK: Actions
    private func stateChangeHandler(element: Data.Element, gestureState: GestureBaseButtonGestureState) {
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
        case data.startIndex: return .leading
        case data.endIndex: return .trailing
        default: return .center
        }
    }
    
    public var rowContentScale: CGFloat {
        switch selection {
        case pressedValue: return uiModel.animations.rowContentPressedScale
        case _: return 1
        }
    }
    
    public func rowContentScaleAnchor(element: Data.Element) -> UnitPoint {
        guard element == selection else { return .center }
        return indicatorScaleAnchor
    }
    
    private func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndexInt
        
        if isBeforeIndicator {
            return selectedIndexInt - index <= 1 ? 0 : 1
        } else {
            return index - selectedIndexInt < 1 ? 0 : 1
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
    
    private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
        case red, green, blue

        var id: Int { rawValue }
        
        var stringRepresentation: String { _stringRepresentation.pseudoRTL(languageDirection) }
        private var _stringRepresentation: String { .init(describing: self).capitalized }
    }
    private static var selection: RGBColor { .red }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: RGBColor = VSegmentedPicker_Previews.selection
        
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
                                    uiModel.colors.rowTitleText.selected = uiModel.colors.rowTitleText.pressedSelected
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
                                ForEach(Array(RGBColor.allCases), content: { element in
                                    Text(element.stringRepresentation)
                                        .tag(element)
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
                                ForEach(Array(RGBColor.allCases), content: { element in
                                    Text(element.stringRepresentation)
                                        .tag(element)
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
