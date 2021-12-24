//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI

// MARK: - V Base Button
extension VBaseButton {
    @available(*, deprecated, message: "Use `init` with `gestureState` parameter")
    public init(
        state: VBaseButtonState,
        action: @escaping () -> Void,
        onPress pressHandler: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            state: state,
            gesture: { gestureState in
                pressHandler(gestureState.isPressed)
                if gestureState.isClicked { action() }
            },
            content: content
        )
    }
    
    @available(*, deprecated, message: "Use `init` with `gestureState` parameter")
    public init(
        isEnabled: Bool,
        action: @escaping () -> Void,
        onPress pressHandler: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            isEnabled: isEnabled,
            gesture: { gestureState in
                pressHandler(gestureState.isPressed)
                if gestureState.isClicked { action() }
            },
            content: content
        )
    }
}

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

// MARK: - V Navigation View
extension VNavigationViewModel.Colors {
    @available(*, deprecated, renamed: "bar")
    public var background: Color {
        get { bar }
        set { bar = newValue }
    }
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

// MARK: - Dialog
extension VDialogModel.Layout {
    @available(*, unavailable, message: "Property has been moved to `Misc`")
    public var descriptionLineLimit: Int {
        get { fatalError() }
        set { fatalError() }
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
@available(*, deprecated, renamed: "StateColors_EPLD")
public typealias StateColors_EPDL = StateColors_EPLD

extension StateColors_EPLD {
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color,
        loading: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.loading = loading
    }
}

extension StateColors_OOD {
    @available(*, deprecated, message: "Use `init` with pressed parameters instead")
    public init(
        off: Color,
        on: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.pressedOff = off
        self.pressedOn = on
        self.disabled = disabled
    }
}

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
        self.pressedOff = off
        self.pressedOn = on
        self.pressedIndeterminate = indeterminate
        self.disabled = disabled
    }
}


extension StateColors_OOID {
    @available(*, deprecated, message: "Use `init` with pressed parameters instead")
    public init(off: Color, on: Color, indeterminate: Color, disabled: Color) {
        self.off = off
        self.on = on
        self.indeterminate = indeterminate
        self.pressedOff = off
        self.pressedOn = on
        self.pressedIndeterminate = indeterminate
        self.disabled = disabled
    }
}

@available(*, deprecated, renamed: "StateColors_EFSEPD")
public typealias StateColors_EpFpSpEpD = StateColors_EFSEPD

extension StateColors_EFSEPD {
    @available(*, deprecated, renamed: "pressedEnabled")
    public var enabledPressed: Color {
        get { pressedEnabled }
        set { pressedEnabled = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedFocused")
    public var focusedPressed: Color {
        get { pressedFocused }
        set { pressedFocused = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedSuccess")
    public var successPressed: Color {
        get { pressedSuccess }
        set { pressedSuccess = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedError")
    public var errorPressed: Color {
        get { pressedError }
        set { pressedError = newValue }
    }
    
    @available(*, deprecated, message: "Use init with parameters of different labels")
    public init(
        enabled: Color,
        enabledPressed: Color,
        focused: Color,
        focusedPressed: Color,
        success: Color,
        successPressed: Color,
        error: Color,
        errorPressed: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.focused = focused
        self.success = success
        self.error = error
        self.pressedEnabled = enabledPressed
        self.pressedFocused = focusedPressed
        self.pressedSuccess = successPressed
        self.pressedError = errorPressed
        self.disabled = disabled
    }
}

@available(*, deprecated, renamed: "StateColorsAndOpacities_EFSEPD_PD")
public typealias StateColors_EpFpSpEpD_PD = StateColorsAndOpacities_EFSEPD_PD

extension StateColorsAndOpacities_EFSEPD_PD {
    @available(*, deprecated, renamed: "pressedEnabled")
    public var enabledPressed: Color {
        get { pressedEnabled }
        set { pressedEnabled = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedFocused")
    public var focusedPressed: Color {
        get { pressedFocused }
        set { pressedFocused = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedSuccess")
    public var successPressed: Color {
        get { pressedSuccess }
        set { pressedSuccess = newValue }
    }
    
    @available(*, deprecated, renamed: "pressedError")
    public var errorPressed: Color {
        get { pressedError }
        set { pressedError = newValue }
    }
    
    @available(*, deprecated, message: "Use init with parameters of different labels")
    public init(
        enabled: Color,
        enabledPressed: Color,
        focused: Color,
        focusedPressed: Color,
        success: Color,
        successPressed: Color,
        error: Color,
        errorPressed: Color,
        disabled: Color,
        pressedOpacity: CGFloat,
        disabledOpacity: CGFloat
    ) {
        self.enabled = enabled
        self.focused = focused
        self.success = success
        self.error = error
        self.pressedEnabled = enabledPressed
        self.pressedFocused = focusedPressed
        self.pressedSuccess = successPressed
        self.pressedError = errorPressed
        self.disabled = disabled
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
}

// MARK: - Colors
extension ColorBook {
    @available(*, deprecated, message: "Use SwiftUI's Color.clear")
    public static let clear: Color = .clear
}

// MARK: - Basic Animations
extension BasicAnimation {
    @available(*, deprecated, renamed: "AnimationCurve")
    public typealias VAnimationCurve = AnimationCurve
}
