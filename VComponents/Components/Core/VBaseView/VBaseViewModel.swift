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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    public init() {}
}

// MARK:- Layout
extension VBaseViewModel {
    public struct Layout {
        public var margin: CGFloat = 15
        public var spacing: CGFloat = 10
        var width: CGFloat { UIScreen.main.bounds.width - 2 * margin }
        
        public var titlePosition: TitlePosition = .default
        
        public var backButtonDimension: CGFloat = VBaseViewModel.chevronButtonModel.layout.dimension
        public var backButtonIconDimension: CGFloat = VBaseViewModel.chevronButtonModel.layout.iconDimension

        public init() {}
    }
}

extension VBaseViewModel.Layout {
    /// Enum that describes title position, such as center or leading
    public enum TitlePosition: Int, CaseIterable {
        case center
        case leading
        
        public static let `default`: Self = .leading
    }
}

// MARK:- Colors
extension VBaseViewModel {
    public struct Colors {
        public var titleText: Color = ColorBook.primary // Only applicable during init with title
        
        public var backButtonBackground: StateColors = VBaseViewModel.chevronButtonModel.colors.background
        
        public var backButtonIcon: StateColorsAndOpacities = VBaseViewModel.chevronButtonModel.colors.content
        
        public init() {}
    }
}

extension VBaseViewModel.Colors {
    public typealias StateColors = StateColorsEPD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- Fonts
extension VBaseViewModel {
    public struct Fonts {
        public var title: Font = .system(size: 17, weight: .semibold, design: .default) // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- References
extension VBaseViewModel {
    public static let chevronButtonModel: VChevronButtonModel = .init()
}

// MARK:- Sub-Models
extension VBaseViewModel {
    var backButtonSubModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.backButtonDimension
        model.layout.iconDimension = layout.backButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = colors.backButtonBackground
        model.colors.content = colors.backButtonIcon
        
        return model
    }
}
