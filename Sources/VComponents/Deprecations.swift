//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

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

@available(*, deprecated, message: "`VPageIndicatorUIModel` no longer exists, and is split into 3 UI models")
public typealias VPageIndicatorUIModel = VPageIndicatorAutomaticUIModel

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

@available(*, deprecated, renamed: "VPageIndicatorStandardUIModel")
public typealias VPageIndicatorFiniteUIModel = VPageIndicatorStandardUIModel

@available(*, deprecated, renamed: "VPageIndicatorCompactUIModel")
public typealias VPageIndicatorInfiniteUIModel = VPageIndicatorCompactUIModel

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

extension VPageIndicatorStandardUIModel.Layout {
    @available(*, unavailable, message: "Use `dotDimensionPrimaryAxis` and `dotDimensionSecondaryAxis` instead")
    public var dotDimension: CGFloat { 10 }
}

extension VPageIndicatorCompactUIModel.Layout {
    @available(*, unavailable, message: "Use `dotDimensionPrimaryAxis`, `dotDimensionPrimaryAxisForStandardConfiguration` and `dotDimensionSecondaryAxis` instead")
    public var dotDimension: CGFloat { 10 }
}

extension VPageIndicatorAutomaticUIModel.Layout {
    @available(*, unavailable, message: "Use `dotDimensionPrimaryAxisForStandardConfiguration`, `dotDimensionPrimaryAxisForCompactConfiguration` and `dotDimensionSecondaryAxis` instead")
    public var dotDimension: CGFloat { 10 }
}

// MARK: - V Components Localization Manager
@available(*, deprecated, renamed: "VComponentsLocalizationManager")
public typealias VComponentsLocalizationService = VComponentsLocalizationManager
