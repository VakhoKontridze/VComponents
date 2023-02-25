//
//  VPageIndicatorFiniteUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator Finite UI Model
/// Model that describes UI.
public struct VPageIndicatorFiniteUIModel {
    // MARK: Properties
    fileprivate static let progressBarReference: VProgressBarUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Axis. Defaults to `horizontal`.
        public var axis: Axis = .horizontal
        
        /// Dot dimension. Defaults to `10`.
        public var dotDimension: CGFloat = 10
        
        /// Unselected dot scale. Defaults to `0.85`.
        public var unselectedDotScale: CGFloat = 0.85
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = 5
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Dot color.
        public var dot: Color = .init(componentAsset: "PageIndicator.Dot")
        
        /// Selected dot color.
        public var selectedDot: Color = progressBarReference.colors.progress
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Transition animation. Defaults to `linear` with duration `0.15`.
        public var transition: Animation = .linear(duration: 0.15)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}

// MARK: - Factory
extension VPageIndicatorFiniteUIModel {
    /// ???.
    public static var horizontal: VPageIndicatorFiniteUIModel {
        var uiModel: VPageIndicatorFiniteUIModel = .init()
        
        uiModel.layout.axis = .horizontal
        
        return uiModel
    }
    
    /// ???.
    public static var vertical: VPageIndicatorFiniteUIModel {
        var uiModel: VPageIndicatorFiniteUIModel = .init()
        
        uiModel.layout.axis = .vertical
        
        return uiModel
    }
}
