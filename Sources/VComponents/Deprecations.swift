//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Wrapping Marquee
extension VWrappingMarqueeUIModel {
    @available(*, deprecated, renamed: "wrappedContentSpacing")
    public var spacing: CGFloat {
        get { wrappedContentSpacing }
        set { wrappedContentSpacing = newValue }
    }
}
