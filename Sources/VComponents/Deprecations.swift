//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Primary Button
extension VPrimaryButtonUIModel.Layout {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var loaderDimension: CGFloat {
        get { spinnerSubUIModel.dimension }
        set { spinnerSubUIModel.dimension = newValue }
    }
    
    @available(*, deprecated, renamed: "labelSpinnerSpacing")
    public var labelLoaderSpacing: CGFloat {
        get { labelSpinnerSpacing }
        set { labelSpinnerSpacing = newValue }
    }
}

extension VPrimaryButtonUIModel.Colors {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var loader: Color {
        get { spinnerSubUIModel.spinner }
        set { spinnerSubUIModel.spinner = newValue }
    }
}

// MARK: - V Disclosure Group
extension VDisclosureGroupUIModel.Layout {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var chevronButtonDimension: CGFloat {
        get { chevronButtonSubUIModel.dimension }
        set { chevronButtonSubUIModel.dimension = newValue }
    }
    
    @available(*, deprecated, message: "Use sub UI model instead")
    public var chevronButtonIconDimension: CGFloat {
        get { chevronButtonSubUIModel.iconSize.width }
        set { chevronButtonSubUIModel.iconSize = .init(dimension: newValue) }
    }
}

extension VDisclosureGroupUIModel.Colors {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var chevronButtonBackground: GenericStateModel_EnabledPressedDisabled<Color> {
        get { chevronButtonSubUIModel.background }
        set { chevronButtonSubUIModel.background = newValue }
    }
    
    @available(*, deprecated, message: "Use sub UI model instead")
    public var chevronButtonIcon: GenericStateModel_EnabledPressedDisabled<Color> {
        get { chevronButtonSubUIModel.icon }
        set { chevronButtonSubUIModel.icon = newValue }
    }
}

// MARK: - V Text Field
extension VTextFieldUIModel.Layout {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var clearButtonDimension: CGFloat {
        get { clearButtonSubUIModel.dimension }
        set { clearButtonSubUIModel.dimension = newValue }
    }

    @available(*, deprecated, message: "Use sub UI model instead")
    public var clearButtonIconDimension: CGFloat {
        get { clearButtonSubUIModel.iconSize.width }
        set { clearButtonSubUIModel.iconSize = .init(dimension: newValue) }
    }
    
    @available(*, unavailable, message: "Property has no effect")
    public var visibilityButtonDimension: CGFloat {
        get { 22 }
        set {}
    }
    
    @available(*, deprecated, message: "Use sub UI model instead")
    public var visibilityButtonIconDimension: CGFloat {
        get { visibilityButtonSubUIModel.iconSize.width }
        set { visibilityButtonSubUIModel.iconSize = .init(dimension: newValue) }
    }
}

extension VTextFieldUIModel.Colors {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var clearButtonBackground: GenericStateModel_EnabledPressedFocusedDisabled<Color> {
        get {
            .init(
                enabled: clearButtonSubUIModel.background.enabled,
                pressed: clearButtonSubUIModel.background.pressed,
                focused: clearButtonSubUIModel.background.enabled,
                disabled: clearButtonSubUIModel.background.disabled
            )
        }
        set { clearButtonSubUIModel.background = .init(newValue) }
    }

    @available(*, deprecated, message: "Use sub UI model instead")
    public var clearButtonIcon: GenericStateModel_EnabledPressedFocusedDisabled<Color> {
        get {
            .init(
                enabled: clearButtonSubUIModel.icon.enabled,
                pressed: clearButtonSubUIModel.icon.pressed,
                focused: clearButtonSubUIModel.icon.enabled,
                disabled: clearButtonSubUIModel.icon.disabled
            )
        }
        set { clearButtonSubUIModel.icon = .init(newValue) }
    }
    
    @available(*, deprecated, message: "Use sub UI model instead")
    public var visibilityButtonIcon: GenericStateModel_EnabledPressedFocusedDisabled<Color> {
        get {
            .init(
                enabled: visibilityButtonSubUIModel.icon.enabled,
                pressed: visibilityButtonSubUIModel.icon.pressed,
                focused: visibilityButtonSubUIModel.icon.enabled,
                disabled: visibilityButtonSubUIModel.icon.disabled
            )
        }
        set { visibilityButtonSubUIModel.icon = .init(newValue) }
    }
}

