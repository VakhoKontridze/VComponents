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
    ) {
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
    @available(*, deprecated, message: "Use method with UI model instead")
    public static var finite: Self {
        finite()
    }
    
    @available(*, deprecated, message: "Use method with UI model instead")
    public static func infinite(
        visible: Int = 7,
        center: Int = 3
    ) -> Self {
        infinite(uiModel: {
            var uiModel: VPageIndicatorInfiniteUIModel = .init()
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
            uiModel.layout.finiteDotLimit = finiteLimit
            return uiModel
        }())
    }
}

// MARK: - V Components Localization Manager
@available(*, deprecated, renamed: "VComponentsLocalizationManager")
public typealias VComponentsLocalizationService = VComponentsLocalizationManager
