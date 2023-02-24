//
//  VMarqueeType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import Foundation

// MARK: - V Marquee Type
/// Enum that represents `VMarquee` type, such as `wrapping` or `bouncing`.
public struct VMarqueeType {
    // MARK: Properties
    let _marqueeType: _VMarqueeType
    
    // MARK: Initializers
    private init(
        marqueeType: _VMarqueeType
    ) {
        self._marqueeType = marqueeType
    }
    
    /// Wrapping marquee.
    public static func wrapping(
        uiModel: VMarqueeWrappingUIModel = .init()
    ) -> Self {
        .init(marqueeType: .wrapping(
            uiModel: uiModel
        ))
    }
    
    /// Bouncing marquee.
    public static func bouncing(
        uiModel: VMarqueeBouncingUIModel = .init()
    ) -> Self {
        .init(marqueeType: .bouncing(
            uiModel: uiModel
        ))
    }
    
    /// Default value. Set to `bouncing`.
    public static var `default`: Self { .wrapping() }
}

// MARK: - _ V Marquee Type
enum _VMarqueeType {
    case wrapping(uiModel: VMarqueeWrappingUIModel)
    case bouncing(uiModel: VMarqueeBouncingUIModel)
}
