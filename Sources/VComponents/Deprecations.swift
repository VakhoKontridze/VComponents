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
    @available(*, deprecated, renamed: "gradientMaskWidth")
    public var gradientWidth: CGFloat {
        get { gradientMaskWidth }
        set { gradientMaskWidth = newValue }
    }

    @available(*, deprecated, renamed: "insettedGradientMask")
    public static var insettedGradient: Self {
        insettedGradientMask
    }
}

// MARK: - V Bouncing Marquee
extension VBouncingMarqueeUIModel {
    @available(*, deprecated, renamed: "gradientMaskWidth")
    public var gradientWidth: CGFloat {
        get { gradientMaskWidth }
        set { gradientMaskWidth = newValue }
    }

    @available(*, deprecated, renamed: "insettedGradientMask")
    public static var insettedGradient: Self {
        insettedGradientMask
    }
}
