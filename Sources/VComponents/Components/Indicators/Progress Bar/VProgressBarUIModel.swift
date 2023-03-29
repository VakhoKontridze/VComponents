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
        /// Slider height.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `10` on `tvOS`.
        /// Set to `5` on `watchOS`.
        public var height: CGFloat = GlobalUIModel.Common.barHeight
        
        /// Slider corner radius.
        /// Set to `5` on `iOS`.
        /// Set to `5` on `macOS`.
        /// Set to `5` on `tvOS`.
        /// Set to `2.5` on `watchOS`
        public var cornerRadius: CGFloat = GlobalUIModel.Common.barCornerRadius
        
        /// Indicates if progress bar rounds progress view right-edge. Set to `true`.
        public var roundsProgressViewRightEdge: Bool = true
        
        var progressViewRoundedCorners: RectCorner {
            if roundsProgressViewRightEdge {
                return .allCorners
            } else {
                return []
            }
        }
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Track color.
        public var track: Color = ColorBook.layerGray
        
        /// Progress color.
        public var progress: Color = ColorBook.accentBlue

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Progress animation. Set to `default`.
        public var progress: Animation? = .default

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
