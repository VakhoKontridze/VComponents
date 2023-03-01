//
//  VProgressBarUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore

// MARK: - V Progress Bar UI Model
/// Model that describes UI.
public struct VProgressBarUIModel {
    // MARK: Properties
    fileprivate static let sliderReference: VSliderUIModel = .init()
    
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Slider height. Defaults to `10`.
        public var height: CGFloat = sliderReference.layout.height
        
        /// Slider corner radius. Defaults to `5`.
        public var cornerRadius: CGFloat = sliderReference.layout.cornerRadius
        
        /// Indicates if progress bar rounds progress view right-edge. Defaults to `true`.
        public var roundsProgressViewRightEdge: Bool = true
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Track color.
        public var track: StateColors = sliderReference.colors.track
        
        /// Progress color.
        public var progress: StateColors = sliderReference.colors.progress

        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Progress animation. Defaults to `default`.
        public var progress: Animation? = .default

        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
    
    // MARK: Sub UI Models
    var sliderSubUIModel: VSliderUIModel {
        var uiModel: VSliderUIModel = .init()
        
        uiModel.layout.height = layout.height
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.roundsProgressViewRightEdge = layout.roundsProgressViewRightEdge
        uiModel.layout.thumbDimension = 0
        
        uiModel.colors.track = colors.track
        uiModel.colors.progress = colors.progress
        
        uiModel.animations.progress = animations.progress
        
        return uiModel
    }
}
