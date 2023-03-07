//
//  VPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator UI Model
/// Model that describes UI.
public struct VPageIndicatorUIModel {
    // MARK: Properties
    fileprivate static let progressBarReference: VProgressBarUIModel = .init()
    
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    init(
        layout: Layout,
        colors: Colors,
        animations: Animations
    ) {
        self.layout = layout
        self.colors = colors
        self.animations = animations
    }

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Direction. Defaults to `leftToRight`.
        public var direction: LayoutDirectionOmni = .leftToRight
        
        /// Dot dimension on the main axis. Defaults to `10`.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotDimensionPrimaryAxis: CGFloat? = 10
        
        /// Dot dimension on the secondary axis. Defaults to `10`.
        ///
        /// For horizontal layouts, this will be height, and for vertical, width.
        public var dotDimensionSecondaryAxis: CGFloat = 10
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = 5
        
        /// Unselected dot scale. Defaults to `0.85`.
        public var unselectedDotScale: CGFloat = 0.85
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        init(
            direction: LayoutDirectionOmni,
            dotDimensionPrimaryAxis: CGFloat?,
            dotDimensionSecondaryAxis: CGFloat,
            spacing: CGFloat,
            unselectedDotScale: CGFloat
        ) {
            self.direction = direction
            self.dotDimensionPrimaryAxis = dotDimensionPrimaryAxis
            self.dotDimensionSecondaryAxis = dotDimensionSecondaryAxis
            self.spacing = spacing
            self.unselectedDotScale = unselectedDotScale
        }
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Dot color.
        public var dot: Color = .init(componentAsset: "PageIndicator.Dot")
        
        /// Selected dot color.
        public var selectedDot: Color = progressBarReference.colors.progress
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Transition animation. Defaults to `linear` with duration `0.15`.
        public var transition: Animation = .linear(duration: 0.15)
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
}

// MARK: - Factory
extension VPageIndicatorUIModel {
    /// `VPageIndicatorUIModel` with vertical layout.
    public static var vertical: VPageIndicatorUIModel {
        var uiModel: VPageIndicatorUIModel = .init()
        
        uiModel.layout.direction = .topToBottom
        
        return uiModel
    }
}
