//
//  VCompactPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI
import VCore

// MARK: - V Compact Page Indicator UI Model
/// Model that describes UI.
public struct VCompactPageIndicatorUIModel {
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
        
        /// Dot width, but height for vertical layouts.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        public var dotWidth: CGFloat = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot width, but height for vertical layouts, when switching to `standard` configuration.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotWidthForStandardConfiguration: CGFloat? = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot height, but width for vertical layouts.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        public var dotHeight: CGFloat = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Border width. Set to `0.`
        ///
        /// To hide border, set to `0`.
        public var dotBorderWidth: CGFloat = 0
        
        /// Dot spacing.
        /// Set to `5` on `iOS`.
        /// Set to `5` on `macOS`.
        /// Set to `10` on `tvOS`.
        /// Set to `3` on `watchOS`.
        public var spacing: CGFloat = GlobalUIModel.Indicators.pageIndicatorSpacing
        
        /// Number of visible dots. Set to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDots: Int = GlobalUIModel.Indicators.pageIndicatorCompactVisibleDots
        
        /// Number of center dots. Set to `3`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDots: Int = GlobalUIModel.Indicators.pageIndicatorCompactCenterDots
        
        var sideDots: Int { (visibleDots - centerDots) / 2 }
        
        var middleDots: Int { visibleDots / 2 }

        /// Scale of dot at the edge. Set to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScale: CGFloat = GlobalUIModel.Indicators.pageIndicatorCompactEdgeDotScale
        
        /// Unselected dot scale when switching to `standard` configuration. Set to `0.85`.
        public var unselectedDotScaleForStandardConfiguration: CGFloat = GlobalUIModel.Indicators.pageIndicatorStandardUnselectedDotScale
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        init(
            direction: LayoutDirectionOmni,
            dotWidth: CGFloat,
            dotWidthForStandardConfiguration: CGFloat?,
            dotHeight: CGFloat,
            spacing: CGFloat,
            visibleDots: Int,
            centerDots: Int,
            edgeDotScale: CGFloat,
            unselectedDotScaleForStandardConfiguration: CGFloat
        ) {
            self.direction = direction
            self.dotWidth = dotWidth
            self.dotWidthForStandardConfiguration = dotWidthForStandardConfiguration
            self.dotHeight = dotHeight
            self.spacing = spacing
            self.visibleDots = visibleDots
            self.centerDots = centerDots
            self.edgeDotScale = edgeDotScale
            self.unselectedDotScaleForStandardConfiguration = unselectedDotScaleForStandardConfiguration
        }
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public typealias Colors = VPageIndicatorUIModel.Colors

    // MARK: Animations
    /// Model that contains animation properties.
    public typealias Animations = VPageIndicatorUIModel.Animations
    
    // MARK: Sub UI Models
    var standardPageIndicatorSubUIModel: VPageIndicatorUIModel {
        .init(
            layout: VPageIndicatorUIModel.Layout(
                direction: layout.direction,
                dotWidth: layout.dotWidthForStandardConfiguration,
                dotHeight: layout.dotHeight,
                dotBorderWidth: layout.dotBorderWidth,
                unselectedDotScale: layout.unselectedDotScaleForStandardConfiguration,
                spacing: layout.spacing
            ),
            colors: colors,
            animations: animations
        )
    }
}

// MARK: - Factory
extension VCompactPageIndicatorUIModel {
    /// `VCompactPageIndicatorUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.direction = .topToBottom
        
        return uiModel
    }
}
