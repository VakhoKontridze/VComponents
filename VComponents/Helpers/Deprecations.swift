//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI

// MARK: - V Web Link
@available(*, deprecated, renamed: "VWebLink")
public typealias VLink = VWebLink

@available(*, deprecated, renamed: "VWebLinkPreset")
public typealias VLinkPreset = VWebLinkPreset

@available(*, deprecated, renamed: "VWebLinkState")
public typealias VLinkState = VWebLinkState

// MARK: - V Toggle
extension VToggleState {
    @available(*, deprecated, renamed: "setNextState")
    mutating func nextState() { setNextState() }
}

// MARK: - V CheckBox
extension VCheckBoxState {
    @available(*, deprecated, renamed: "indeterminate")
    public static var intermediate: Self { indeterminate }
    
    @available(*, deprecated, renamed: "setNextState")
    public mutating func nextState() { setNextState() }
}

// MARK: - V Radio Button
extension VRadioButtonState {
    @available(*, deprecated, renamed: "setNextState")
    public mutating func nextState() { setNextState() }
}

// MARK: - V List
@available(*, deprecated, renamed: "VList")
public typealias VSection = VList

@available(*, deprecated, renamed: "VListLayoutType")
public typealias VSectionLayoutType = VListLayoutType

@available(*, deprecated, renamed: "VListModel")
public typealias VSectionModel = VListModel

// MARK: - V Section List
@available(*, deprecated, renamed: "VSectionList")
public typealias VTable = VSectionList

@available(*, deprecated, renamed: "VSectionListLayoutType")
public typealias VTableLayoutType = VSectionListLayoutType

@available(*, deprecated, renamed: "VSectionListModel")
public typealias VTableModel = VSectionListModel

@available(*, deprecated, renamed: "VSectionListSectionViewModelable")
public typealias VTableSection = VSectionListSectionViewModelable

@available(*, deprecated, renamed: "VSectionListRowViewModelable")
public typealias VTableRow = VSectionListRowViewModelable

@available(*, deprecated, renamed: "VSectionListSectionViewModelable")
public typealias VSectionListSection = VSectionListSectionViewModelable

@available(*, deprecated, renamed: "VSectionListRowViewModelable")
public typealias VSectionListRow = VSectionListRowViewModelable

extension VSectionListSectionViewModelable {
    @available(*, deprecated, renamed: "VSectionListRowViewModelable")
    public typealias VSectionListRow = VSectionListRowViewModelable
}

@available(*, deprecated, message: "`VSectionListRowViewModelable` has been dropped. Use `Identifiable` instead.")
public typealias VSectionListRowViewModelable = Identifiable

// MARK: - V Accordion
extension VAccordionState {
    @available(*, deprecated, renamed: "setNextState")
    public mutating func nextState() { setNextState() }
}

// MARK: - Half Modal
extension VHalfModalModel.Layout {
    @available(*, deprecated, renamed: "grabberSize")
    public var resizeIndicatorSize: CGSize {
        get { grabberSize }
        set { grabberSize = newValue }
    }
    
    @available(*, deprecated, renamed: "grabberCornerRadius")
    public var resizeIndicatorCornerRadius: CGFloat {
        get { grabberCornerRadius }
        set { grabberCornerRadius = newValue }
    }
    
    @available(*, deprecated, renamed: "grabberMargins")
    public var resizeIndicatorMargins: VerticalMargins {
        get { grabberMargins }
        set { grabberMargins = newValue }
    }
}

extension VHalfModalModel.Colors {
    @available(*, deprecated, renamed: "grabber")
    public var resizeIndicator: Color {
        get { grabber }
        set { grabber = newValue }
    }
}

// MARK: - V Navigation View
extension VNavigationViewModel.Colors {
    @available(*, deprecated, renamed: "bar")
    public var background: Color {
        get { bar }
        set { bar = newValue }
    }
}

// MARK: - V Lazy Scroll View
@available(*, deprecated, renamed: "VLazyScrollView")
public typealias VLazyList = VLazyScrollView

@available(*, deprecated, renamed: "VLazyScrollViewType")
public typealias VLazyListType = VLazyScrollViewType

@available(*, deprecated, renamed: "VLazyScrollViewModelVertical")
public typealias VLazyListModelVertical = VLazyScrollViewModelVertical

@available(*, deprecated, renamed: "VLazyScrollViewModelHorizontal")
public typealias VLazyListModelHorizontal = VLazyScrollViewModelHorizontal

// MARK: - State Colors
extension StateColors_OOID {
    @available(*, deprecated, renamed: "indeterminate")
    public var intermediate: Color {
        get { indeterminate }
        set { indeterminate = newValue }
    }
    
    @available(*, deprecated, message: "Use `init(off:_, on:_, intermediate:_, disabled:_)` instead")
    public init(off: Color, on: Color, intermediate: Color, disabled: Color) {
        self.off = off
        self.on = on
        self.indeterminate = intermediate
        self.disabled = disabled
    }
}

// MARK: - Basic Animations
extension BasicAnimation {
    @available(*, deprecated, renamed: "AnimationCurve")
    public typealias VAnimationCurve = AnimationCurve
}
