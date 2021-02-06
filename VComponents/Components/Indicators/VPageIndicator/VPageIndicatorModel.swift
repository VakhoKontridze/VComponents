//
//  VPageIndicatorModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK:- V Page Indicator Model
/// Model that describes UI
public struct VPageIndicatorModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VPageIndicatorModel {
    public struct Layout {
        public var dotDimension: CGFloat = 10
        public var spacing: CGFloat = 5

        public var finiteDotScale: CGFloat = 0.85
        public var infiniteEdgeDotScale: CGFloat = 0.5
        
        public init() {}
    }
}

// MARK:- Colors
extension VPageIndicatorModel {
    public struct Colors {
        public var dot: Color = tabNavigationReference.colors.item
        public var selectedDot: Color = progressBarReference.colors.progress
        
        public init() {}
    }
}

// MARK:- Animations
extension VPageIndicatorModel {
    public struct Animations {
        public var transition: Animation = Animation.linear(duration: 0.15)
        
        public init() {}
    }
}

// MARK:- References
extension VPageIndicatorModel {
    public static let progressBarReference: VProgressBarModel = .init()
    public static let tabNavigationReference: VTabNavigationViewModel = .init()
}
