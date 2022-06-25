//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - Base Button
@available(*, deprecated, message: "Use `SwiftUIBaseButton` from `VCore`")
public typealias VBaseButton = VCore.SwiftUIBaseButton

@available(*, deprecated, message: "Use `BaseButtonGestureState` from `VCore`")
public typealias VBaseButtonGestureState = VCore.BaseButtonGestureState

// MARK: - List
extension VList {
    @available(*, unavailable, message: "`VListLayoutType` is deprecated. Use `VList` for dyamic list, or use `VStaticList` for fixed list.")
    public init(
        uiModel: VListUIModel = .init(),
        layout layoutType: VListLayoutType,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        fatalError()
    }

    @available(*, unavailable, message: "`VListLayoutType` is deprecated. Use `VList` for dyamic list, or use `VStaticList` for fixed list.")
    public init(
        uiModel: VListUIModel = .init(),
        layout layoutType: VListLayoutType,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        fatalError()
    }

    @available(*, unavailable, message: "`VListLayoutType` is deprecated. Use `VList` for dyamic list, or use `VStaticList` for fixed list.")
    public init(
        uiModel: VListUIModel = .init(),
        layout layoutType: VListLayoutType,
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data == Range<Int>,
            ID == Int
    {
        fatalError()
    }
}

@available(*, unavailable, message: "`VListLayoutType` is deprecated. Use `VList` for dyamic list, or use `VStaticList` for fixed list.")
public enum VListLayoutType: Int, CaseIterable {
    case fixed
    case flexible

    public static var `default`: Self { .flexible }
}

extension VListUIModel.Layout {
    @available(*, unavailable, message: "Use normal margins within UI model")
    public var marginTrailing: CGFloat { fatalError() }
    
    @available(*, deprecated, renamed: "separatorHeight")
    public var dividerHeight: CGFloat {
        get { separatorHeight }
        set { separatorHeight = newValue }
    }
    
    @available(*, deprecated, renamed: "separatorMargins")
    public var dividerMargins: HorizontalMargins {
        get { separatorMargins }
        set { separatorMargins = newValue }
    }
    
    @available(*, deprecated, renamed: "showsLastSeparator")
    public var lastRowHasDivider: Bool {
        get { showsLastSeparator }
        set { showsLastSeparator = newValue }
    }
}

extension VListUIModel.Colors {
    @available(*, deprecated, renamed: "separator")
    public var divider: Color {
        get { separator }
        set { separator = newValue }
    }
}

// MARK: - *Model
@available(*, deprecated, renamed: "VPrimaryButtonUIModel")
public typealias VPrimaryButtonModel = VPrimaryButtonUIModel

@available(*, deprecated, renamed: "VSecondaryButtonUIModel")
public typealias VSecondaryButtonModel = VSecondaryButtonUIModel

@available(*, deprecated, renamed: "VSquareButtonUIModel")
public typealias VSquareButtonModel = VSquareButtonUIModel
 
@available(*, deprecated, renamed: "VPlainButtonUIModel")
public typealias VPlainButtonModel = VPlainButtonUIModel

@available(*, deprecated, renamed: "VToggleUIModel")
public typealias VToggleModel = VToggleUIModel

@available(*, deprecated, renamed: "VCheckBoxUIModel")
public typealias VCheckBoxModel = VCheckBoxUIModel

@available(*, deprecated, renamed: "VRadioButtonUIModel")
public typealias VRadioButtonModel = VRadioButtonUIModel

@available(*, deprecated, renamed: "VSegmentedPickerUIModel")
public typealias VSegmentedPickerModel = VSegmentedPickerUIModel

@available(*, deprecated, renamed: "VWheelPickerUIModel")
public typealias VWheelPickerModel = VWheelPickerUIModel

@available(*, deprecated, renamed: "VStepperUIModel")
public typealias VStepperModel = VStepperUIModel

@available(*, deprecated, renamed: "VSliderUIModel")
public typealias VSliderModel = VSliderUIModel

@available(*, deprecated, renamed: "VRangeSliderUIModel")
public typealias VRangeSliderModel = VRangeSliderUIModel

@available(*, deprecated, renamed: "VTextFieldUIModel")
public typealias VTextFieldModel = VTextFieldUIModel

@available(*, deprecated, renamed: "VSheetUIModel")
public typealias VSheetModel = VSheetUIModel

@available(*, deprecated, renamed: "VDisclosureGroupUIModel")
public typealias VDisclosureGroupModel = VDisclosureGroupUIModel

@available(*, deprecated, renamed: "VLazyScrollViewHorizontalUIModel")
public typealias VLazyScrollViewHorizontalModel = VLazyScrollViewHorizontalUIModel

@available(*, deprecated, renamed: "VLazyScrollViewVerticalUIModel")
public typealias VLazyScrollViewVerticalModel = VLazyScrollViewVerticalUIModel

@available(*, deprecated, renamed: "VListUIModel")
public typealias VListModel = VListUIModel

@available(*, deprecated, renamed: "VModalUIModel")
public typealias VModalModel = VModalUIModel

@available(*, deprecated, renamed: "VBottomSheetUIModel")
public typealias VBottomSheetModel = VBottomSheetUIModel

@available(*, deprecated, renamed: "VSideBarUIModel")
public typealias VSideBarModel = VSideBarUIModel

@available(*, deprecated, renamed: "VAlertUIModel")
public typealias VAlertModel = VAlertUIModel

@available(*, deprecated, renamed: "VToastUIModel")
public typealias VToastModel = VToastUIModel

@available(*, deprecated, renamed: "VSpinnerContinousUIModel")
public typealias VSpinnerContinousModel = VSpinnerContinousUIModel

@available(*, deprecated, renamed: "VSpinnerDashedUIModel")
public typealias VSpinnerDashedModel = VSpinnerDashedUIModel

@available(*, deprecated, renamed: "VProgressBarUIModel")
public typealias VProgressBarModel = VProgressBarUIModel

@available(*, deprecated, renamed: "VPageIndicatorUIModel")
public typealias VPageIndicatorModel = VPageIndicatorUIModel

@available(*, deprecated, renamed: "VChevronButtonUIModel")
public typealias VChevronButtonModel = VChevronButtonUIModel

@available(*, deprecated, renamed: "VCloseButtonUIModel")
public typealias VCloseButtonModel = VCloseButtonUIModel

// MARK: - Basic Animation
extension BasicAnimation {
    @available(*, deprecated, renamed: "toSwiftUIAnimation")
    public var asSwiftUIAnimation: Animation { toSwiftUIAnimation }
}

// MARK: - Modal Sizes
extension ModalSizes.SizeConfiguration {
    @available(*, deprecated, renamed: "fraction")
    public static func relative(_ measurement: ModalSizeMeasurement) -> Self {
        .fraction(measurement)
    }
}
