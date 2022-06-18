//
//  VProgressBarUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - V Progress Bar UI Model
/// Model that describes UI.
public struct VProgressBarUIModel {
    // MARK: Properties
    fileprivate static let sliderReference: VSliderUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Slider height. Defaults to `10`.
        public var height: CGFloat = sliderReference.layout.height
        
        /// Slider corner radius. Defaults to `5`.
        public var cornerRadius: CGFloat = sliderReference.layout.cornerRadius
        
        /// Indicates if progress bar rounds progress view right-edge. Defaults to `true`.
        public var roundsProgressViewRightEdge: Bool = true
        
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
    var sliderSubUIModel: VSliderUIModel {
        var uiModel: VSliderUIModel = .init()
        
        uiModel.layout.height = layout.height
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.roundsProgressViewRightEdge = layout.roundsProgressViewRightEdge
        uiModel.layout.thumbDimension = 0
        
        uiModel.colors.track.enabled = colors.track
        uiModel.colors.progress.enabled = colors.progress
        
        uiModel.animations.progress = animations.progress
        
        return uiModel
    }
}
