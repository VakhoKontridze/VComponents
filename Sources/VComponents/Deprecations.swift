//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Stretched Button
@available(tvOS, unavailable)
extension VStretchedButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "iconAndTitleTextSpacing")
    public var iconTitleSpacing: CGFloat {
        get { iconAndTitleTextSpacing }
        set { iconAndTitleTextSpacing = newValue }
    }
}

@available(tvOS, unavailable)
extension VStretchedButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
extension VStretchedButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Loading Stretched Button
@available(tvOS, unavailable)
extension VLoadingStretchedButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "iconAndTitleTextSpacing")
    public var iconTitleSpacing: CGFloat {
        get { iconAndTitleTextSpacing }
        set { iconAndTitleTextSpacing = newValue }
    }

    @available(*, deprecated, renamed: "labelAndSpinnerSpacing")
    public var labelSpinnerSpacing: CGFloat {
        get { labelAndSpinnerSpacing }
        set { labelAndSpinnerSpacing = newValue }
    }
}

@available(tvOS, unavailable)
extension VLoadingStretchedButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
extension VLoadingStretchedButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Capsule Button
@available(tvOS, unavailable)
extension VCapsuleButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "iconAndTitleTextSpacing")
    public var iconTitleSpacing: CGFloat {
        get { iconAndTitleTextSpacing }
        set { iconAndTitleTextSpacing = newValue }
    }
}

@available(tvOS, unavailable)
extension VCapsuleButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
extension VCapsuleButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Rounded Caption Button
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension VRoundedCaptionButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleCaptionTextMinimumScaleFactor")
    public var titleCaptionMinimumScaleFactor: CGFloat {
        get { titleCaptionTextMinimumScaleFactor }
        set { titleCaptionTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "rectangleAndCaptionSpacing")
    public var rectangleCaptionSpacing: CGFloat {
        get { rectangleAndCaptionSpacing }
        set { rectangleAndCaptionSpacing = newValue }
    }

    @available(*, deprecated, renamed: "iconCaptionAndTitleCaptionTextSpacing")
    public var captionSpacing: CGFloat {
        get { iconCaptionAndTitleCaptionTextSpacing }
        set { iconCaptionAndTitleCaptionTextSpacing = newValue }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension VRoundedCaptionButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleCaptionText")
    public var titleCaption: StateColors {
        get { titleCaptionText }
        set { titleCaptionText = newValue }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension VRoundedCaptionButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var titleCaption: Font {
        get { titleCaptionText }
        set { titleCaptionText = newValue }
    }
}

// MARK: - V Plain Button
@available(tvOS, unavailable)
extension VPlainButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "iconAndTitleTextSpacing")
    public var iconTitleSpacing: CGFloat {
        get { iconAndTitleTextSpacing }
        set { iconAndTitleTextSpacing = newValue }
    }
}