@available(*, deprecated, message: "Pass type to UI model instead")
public typealias VTextFieldType = VTextFieldUIModel.Layout.ContentType

extension VTextField {
    @available(*, deprecated, message: "Pass type to UI model instead")
    public init(
        uiModel: VTextFieldUIModel = .init(),
        type textFieldType: VTextFieldType,// = .default,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.init(
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.contentType = textFieldType
                return uiModel
            }(),
            headerTitle: headerTitle,
            footerTitle: footerTitle,
            placeholder: placeholder,
            text: text
        )
    }
}

// MARK: - V List
@available(*, deprecated, message: "Pass type to UI model instead")
public typealias VListRowSeparatorType = VListRowUIModel.Layout.SeparatorType

extension VListRow {
    @available(*, deprecated, message: "Pass type to UI model instead")
    public init(
        uiModel: VListRowUIModel = .init(),
        separator separatorType: VListRowSeparatorType,// = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.separatorType = separatorType
                return uiModel
            }(),
            content: content
        )
    }
}

// MARK: - V Modal
extension VModalUIModel.Layout {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonDimension: CGFloat {
        get { closeButtonSubUIModel.dimension }
        set { closeButtonSubUIModel.dimension = newValue }
    }

    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonIconDimension: CGFloat {
        get { closeButtonSubUIModel.iconSize.width }
        set { closeButtonSubUIModel.iconSize = .init(dimension: newValue) }
    }
}

extension VModalUIModel.Colors {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonBackground: GenericStateModel_EnabledPressedDisabled<Color> {
        get { closeButtonSubUIModel.background }
        set { closeButtonSubUIModel.background = newValue }
    }

    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonIcon: GenericStateModel_EnabledPressedDisabled<Color> {
        get { closeButtonSubUIModel.icon }
        set { closeButtonSubUIModel.icon = newValue }
    }
}

extension VModalUIModel {
    @available(*, deprecated, renamed: "fullSizedContent")
    public static var noHeaderLabel: Self {
        fullSizedContent
    }
}

// MARK: - V Bottom Sheet
extension VBottomSheetUIModel.Layout {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonDimension: CGFloat {
        get { closeButtonSubUIModel.dimension }
        set { closeButtonSubUIModel.dimension = newValue }
    }

    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonIconDimension: CGFloat {
        get { closeButtonSubUIModel.iconSize.width }
        set { closeButtonSubUIModel.iconSize = .init(dimension: newValue) }
    }
}

extension VBottomSheetUIModel.Colors {
    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonBackground: GenericStateModel_EnabledPressedDisabled<Color> {
        get { closeButtonSubUIModel.background }
        set { closeButtonSubUIModel.background = newValue }
    }
    
    @available(*, deprecated, message: "Use sub UI model instead")
    public var closeButtonIcon: GenericStateModel_EnabledPressedDisabled<Color> {
        get { closeButtonSubUIModel.icon }
        set { closeButtonSubUIModel.icon = newValue }
    }
}

// MARK: - V Toast
@available(*, deprecated, message: "Pass type to UI model instead")
public struct VToastTextLineType {
    let _toastTextLineType: VToastUIModel.Layout.TextLineType
    
    private init(
        toastTextLineType: VToastUIModel.Layout.TextLineType
    ) {
        self._toastTextLineType = toastTextLineType
    }
    
    public static var singleLine: Self {
        .init(toastTextLineType: .singleLine)
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(toastTextLineType: .multiLine(
            alignment: alignment,
            lineLimit: lineLimit
        ))
    }
}

