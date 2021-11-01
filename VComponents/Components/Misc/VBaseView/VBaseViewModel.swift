//
//  VBaseViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Base View Model
/// Model that describes UI.
public struct VBaseViewModel {
    // MARK: Properties
    /// Reference to `VChevronButtonModel`.
    public static let chevronButtonModel: VChevronButtonModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Navigation bar horizontal margin. Defaults to `15`.
        public var navBarMarginHorizontal: CGFloat = 15
        
        /// Navigation bar item spacing. Defaults to `10`.
        public var navBarSpacing: CGFloat = 10
        
        var width: CGFloat { UIScreen.main.bounds.width - 2 * navBarMarginHorizontal }
        
        /// Navigation bar title position. Defaults to `default`.
        public var titlePosition: TitlePosition = .default
        
        /// Back button dimension. Default to `32`.
        public var backButtonDimension: CGFloat = VBaseViewModel.chevronButtonModel.layout.dimension
        
        /// Back button icon dimension. Default to `12`.
        public var backButtonIconDimension: CGFloat = VBaseViewModel.chevronButtonModel.layout.iconDimension
        
        /// Back button icon x offset. Defaults to `0`.
        ///
        /// - Positive values shift icon to the right, while negative, to the left.
        /// - Can be used to shift back button to left, when it's background is set to transparent, similar to native back button in iOS.
        public var backButtonIconOffsetX: CGFloat = 0

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Title Position
        /// Enum that describes title position, such as `center` or `leading`.
        public enum TitlePosition: Int, CaseIterable {
            // MARK: Cases
            /// Center alignment.
            case center
            
            /// Leading alignment.
            case leading
            
            // MARK: Initailizers
            /// Default value. Set to `center`.
            public static var `default`: Self { .center }
        }
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Title color.
        ///
        /// Only applicable when using init with title.
        public var titleText: Color = ColorBook.primary
        
        /// Back button background colors.
        public var backButtonBackground: StateColors = VBaseViewModel.chevronButtonModel.colors.background
        
        /// Back button background colors and opacities.
        public var backButtonIcon: StateColorsAndOpacities = VBaseViewModel.chevronButtonModel.colors.content
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_EPD
        
        // MARK: State Colors and Opacities
        /// Sub-model containing colors and opacities for component states.
        public typealias StateColorsAndOpacities = StateColorsAndOpacities_EPD_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font.
        ///
        /// Only applicable when using init with title.
        public var title: Font = .system(size: 17, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
    var backButtonSubModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.backButtonDimension
        model.layout.iconDimension = layout.backButtonIconDimension
        model.layout.hitBox.horizontal = 0
        model.layout.hitBox.vertical = 0
        model.layout.navigationBarBackButtonOffsetX = layout.backButtonIconOffsetX
        
        model.colors.background = colors.backButtonBackground
        model.colors.content = colors.backButtonIcon
        
        return model
    }
}
