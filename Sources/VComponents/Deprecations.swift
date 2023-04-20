//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

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
}

// MARK: - V Wheel Picker
extension VWheelPicker {
    @available(*, unavailable, message: "This `init` is no longer available")
    public init<Data>(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
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
    public init<Data>(
        uiModel: VWheelPickerUIModel = .init(),
        selectedIndex: Binding<Int>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    )
        where
            Data: RandomAccessCollection,
            Data.Index == Int
    {
        fatalError()
    }
}

// MARK: - V Bottom Sheet
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

// MARK: - V Menu
@available(iOS 15.0, *)
extension VMenuPickerSection {
    @available(*, unavailable, message: "This `init` is no longer available")
    public init<Data>(
        title: String? = nil,
        selectedIndex: Binding<Int>,
        data: Data,
        content: @escaping (Data.Element) -> VMenuRowProtocol
    )
        where
            Data: RandomAccessCollection,
            Data.Index == Int
    {
        fatalError()
    }

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
}
