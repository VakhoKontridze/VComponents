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
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VToggleModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Toggle size. Defaults to `51` width and `32` height, similarly to native toggle.
        public var size: CGSize = .init(width: 51, height: 31)
        
        var cornerRadius: CGFloat { size.height }
        
        /// Thumb dimension. Defaults to `27`, similarly to native toggle.
        public var thumbDimension: CGFloat = 27
        
        /// Content leading margin. Defaults to `5`.
        public var contentMarginLeading: CGFloat = 5
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumnStartPoint - spacing
            return offset
        }
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VToggleModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Fill colors
        public var fill: StateColors = .init(
            off: .init(componentAsset: "Toggle.Fill.off"),
            on: primaryButtonReference.colors.background.enabled,
            disabled: .init(componentAsset: "Toggle.Fill.disabled")
        )
        
        /// Thumb colors
        public var thumb: StateColors = .init(
            off: .init(componentAsset: "Toggle.Thumb"),
            on: .init(componentAsset: "Toggle.Thumb"),
            disabled: .init(componentAsset: "Toggle.Thumb")
        )
        
        /// Content opacities
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        /// Text content colors
        ///
        /// Only applicable when using init with title
        public var textContent: StateColors = .init(
            off: ColorBook.primary,
            on: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VToggleModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_OOD

    /// Sub-model containing colors and opacities for component states
    public typealias StateOpacities = StateOpacities_PD
}

// MARK:- Fonts
extension VToggleModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using init with title
        public var title: Font = .system(size: 15)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VToggleModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = .easeIn(duration: 0.1)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VToggleModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VToggleModel {
    /// Reference to `VPrimaryButtonModel`
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
}
