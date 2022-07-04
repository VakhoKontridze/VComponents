//
//  VWheelPickerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Wheel Picker UI Model
/// Model that describes UI.
public struct VWheelPickerUIModel {
    // MARK: Properties
    fileprivate static let segmentedPickerReference: VSegmentedPickerUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Picker corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Header line limit. Defaults to `1`.
        public var headerLineLimit: Int? = segmentedPickerReference.layout.headerLineLimit
        
        /// Footer line limit. Defaults to `5`.
        public var footerLineLimit: Int? = segmentedPickerReference.layout.footerLineLimit
        
        /// Spacing between header, picker, and footer. Defaults to `3`.
        public var headerPickerFooterSpacing: CGFloat = segmentedPickerReference.layout.headerPickerFooterSpacing
        
        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerMarginHorizontal: CGFloat = segmentedPickerReference.layout.headerFooterMarginHorizontal
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(ColorBook.layer)
        
        /// Title content colors.
        ///
        /// Only applicable when using `init`with title.
        public var title: StateColors = .init(segmentedPickerReference.colors.title)
        
        /// Custom content opacities.
        ///
        /// Applicable only when `init`with content is used.
        /// When using a custom content, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customContentOpacities: StateOpacities = .init(segmentedPickerReference.colors.customContentOpacities)
        
        /// Header colors.
        public var header: StateColors = segmentedPickerReference.colors.header
        
        /// Footer colors.
        public var footer: StateColors = segmentedPickerReference.colors.footer
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font. Defaults to system font of size `14`.
        public var header: Font = segmentedPickerReference.fonts.header
        
        /// Footer font. Defaults to system font of size `13`.
        public var footer: Font = segmentedPickerReference.fonts.footer
        
        /// Row font
        ///
        /// Only applicable when using `init`with title.
        public var rows: Font = segmentedPickerReference.fonts.rows
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
