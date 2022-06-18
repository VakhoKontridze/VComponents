//
//  VChevronButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VCore

// MARK: - V Chevron Button UI Model
public struct VChevronButtonUIModel {
    // MARK: Properties
    var layout: Layout = .init()
    var colors: Colors = .init()

    // MARK: Layout
    public struct Layout {
        // MARK: Properties
        public var dimension: CGFloat = 30
        
        public var iconDimension: CGFloat = 12
        
        public var hitBox: HitBox = .zero
        
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
            enabled: ColorBook.primary,
            pressed: ColorBook.primary, // Looks better without `primaryPressedDisabled`
            disabled: ColorBook.primaryBlackPressedDisabled
        )
        
        // MARK: State Colors
        public typealias StateColors = VSquareButtonUIModel.Colors.StateColors
    }
    
    // MARK: Sub-Models
    var squareButtonSubUIModel: VSquareButtonUIModel {
        var uiModel: VSquareButtonUIModel = .init()

        uiModel.layout.dimension = layout.dimension
        uiModel.layout.iconSize = .init(dimension: layout.iconDimension)
        uiModel.layout.hitBox = layout.hitBox

        uiModel.colors.background = colors.background
        uiModel.colors.icon = colors.icon

        return uiModel
    }
}
