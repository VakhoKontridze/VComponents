//
//  VPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI

// MARK: - V Page Indicator UI Model
/// Model that describes UI.
public struct VPageIndicatorUIModel {
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
        /// Dot dimension. Defaults to `10`.
        public var dotDimension: CGFloat = 10
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = 5

        /// Unselected dot scale during finite type. Defaults to `0.85`.
        public var finiteDotScale: CGFloat = 0.85
        
        /// Edge dot scale during infinite type. Defaults to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var infiniteEdgeDotScale: CGFloat = 0.5
        
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
