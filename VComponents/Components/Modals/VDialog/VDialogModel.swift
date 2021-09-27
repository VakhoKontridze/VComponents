//
//  VDialogModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Dialog Model
/// Model that describes UI
public struct VDialogModel {
    // MARK: Properties
    /// Reference to `VModalModel`
    public static let modalReference: VModalModel = .init()
    
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()

    // MARK: Initializers
    /// Initializes model with default values
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties
    public struct Layout {
        // MARK: Properties
        /// Side bar width. Defaults to `0.75` ratio of screen with.
        public var width: CGFloat = UIScreen.main.bounds.width * 0.75
        
        /// Edges ignored by keyboard. Defaults to `none`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Corner radius. Defaults to `20`.
        public var cornerRadius: CGFloat = 20
        
        /// Margin. Defaults to `15`.
        public var margin: CGFloat = 15
        
        /// Additional spacing between title, description, and content. Defaults to `5`.
        public var titlesAndContentSpacing: CGFloat = 5
        
        /// Additional title, description, and content margins. Defaults to `0` horizontal, and `5` vertical.
        public var titlesAndContentMargins: TitleAndContentMargin = .init(
            horizontal: 0,
            vertical: 5
        )
        
        /// Additional content vertical margin. Defaults to `15`.
        public var contentMarginVertical: CGFloat = 15
        
        /// Spacing between buttons during two-button type. Defaults to `10`.
        public var twoButtonSpacing: CGFloat = 10
        
        /// Spacing between buttons during many-button type. Defaults to `10`.
        public var manyButtonSpacing: CGFloat = 10
        
        /// Description line limit. Defaults to `5`.
        public var descriptionLineLimit: Int = 5

        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
        
        // MARK: Title and Content Margin
        /// Sub-model containing `horizontal` and `vertical` margins
        public typealias TitleAndContentMargin = LayoutGroup_HV
    }

    // MARK: Colors
    /// Sub-model containing color properties
    public struct Colors {
        // MARK: Properties
        /// Backgrond color
        public var background: Color = modalReference.colors.background
        
        /// Blinding color
        public var blinding: Color = modalReference.colors.blinding
        
        /// Title color
        public var title: Color = ColorBook.primary
        
        /// Description color
        public var description: Color = ColorBook.primary

        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Fonts
    /// Sub-model containing font properties
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` and weight `bold`.
        public var title: Font = .system(size: 16, weight: .bold)
        
        /// Description font. Defaults to system font of size `15`.
        public var description: Font = .system(size: 14)
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties
    public typealias Animations = VModalModel.Animations
}
