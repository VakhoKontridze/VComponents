//
//  VTextViewUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI
import VCore

// MARK: - V Text View UI Model
/// Model that describes UI.
public struct VTextViewUIModel {
    // MARK: Properties
    fileprivate static let textFieldReference: VTextFieldUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()
    
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Textfield min height. Defaults to `50`.
        public var minHeight: CGFloat = textFieldReference.layout.height
        
        /// Textfield corner radius. Defaults to `12`.
        public var cornerRadius: CGFloat = textFieldReference.layout.cornerRadius

        /// Textfield text alignment. Defaults to `default`.
        public var textAlignment: TextAlignment = textFieldReference.layout.textAlignment

        /// Textfield border width. Defaults to `1`.
        public var borderWidth: CGFloat = textFieldReference.layout.borderWidth

        /// Content margin. Defaults to `15`. ???
        public var contentMargin: Margins = .init(textFieldReference.layout.contentMarginHorizontal)

        /// Header title line type. Defaults to `singleline`.
        public var headerTitleLineType: TextLineType = textFieldReference.layout.headerTitleLineType

        /// Footer title line type. Defaults to `multiline` of `1...5` lines.
        public var footerTitleLineType: TextLineType = textFieldReference.layout.footerTitleLineType

        /// Spacing between header, textview, and footer. Defaults to `3`.
        public var headerTextViewFooterSpacing: CGFloat = textFieldReference.layout.headerTextFieldFooterSpacing

        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerFooterMarginHorizontal: CGFloat = textFieldReference.layout.headerFooterMarginHorizontal
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// ???.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = textFieldReference.colors.background

        /// Border colors.
        public var border: StateColors = textFieldReference.colors.border

        /// Text colors.
        public var text: StateColors = textFieldReference.colors.text
        
        /// Placeholder colors.
        public var placeholder: StateColors = textFieldReference.colors.placeholder

        /// Header colors.
        public var header: StateColors = textFieldReference.colors.header

        /// Footer colors.
        public var footer: StateColors = textFieldReference.colors.footer
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public typealias Fonts = VTextFieldUIModel.Fonts

    // MARK: Misc
    /// Sub-model containing misc properties.
    public typealias Misc = VTextFieldUIModel.Misc
}