extension View {
    @available(*, deprecated, message: "Pass type to UI model instead")
    public func vToast(
        id: String,
        uiModel: VToastUIModel = .init(),
        type toastTextLineType: VToastTextLineType,// = .singleLine,
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: String
    ) -> some View {
        vToast(
            id: id,
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.textLineType = toastTextLineType._toastTextLineType
                return uiModel
            }(),
            isPresented: isPresented,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            text: text
        )
    }
    
    @available(*, deprecated, message: "Pass type to UI model instead")
    public func vToast<Item>(
        id: String,
        uiModel: VToastUIModel = .init(),
        type toastTextLineType: VToastTextLineType,// = .singleLine,
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (Item) -> String
    ) -> some View
        where Item: Identifiable
    {
        vToast(
            id: id,
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.textLineType = toastTextLineType._toastTextLineType
                return uiModel
            }(),
            item: item,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            text: text
        )
    }
    
    @available(*, deprecated, message: "Pass type to UI model instead")
    public func vToast<T>(
        id: String,
        uiModel: VToastUIModel = .init(),
        type toastTextLineType: VToastTextLineType,// = .singleLine,
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (T) -> String
    ) -> some View {
        vToast(
            id: id,
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.textLineType = toastTextLineType._toastTextLineType
                return uiModel
            }(),
            isPresented: isPresented,
            presenting: data,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            text: text
        )
    }
    
    @available(*, deprecated, message: "Pass type to UI model instead")
    public func vToast<E>(
        id: String,
        uiModel: VToastUIModel = .init(),
        type toastTextLineType: VToastTextLineType,// = .singleLine,
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (E) -> String
    ) -> some View
        where E: Error
    {
        vToast(
            id: id,
            uiModel: {
                var uiModel = uiModel
                uiModel.layout.textLineType = toastTextLineType._toastTextLineType
                return uiModel
            }(),
            isPresented: isPresented,
            error: error,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            text: text
        )
    }
}

// MARK: - V Page Indicator
extension VPageIndicator {
    @available(*, deprecated, message: "Pass UI model type type parameter")
    public init(
        uiModel: VPageIndicatorUIModel,
        type pageIndicatorType: VPageIndicatorType = .default,
        total: Int,
        selectedIndex: Int
    )
        where Content == Never
    {
        self.init(
            type: pageIndicatorType,
            total: total,
            selectedIndex: selectedIndex
        )
    }
}

extension VPageIndicatorType {
    @available(*, deprecated, message: "Use method with UI model instead. Also, renamed to `standard`.")
    public static var finite: Self {
        standard()
    }
    
    @available(*, deprecated, message: "Use method with UI model instead. Also, renamed to `compact`.")
    public static func infinite(
        visible: Int = 7,
        center: Int = 3
    ) -> Self {
        compact(uiModel: {
            var uiModel: VPageIndicatorCompactUIModel = .init()
            uiModel.layout.visibleDots = visible
            uiModel.layout.centerDots = center
            return uiModel
        }())
    }
    
    @available(*, deprecated, message: "Use method with UI model instead")
    public static func automatic(
        visible: Int = 7,
        center: Int = 3,
        finiteLimit: Int = 10
    ) -> Self {
        automatic(uiModel: {
            var uiModel: VPageIndicatorAutomaticUIModel = .init()
            uiModel.layout.visibleDots = visible
            uiModel.layout.centerDots = center
            uiModel.layout.standardDotLimit = finiteLimit
            return uiModel
        }())
    }
}

@available(*, deprecated, message: "`VPageIndicatorUIModel` no longer exists, and is split into 3 UI models")
public typealias VPageIndicatorUIModel = VPageIndicatorAutomaticUIModel

extension VPageIndicatorAutomaticUIModel.Layout {
    @available(*, deprecated, renamed: "standardDotLimit")
    public var finiteDotLimit: Int {
        get { standardDotLimit }
        set { standardDotLimit = newValue }
    }
    
    @available(*, deprecated, renamed: "visibleDotsForCompactConfiguration")
    public var visibleDots: Int {
        get { visibleDotsForCompactConfiguration }
        set { visibleDotsForCompactConfiguration = newValue }
    }
    
    @available(*, deprecated, renamed: "centerDotsForCompactConfiguration")
    public var centerDots: Int {
        get { centerDotsForCompactConfiguration }
        set { centerDotsForCompactConfiguration = newValue }
    }
}

extension VPageIndicatorAutomaticUIModel.Layout {
    @available(*, unavailable, message: "Use `dotDimensionPrimaryAxisForStandardConfiguration`, `dotDimensionPrimaryAxisForCompactConfiguration` and `dotDimensionSecondaryAxis` instead")
    public var dotDimension: CGFloat { 10 }
}

// MARK: - Internal Components
@available(*, unavailable)
public struct VChevronButtonUIModel {}

@available(*, unavailable)
public struct VCloseButtonUIModel {}

// MARK: - V Components Localization Manager
@available(*, deprecated, renamed: "VComponentsLocalizationManager")
public typealias VComponentsLocalizationService = VComponentsLocalizationManager
