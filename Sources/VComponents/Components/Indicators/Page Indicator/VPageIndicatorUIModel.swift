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
        /// Direction. Set to `leftToRight`.
        public var direction: LayoutDirectionOmni = .leftToRight
        
        /// Dot dimension on the main axis.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotDimensionPrimaryAxis: CGFloat? = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot dimension on the secondary axis.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        ///
        /// For horizontal layouts, this will be height, and for vertical, width.
        public var dotDimensionSecondaryAxis: CGFloat = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Border width. Set to `0.`
        ///
        /// To hide border, set to `0`.
        public var dotBorderWidth: CGFloat = 0
        
        /// Unselected dot scale. Set to `0.85`.
        public var unselectedDotScale: CGFloat = GlobalUIModel.Indicators.pageIndicatorStandardUnselectedDotScale
        
        /// Dot spacing.
        /// Set to `5` on `iOS`.
        /// Set to `5` on `macOS`.
        /// Set to `10` on `tvOS`.
        /// Set to `3` on `watchOS`.
        public var spacing: CGFloat = GlobalUIModel.Indicators.pageIndicatorSpacing
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        init(
            direction: LayoutDirectionOmni,
            dotDimensionPrimaryAxis: CGFloat?,
            dotDimensionSecondaryAxis: CGFloat,
            dotBorderWidth: CGFloat,
            unselectedDotScale: CGFloat,
            spacing: CGFloat
        ) {
            self.direction = direction
            self.dotDimensionPrimaryAxis = dotDimensionPrimaryAxis
            self.dotDimensionSecondaryAxis = dotDimensionSecondaryAxis
            self.dotBorderWidth = dotBorderWidth
            self.unselectedDotScale = unselectedDotScale
            self.spacing = spacing
        }
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Dot color.
        public var dot: Color = .init(module: "PageIndicator.Dot")
        
        /// Selected dot color.
        public var selectedDot: Color = ColorBook.accentBlue
        
        /// Dot border color.
        public var dotBorder: Color = .clear
        
        /// Selected dot border color.
        public var selectedDotBorder: Color = .clear
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Transition animation. Set to `linear` with duration `0.15`.
        public var transition: Animation = .linear(duration: 0.15)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}

// MARK: - Factory
extension VPageIndicatorUIModel {
    /// `VPageIndicatorUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.direction = .topToBottom
        
        return uiModel
    }
}
