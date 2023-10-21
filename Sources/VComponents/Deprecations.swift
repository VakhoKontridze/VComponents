//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}

// MARK: - V Bottom Sheet
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}