@available(tvOS, unavailable)
extension VPlainButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
extension VPlainButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Toggle
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VToggleUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "toggleAndLabelSpacing")
    public var toggleLabelSpacing: CGFloat {
        get { toggleAndLabelSpacing }
        set { toggleAndLabelSpacing = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VToggleUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VToggleUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V CheckBox
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VCheckBoxUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "checkBoxAndLabelSpacing")
    public var checkBoxLabelSpacing: CGFloat {
        get { checkBoxAndLabelSpacing }
        set { checkBoxAndLabelSpacing = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VCheckBoxUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VCheckBoxUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Radio Button
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VRadioButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "radioButtonAndLabelSpacing")
    public var radioLabelSpacing: CGFloat {
        get { radioButtonAndLabelSpacing }
        set { radioButtonAndLabelSpacing = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VRadioButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VRadioButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Rounded Button
@available(tvOS, unavailable)
extension VRoundedButtonUIModel.Layout {
    @available(*, deprecated, renamed: "titleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { titleTextMinimumScaleFactor }
        set { titleTextMinimumScaleFactor = newValue }
    }
}

@available(tvOS, unavailable)
extension VRoundedButtonUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: StateColors {
        get { titleText }
        set { titleText = newValue }
    }
}

@available(tvOS, unavailable)
extension VRoundedButtonUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }
}

// MARK: - V Segmented Picker
extension VSegmentedPicker {
    @available(*, unavailable, message: "This `init` is no longer available")
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where
            Content == Never,
            Data: RandomAccessCollection,
            Data.Index == Int
    {
        fatalError()
    }

    @available(*, unavailable, message: "This `init` is no longer available")
    public init(
        uiModel: VSegmentedPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledIndexes: Set<Int> = [],
        data: Data,
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, Data.Element) -> Content
    )
        where
            Data: RandomAccessCollection,
            Data.Index == Int
    {
        fatalError()
    }

    @available(*, deprecated, message: "Use `init` with `id`")
    public init<SelectionValue>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        title: @escaping (SelectionValue) -> String
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: CaseIterable,
            ID == Int,
            Content == Never
    {
        self.init(
            uiModel: uiModel,
            selection: selection,
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            disabledValues: disabledValues,
            data: Array(SelectionValue.allCases),
            id: \.hashValue,
            title: title
        )
    }

    @available(*, deprecated, message: "Use `init` with `id`")
    public init<SelectionValue>(
        uiModel: VSegmentedPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        disabledValues: Set<SelectionValue> = [],
        @ViewBuilder content: @escaping (VSegmentedPickerRowInternalState, SelectionValue) -> Content
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: CaseIterable,
            ID == Int
    {
        self.init(
            uiModel: uiModel,
            selection: selection,
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            disabledValues: disabledValues,
            data: Array(SelectionValue.allCases),
            id: \.hashValue,
            content: content
        )
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSegmentedPickerUIModel.Layout {
    @available(*, deprecated, renamed: "headerPickerAndFooterSpacing")
    public var headerPickerFooterSpacing: CGFloat {
        get { headerPickerAndFooterSpacing }
        set { headerPickerAndFooterSpacing = newValue }
    }

    @available(*, deprecated, renamed: "headerAndFooterMarginHorizontal")
    public var headerFooterMarginHorizontal: CGFloat {
        get { headerAndFooterMarginHorizontal }
        set { headerAndFooterMarginHorizontal = newValue }
    }

    @available(*, deprecated, renamed: "rowTitleTextMinimumScaleFactor")
    public var rowTitleMinimumScaleFactor: CGFloat {
        get { rowTitleTextMinimumScaleFactor }
        set { rowTitleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleTextLineType")
    public var headerTextLineType: TextLineType {
        get { headerTitleTextLineType }
        set { headerTitleTextLineType = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleTextLineType")
    public var footerTextLineType: TextLineType {
        get { footerTitleTextLineType }
        set { footerTitleTextLineType = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSegmentedPickerUIModel.Colors {
    @available(*, deprecated, renamed: "rowTitleText")
    public var rowTitle: RowStateColors {
        get { rowTitleText }
        set { rowTitleText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: StateColors {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: StateColors {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSegmentedPickerUIModel.Fonts {
    @available(*, deprecated, renamed: "rowTitleText")
    public var rows: Font {
        get { rowTitleText }
        set { rowTitleText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: Font {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

// MARK: - V Wheel Picker
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWheelPicker {
    @available(*, unavailable, message: "This `init` is no longer available")
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where
            Data.Index == Int,
            Content == Never
    {
        fatalError()
    }

    @available(*, unavailable, message: "This `init` is no longer available")
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    )
        where Data.Index == Int
    {
        fatalError()
    }

    @available(*, deprecated, message: "Use `init` with `id`")
    public init<SelectionValue>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        title: @escaping (SelectionValue) -> String
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: CaseIterable,
            ID == Int,
            Content == Never
    {
        self.init(
            uiModel: uiModel,
            selection: selection,
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: Array(SelectionValue.allCases),
            id: \.hashValue,
            title: title
        )
    }

    @available(*, deprecated, message: "Use `init` with `id`")
    public init<SelectionValue>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<SelectionValue>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, SelectionValue) -> Content
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: CaseIterable,
            ID == Int
    {
        self.init(
            uiModel: uiModel,
            selection: selection,
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            data: Array(SelectionValue.allCases),
            id: \.hashValue,
            content: content
        )
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWheelPickerUIModel.Layout {
    @available(*, deprecated, renamed: "headerPickerAndFooterSpacing")
    public var headerPickerFooterSpacing: CGFloat {
        get { headerPickerAndFooterSpacing }
        set { headerPickerAndFooterSpacing = newValue }
    }

    @available(*, deprecated, renamed: "headerAndFooterMarginHorizontal")
    public var headerFooterMarginHorizontal: CGFloat {
        get { headerAndFooterMarginHorizontal }
        set { headerAndFooterMarginHorizontal = newValue }
    }

    @available(*, deprecated, renamed: "rowTitleTextMinimumScaleFactor")
    public var titleMinimumScaleFactor: CGFloat {
        get { rowTitleTextMinimumScaleFactor }
        set { rowTitleTextMinimumScaleFactor = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleTextLineType")
    public var headerTextLineType: TextLineType {
        get { headerTitleTextLineType }
        set { headerTitleTextLineType = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleTextLineType")
    public var footerTextLineType: TextLineType {
        get { footerTitleTextLineType }
        set { footerTitleTextLineType = newValue }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWheelPickerUIModel.Colors {
    @available(*, deprecated, renamed: "rowTitleText")
    public var title: StateColors {
        get { rowTitleText }
        set { rowTitleText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: StateColors {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: StateColors {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWheelPickerUIModel.Fonts {
    @available(*, deprecated, renamed: "rowTitleText")
    public var rows: Font {
        get { rowTitleText }
        set { rowTitleText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: Font {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

// MARK: - V Text Field
@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
extension VTextFieldUIModel.Layout {
    @available(*, deprecated, renamed: "textAndButtonSpacing")
    public var contentSpacing: CGFloat {
        get { textAndButtonSpacing }
        set { textAndButtonSpacing = newValue }
    }

    @available(*, deprecated, renamed: "headerAndFooterMarginHorizontal")
    public var headerFooterMarginHorizontal: CGFloat {
        get { headerAndFooterMarginHorizontal }
        set { headerAndFooterMarginHorizontal = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleTextLineType")
    public var headerTextLineType: TextLineType {
        get { headerTitleTextLineType }
        set { headerTitleTextLineType = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleTextLineType")
    public var footerTextLineType: TextLineType {
        get { footerTitleTextLineType }
        set { footerTitleTextLineType = newValue }
    }

    @available(*, deprecated, renamed: "headerTextFieldAndFooterSpacing")
    public var headerTextFieldFooterSpacing: CGFloat {
        get { headerTextFieldAndFooterSpacing }
        set { headerTextFieldAndFooterSpacing = newValue }
    }
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
extension VTextFieldUIModel.Colors {
    @available(*, deprecated, renamed: "placeholderText")
    public var placeholder: StateColors {
        get { placeholderText }
        set { placeholderText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: StateColors {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: StateColors {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
extension VTextFieldUIModel.Fonts {
    @available(*, deprecated, renamed: "placeholderText")
    public var placeholder: Font {
        get { placeholderText }
        set { placeholderText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: Font {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

// MARK: - V Text View
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel.Layout {
    @available(*, deprecated, renamed: "headerTextViewAndFooterSpacing")
    public var headerTextViewFooterSpacing: CGFloat {
        get { headerTextViewAndFooterSpacing }
        set { headerTextViewAndFooterSpacing = newValue }
    }

    @available(*, deprecated, renamed: "headerAndFooterMarginHorizontal")
    public var headerFooterMarginHorizontal: CGFloat {
        get { headerAndFooterMarginHorizontal }
        set { headerAndFooterMarginHorizontal = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleTextLineType")
    public var headerTextLineType: TextLineType {
        get { headerTitleTextLineType }
        set { headerTitleTextLineType = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleTextLineType")
    public var footerTextLineType: TextLineType {
        get { footerTitleTextLineType }
        set { footerTitleTextLineType = newValue }
    }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VTextViewUIModel.Colors {
    @available(*, deprecated, renamed: "placeholderText")
    public var placeholder: StateColors {
        get { placeholderText }
        set { placeholderText = newValue }
    }

    @available(*, deprecated, renamed: "headerTitleText")
    public var header: StateColors {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }

    @available(*, deprecated, renamed: "footerTitleText")
    public var footer: StateColors {
        get { footerTitleText }
        set { footerTitleText = newValue }
    }
}

// MARK: - V Sheet
extension VSheetUIModel.Layout {
    @available(*, deprecated, message: "Use `contentMargins` instead")
    public var contentMargin: CGFloat {
        get { (contentMargins.horizontalAverage + contentMargins.verticalAverage)/2 }
        set { contentMargins = .init(newValue) }
    }
}

// MARK: - V Disclosure Group
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupUIModel.Colors {
    @available(*, deprecated, renamed: "headerTitleText")
    public var headerTitle: StateColors {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupUIModel.Fonts {
    @available(*, deprecated, renamed: "headerTitleText")
    public var headerTitle: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

// MARK: - V Modal
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VModalUIModel.Layout {
    @available(*, unavailable, message: "Use `ignoredContainerSafeAreaEdges` instead")
    public var headerSafeAreaEdges: Edge.Set {
        fatalError()
    }

    @available(*, deprecated, renamed: "labelAndCloseButtonSpacing")
    public var labelCloseButtonSpacing: CGFloat {
        get { labelAndCloseButtonSpacing }
        set { labelAndCloseButtonSpacing = newValue }
    }

    @available(*, deprecated, renamed: "ignoredContainerSafeAreaEdgesByContent")
    public var ignoredContainerSafeAreaEdges: Edge.Set {
        get { ignoredContainerSafeAreaEdgesByContent }
        set { ignoredContainerSafeAreaEdgesByContent = newValue }
    }

    @available(*, deprecated, renamed: "ignoredKeyboardSafeAreaEdgesByContent")
    public var ignoredKeyboardSafeAreaEdges: Edge.Set {
        get { ignoredKeyboardSafeAreaEdgesByContent }
        set { ignoredKeyboardSafeAreaEdgesByContent = newValue }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VModalUIModel.Colors {
    @available(*, deprecated, renamed: "headerTitleText")
    public var headerTitle: Color {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VModalUIModel.Fonts {
    @available(*, deprecated, renamed: "headerTitleText")
    public var header: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

// MARK: - V Bottom Sheet
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel.Layout {
    @available(*, deprecated, renamed: "labelAndCloseButtonSpacing")
    public var labelCloseButtonSpacing: CGFloat {
        get { labelAndCloseButtonSpacing }
        set { labelAndCloseButtonSpacing = newValue }
    }
}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel.Layout.BottomSheetHeights {
    @available(*, deprecated, message: "Use `init` instead")
    public static func fixed(_ value: CGFloat) -> Self {
        .init(
            min: value,
            ideal: value,
            max: value
        )
    }
}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel.Colors {
    @available(*, deprecated, renamed: "headerTitleText")
    public var headerTitle: Color {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel.Fonts {
    @available(*, deprecated, renamed: "headerTitleText")
    public var header: Font {
        get { headerTitleText }
        set { headerTitleText = newValue }
    }
}

// MARK: - V Menu
@available(iOS 15.0, *)
extension VMenuPickerSection {
    @available(*, unavailable, message: "This `init` is no longer available")
    public init(
        title: String? = nil,
        selectedIndex: Binding<Int>,
        rowTitles: [String]
    )
        where
            Data: RandomAccessCollection,
            Data.Index == Int
    {
        fatalError()
    }

    @available(*, deprecated, message: "Use `init` with `id`")
    public init<SelectionValue>(
        title: String? = nil,
        selection: Binding<SelectionValue>,
        content: @escaping (SelectionValue) -> VMenuRowProtocol
    )
        where
            Data == Array<SelectionValue>,
            SelectionValue: CaseIterable,
            ID == Int
    {
        self.init(
            title: title,
            selection: selection,
            data: Array(SelectionValue.allCases),
            id: \.hashValue,
            content: content
        )
    }
}

// MARK: - V Side Bar
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel.Layout {
    @available(*, unavailable, message: "Use `ignoredContainerSafeAreaEdges` instead")
    public var contentSafeAreaEdges: Edge.Set {
        fatalError()
    }

    @available(*, deprecated, renamed: "ignoredContainerSafeAreaEdgesByContent")
    public var ignoredContainerSafeAreaEdges: Edge.Set {
        get { ignoredContainerSafeAreaEdgesByContent }
        set { ignoredContainerSafeAreaEdgesByContent = newValue }
    }

    @available(*, deprecated, renamed: "ignoredKeyboardSafeAreaEdgesByContent")
    public var ignoredKeyboardSafeAreaEdges: Edge.Set {
        get { ignoredKeyboardSafeAreaEdgesByContent }
        set { ignoredKeyboardSafeAreaEdgesByContent = newValue }
    }
}

// MARK: - V Alert
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertUIModel.Layout {
    @available(*, deprecated, renamed: "ignoredKeyboardSafeAreaEdgesByContent")
    public var ignoredKeyboardSafeAreaEdges: Edge.Set {
        get { ignoredKeyboardSafeAreaEdgesByContent }
        set { ignoredKeyboardSafeAreaEdgesByContent = newValue }
    }

    @available(*, deprecated, renamed: "titleTextMessageTextAndContentMargins")
    public var titleMessageContentMargins: Margins {
        get { titleTextMessageTextAndContentMargins }
        set { titleTextMessageTextAndContentMargins = newValue }
    }

    @available(*, deprecated, renamed: "titleTextMargins")
    public var titleMargins: Margins {
        get { titleTextMargins }
        set { titleTextMargins = newValue }
    }

    @available(*, deprecated, renamed: "messageTextMargins")
    public var messageMargins: Margins {
        get { messageTextMargins }
        set { messageTextMargins = newValue }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertUIModel.Colors {
    @available(*, deprecated, renamed: "titleText")
    public var title: Color {
        get { titleText }
        set { titleText = newValue }
    }

    @available(*, deprecated, renamed: "messageText")
    public var message: Color {
        get { messageText }
        set { messageText = newValue }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertUIModel.Fonts {
    @available(*, deprecated, renamed: "titleText")
    public var title: Font {
        get { titleText }
        set { titleText = newValue }
    }

    @available(*, deprecated, renamed: "messageText")
    public var message: Font {
        get { messageText }
        set { messageText = newValue }
    }
}
