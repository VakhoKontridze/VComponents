//
//  VProgressBarModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - V Progress Bar Model
/// Model that describes UI.
public struct VProgressBarModel {
    // MARK: Properties
    fileprivate static let sliderReference: VSliderModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Slider height. Defaults to `10`.
        public var height: CGFloat = sliderReference.layout.height
        
        /// Slider corner radius. Defaults to `5`.
        public var cornerRadius: CGFloat = sliderReference.layout.cornerRadius
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Track color.
        public var track: Color = sliderReference.colors.track.enabled
        
        /// Progress color.
        public var progress: Color = sliderReference.colors.progress.enabled

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Progress animation. Defaults to `default`.
        public var progress: Animation? = .default

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
    var sliderSubModel: VSliderModel {
        var model: VSliderModel = .init()
        
        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.thumbDimension = 0
        
        model.colors.track = .init(
            enabled: colors.track,
            disabled: VProgressBarModel.sliderReference.colors.track.disabled
        )
        
        model.colors.progress = .init(
            enabled: colors.progress,
            disabled: VProgressBarModel.sliderReference.colors.progress.disabled
        )
        
        model.animations.progress = animations.progress
        
        return model
    }
}
