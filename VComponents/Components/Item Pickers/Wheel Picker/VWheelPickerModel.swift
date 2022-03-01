//
//  VWheelPickerModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Wheel Picker Model
/// Model that describes UI.
public struct VWheelPickerModel {
    // MARK: Properties
    /// Reference to `VSegmentedPickerModel`.
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Picker corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Spacing between header and picker, and picker and footer. Defaults to `3`.
        public var headerFooterSpacing: CGFloat = segmentedPickerReference.layout.headerFooterSpacing
        
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
        /// Content opacities.
        public var content: StateOpacities = .init(
            disabledOpacity: segmentedPickerReference.colors.content.disabledOpacity
        )
        
        /// Text content colors.
        ///
        /// Only applicable when using init with title.
        public var textContent: StateColors = segmentedPickerReference.colors.textContent
        
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.layer,
            disabled: ColorBook.layer
        )

        /// Header colors.
        public var header: StateColors = segmentedPickerReference.colors.header
        
        /// Footer colors.
        public var footer: StateColors = segmentedPickerReference.colors.footer
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_ED
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = StateOpacities_D
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
        /// Only applicable when using init with title.
        public var rows: Font = segmentedPickerReference.fonts.rows
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
