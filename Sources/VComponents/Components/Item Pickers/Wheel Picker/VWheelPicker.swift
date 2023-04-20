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
/// Best suited for `5`+ items.
///
/// UI Model, header, and footer can be passed as parameters.
///
/// There are four possible ways of initializing `VWheelPicker`.
///
/// [1] Data, Index, and Title/Content:
///
///     private enum SomeEnum: CaseIterable {
///         case red, green, blue
///     }
///
///     @State private var selectedIndex: Int = 0
///
///     var body: some View {
///         VWheelPicker(
///             selectedIndex: $selectedIndex,
///             data: SomeEnum.allCases,
///             title: { String(describing: $0) }
///         )
///     }
///
///     or
///
///     var body: some View {
///         VWheelPicker(
///             selectedIndex: $selectedIndex,
///             data: SomeEnum.allCases,
///             content: { (internalState, value) in Text(String(describing: value)) } // Requires custom state-management
///         )
///     }
///
/// [2] Data, Selection, and Title/Content:
///
///     private enum SomeEnum: CaseIterable {
///         case red, green, blue
///     }
///
///     @State private var selection: SomeEnum = .red
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection,
///             data: SomeEnum.allCases,
///             title: { String(describing: $0) }
///         )
///     }
///
///     or
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection,
///             data: SomeEnum.allCases,
///             content: { (internalState, value) in Text(String(describing: value)) } // Requires custom state-management
///         )
///     }
///
/// [3] `HashableEnumeration` API - Title/Content:
///
///     private enum SomeEnum: HashableEnumeration {
///         case red, green, blue
///     }
///
///     @State private var selection: SomeEnum = .red
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection,
///             title: { String(describing: $0) }
///         )
///     }
///
///     or
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection,
///             content: { (internalState, value) in Text(String(describing: value)) } // Requires custom state-management
///         )
///     }
///
/// [4] `StringRepresentableHashableEnumeration` API:
///
///     private enum SomeEnum: StringRepresentableHashableEnumeration {
///         case red, green, blue
///
///         var stringRepresentation: String {
///             String(describing: self)
///         }
///     }
///
///     @State private var selection: SomeEnum = .red
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection
///         )
///     }
///
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
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
    /// Initializes `VWheelPicker` with selected index, data, and row title.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data: data, title: title)
    }
    
    /// Initializes `VWheelPicker` with selected index, data, and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selectedIndex = selectedIndex
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .content(data: data, content: content)
    }
    
    // MARK: Initializers - Hashable
    /// Initializes `VWheelPicker` with selection value, data, and row title.
    public init<SelectionValue>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where
            Data == Array<SelectionValue>,
            Content == Never,
            SelectionValue: Hashable
    {
        self.uiModel = uiModel
        self._selectedIndex = Binding(
            get: { data.firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = data[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data: data, title: title)
    }
    
    /// Initializes `VWheelPicker` with selection value, data, and row content.
    public init<SelectionValue>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: Hashable
    {
        self.uiModel = uiModel
        self._selectedIndex = Binding(
            get: { data.firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = data[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .content(data: data, content: content)
    }
    
    // MARK: Initializers - Hashable Enumeration & String Representable Hashable Enumeration
    /// Initializes `VWheelPicker` with `HashableEnumeration` and row title.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        title: @escaping (T) -> String
    )
        where
            Data == Array<T>,
            Content == Never,
            T: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selectedIndex = Binding(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data: Array(T.allCases), title: title)
    }
    
    /// Initializes `VWheelPicker` with `HashableEnumeration` and row content.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, T) -> Content
    )
        where
            Data == Array<T>,
            T: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selectedIndex = Binding(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .content(data: Array(T.allCases), content: content)
    }
    
    // MARK: Initializers - String Representable Hashable Enumeration
    /// Initializes `VWheelPicker` with `StringRepresentableHashableEnumeration`.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<T>,
            Content == Never,
            T: StringRepresentableHashableEnumeration
    {
        self.uiModel = uiModel
        self._selectedIndex = Binding(
            get: { Array(T.allCases).firstIndex(of: selection.wrappedValue)! }, // Force-unwrap
            set: { selection.wrappedValue = Array(T.allCases)[$0] }
        )
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data:  Array(T.allCases), title: { $0.stringRepresentation })
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
        Picker(
            selection: $selectedIndex,
            content: rows,
            label: EmptyView.init
        )
        .pickerStyle(.wheel)
        .background(uiModel.colors.background.value(for: internalState).cornerRadius(uiModel.layout.cornerRadius))
    }
    
    @ViewBuilder private func rows() -> some View {
        switch content {
        case .title(let data, let title):
            ForEach(data.indices, id: \.self, content: { i in
                VText(
                    minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                    color: uiModel.colors.title.value(for: internalState),
                    font: uiModel.fonts.rows,
                    text: title(data[i])
                )
            })
            
        case .content(let data, let content):
            ForEach(data.indices, id: \.self, content: { i in
                content(internalState, data[i])
            })
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VWheelPicker_Previews: PreviewProvider {
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
        .ifLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    
    private static var rowTitles: [String] {
        [
            "January", "February", "March",
            "April", "May", "June",
            "July", "August", "September",
            "October", "November", "December"
        ].map { $0.pseudoRTL(languageDirection) }
    }
    private static var selection: String { rowTitles[rowTitles.count/2] }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: String = VWheelPicker_Previews.selection
        
        var body: some View {
            PreviewContainer(content: {
                VWheelPicker(
                    selection: $selection,
                    headerTitle: headerTitle,
                    footerTitle: footerTitle,
                    data: rowTitles,
                    title: { $0 }
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VWheelPicker(
                            selection: .constant(selection),
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            data: rowTitles,
                            title: { $0 }
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VWheelPicker(
                            selection: .constant(selection),
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            data: rowTitles,
                            title: { $0 }
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }
}
