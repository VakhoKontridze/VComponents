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
    public static let chevronButtonModel: VChevronButtonModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = .system(size: 17, weight: .semibold, design: .default)
    
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
        public var titleColor: Color = ColorBook.primary
        
        public var backButtonBackground: StateColors = VBaseViewModel.chevronButtonModel.colors.background
        
        public var backButtonIcon: StateColorsAndOpacity = VBaseViewModel.chevronButtonModel.colors.content
        
        public init() {}
    }
}

extension VBaseViewModel.Colors {
    public typealias StateColors = VChevronButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}
