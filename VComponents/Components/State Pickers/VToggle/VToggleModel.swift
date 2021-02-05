//
//  VToggleRightContentModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Model
/// Model that describes UI
public struct VToggleModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VToggleModel {
    public struct Layout {
        public var size: CGSize = .init(width: 51, height: 31)
        var cornerRadius: CGFloat { size.height }
        
        public var thumbDimension: CGFloat = 27
        
        public var contentMarginLeading: CGFloat = 5
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumnStartPoint - spacing
            return offset
        }
    }
}

// MARK:- Colors
extension VToggleModel {
    public struct Colors {
        public var fill: StateColors = .init(
            off: .init(componentAsset: "Toggle.Fill.off"),
            on: primaryButtonReference.colors.background.enabled,
            disabled: .init(componentAsset: "Toggle.Fill.disabled")
        )
        
        public var thumb: StateColors = .init(
            off: .init(componentAsset: "Toggle.Thumb"),
            on: .init(componentAsset: "Toggle.Thumb"),
            disabled: .init(componentAsset: "Toggle.Thumb")
        )
        
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
            off: ColorBook.primary,
            on: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public init() {}
    }
}

extension VToggleModel.Colors {
    public typealias StateColors = StateColorsOOD

    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VToggleModel {
    public struct Fonts {
        public var title: Font = .system(size: 15, weight: .regular, design: .default)    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VToggleModel {
    public struct Animations {
        public var stateChange: Animation? = .easeIn(duration: 0.1)
        
        public init() {}
    }
}

// MARK:- Misc
extension VToggleModel {
    public struct Misc {
        public var contentIsClickable: Bool = true
        
        public init() {}
    }
}

// MARK:- References
extension VToggleModel {
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
}
