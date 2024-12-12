//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet
extension VBottomSheetUIModel.Heights {
    @available(*, unavailable)
    public var isResizable: Bool { fatalError() }
    
    @available(*, unavailable)
    public var isFixed: Bool { fatalError() }
}

// MARK: - V Wrapping Marquee
extension VWrappingMarqueeUIModel {
    @available(*, deprecated, renamed: "wrappedContentSpacing")
    public var spacing: CGFloat {
        get { wrappedContentSpacing }
        set { wrappedContentSpacing = newValue }
    }
}
