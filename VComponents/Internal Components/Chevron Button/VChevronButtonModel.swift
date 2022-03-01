//
//  VChevronButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK: - V Chevron Button Model
public struct VChevronButtonModel {
    // MARK: Properties
    var layout: Layout = .init()
    var colors: Colors = .init()

    // MARK: Layout
    public struct Layout {
        // MARK: Properties
        public var dimension: CGFloat = 32
        
        public var iconDimension: CGFloat = 12
        
        public var hitBox: HitBox = .init(
            horizontal: 0,
            vertical: 0
        )
        
        // MARK: Hit Box
        public typealias HitBox = EdgeInsets_HV
    }

    // MARK: Colors
    public struct Colors {
        // MARK: Properties
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "ChevronButton.Background.enabled"),
            pressed: .init(componentAsset: "ChevronButton.Background.pressed"),
            disabled: .init(componentAsset: "ChevronButton.Background.disabled")
        )
        
        public var icon: StateColors = .init(
            enabled: ColorBook.primary, // FIXME
            pressed: ColorBook.primary, // FIXME
            disabled: ColorBook.primary // FIXME
        )
        
        // MARK: State Colors
        public typealias StateColors = VSquareButtonModel.Colors.StateColors
    }
    
    // MARK: Sub-Models
    var squareButtonSubModel: VSquareButtonModel {
        var model: VSquareButtonModel = .init()

        model.layout.dimension = layout.dimension
        model.layout.iconSize = .init(dimension: layout.iconDimension)
        model.layout.hitBox = layout.hitBox

        model.colors.background = colors.background
        model.colors.icon = colors.icon

        return model
    }
}
