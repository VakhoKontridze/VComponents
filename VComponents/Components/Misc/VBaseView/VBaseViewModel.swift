//
//  VBaseViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base View Model
/// Model that describes UI
public struct VBaseViewModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VBaseViewModel {
    /// Sub-model containing layout properties
    public struct Layout {
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

        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VBaseViewModel.Layout {
    /// Enum that describes title position, such as `center` or `leading`
    public enum TitlePosition: Int, CaseIterable {
        /// Center alignment
        case center
        
        /// Leading alignment
        case leading
        
        /// Default value. Set to `leading`.
        public static let `default`: Self = .leading
    }
}

// MARK:- Colors
extension VBaseViewModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Title color
        ///
        /// Only applicable when using init with title
        public var titleText: Color = ColorBook.primary
        
        /// Back button background colors
        public var backButtonBackground: StateColors = VBaseViewModel.chevronButtonModel.colors.background
        
        /// Back button background colors and opacities
        public var backButtonIcon: StateColorsAndOpacities = VBaseViewModel.chevronButtonModel.colors.content
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VBaseViewModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsEPD
    
    /// Sub-model containing colors and opacities for component states
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- Fonts
extension VBaseViewModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font
        ///
        /// Only applicable when using init with title
        public var title: Font = .system(size: 17, weight: .semibold)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VBaseViewModel {
    /// Reference to `VChevronButtonModel`
    public static let chevronButtonModel: VChevronButtonModel = .init()
}

// MARK:- Sub-Models
extension VBaseViewModel {
    var backButtonSubModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.backButtonDimension
        model.layout.iconDimension = layout.backButtonIconDimension
        model.layout.hitBox.horizontal = 0
        model.layout.hitBox.vertical = 0
        
        model.colors.background = colors.backButtonBackground
        model.colors.content = colors.backButtonIcon
        
        return model
    }
}
