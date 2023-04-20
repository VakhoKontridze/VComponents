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
/// There are three possible ways of initializing `VWheelPicker`.
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
///         VWheelPicker(
///             selection: $selection,
///             data: RGBColor.allCases,
///             title: { String(describing: $0) }
///         )
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
///         VWheelPicker(
///             selection: $selection,
///             title: { String(describing: $0) }
///         )
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
///         VWheelPicker(
///             selection: $selection
///         )
///     }
///
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VWheelPicker<SelectionValue, Content>: View
    where
        SelectionValue: Hashable,
        Content: View
{
    // MARK: Properties
    private let uiModel: VWheelPickerUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VWheelPickerInternalState { .init(isEnabled: isEnabled) }
    
    @Binding private var selection: SelectionValue
    
    private let headerTitle: String?
    private let footerTitle: String?
    
    private let content: VWheelPickerContent<SelectionValue, Content>
    
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers
    /// Initializes `VWheelPicker` with selection value, data, and row title.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: [SelectionValue],
        title: @escaping (SelectionValue) -> String
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data: data, title: title)
    }
    
    /// Initializes `VWheelPicker` with selection value, data, and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: [SelectionValue],
        @ViewBuilder content: @escaping (VWheelPickerInternalState, SelectionValue) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .content(data: data, content: content)
    }
    
    // MARK: Initializers - Hashable Enumeration
    /// Initializes `VWheelPicker` with `HashableEnumeration` and row title.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
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
        self.content = .title(data: Array(SelectionValue.allCases), title: title)
    }
    
    /// Initializes `VWheelPicker` with `HashableEnumeration` and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, SelectionValue) -> Content
    )
        where SelectionValue: HashableEnumeration
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .content(data: Array(SelectionValue.allCases), content: content)
    }
    
    // MARK: Initializers - String Representable Hashable Enumeration
    /// Initializes `VWheelPicker` with `StringRepresentableHashableEnumeration`.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Content == Never,
            SelectionValue: StringRepresentableHashableEnumeration
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.content = .title(data: Array(SelectionValue.allCases), title: { $0.stringRepresentation })
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
            selection: $selection,
            content: rows,
            label: EmptyView.init
        )
        .pickerStyle(.wheel)
        .background(uiModel.colors.background.value(for: internalState).cornerRadius(uiModel.layout.cornerRadius))
    }
    
    @ViewBuilder private func rows() -> some View {
        switch content {
        case .title(let data, let title):
            ForEach(data, id: \.hashValue, content: { element in
                VText(
                    minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                    color: uiModel.colors.title.value(for: internalState),
                    font: uiModel.fonts.rows,
                    text: title(element)
                )
            })
            
        case .content(let data, let content):
            ForEach(data, id: \.hashValue, content: { element in
                content(internalState, element)
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
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
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
