//
//  VMenuUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 31.03.23.
//

import SwiftUI
import VCore

// MARK: - V Menu UI Model
/// Model that describes UI.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()

    /// Model that contains color properties.
    public var colors: Colors = .init()

    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Title text minimum scale factor. Set to `0.75`.
        public var titleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

        /// Icon size. Set to `24x24`.
        public var iconSize: CGSize = .init(dimension: 24)

        /// Hit box. Set to `5`s.
        public var hitBox: HitBox = .init(5)

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}

        // MARK: Hit Box
        /// Model that contains `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HorizontalVertical
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Title text colors.
        public var titleText: StateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            disabled: ColorBook.controlLayerBlueDisabled
        )

        /// Icon colors.
        ///
        /// Applied to all images. But should be used for vector images.
        /// In order to use bitmap images, set this to `clear`.
        public var icon: StateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            disabled: ColorBook.controlLayerBlueDisabled
        )

        /// Icon opacities. Set to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>

        // MARK: State Colors
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title text font.
        /// Set to `body` (`17`) on `iOS`.
        /// Set to `body` (`13`) on `macOS`.
        public var titleText: Font = {
#if os(iOS)
            return Font.body
#elseif os(macOS)
            return Font.body
#else
            fatalError() // Not supported
#endif
        }()

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
