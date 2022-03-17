//
//  VModalModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Modal Model
/// Model that describes UI.
public struct VModalModel {
    // MARK: Properties
    /// Reference to `VCloseButtonModel`.
    public static let closeButtonReference: VCloseButtonModel = .init()
    
    /// Reference to `VSheetModel`.
    public static let sheetReference: VSheetModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Modal size. Defaults to `0.9` ratio of screen with and `0.6` ratio of screen height.
        public var size: CGSize = .init(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.height * 0.6
        )
        
        /// Edges ignored by keyboard. Defaults to `none`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Rounded corners of modal. Defaults to to `default`.
        public var roundedCorners: RoundedCorners = sheetReference.layout.roundedCorners
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = sheetReference.layout.cornerRadius
        
        /// Header divider height. Defaults to `0`.
        public var headerDividerHeight: CGFloat = 0
        
        var hasDivider: Bool { headerDividerHeight > 0 }

        /// Close button dimension. Default to `32`.
        public var closeButtonDimension: CGFloat = closeButtonReference.layout.dimension
        
        /// Close button icon dimension. Default to `11`.
        public var closeButtonIconDimension: CGFloat = closeButtonReference.layout.iconDimension
        
        /// Header margins. Default to `10` leading, `10` trailing, `10` top, and `5` bottom.
        public var headerMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin,
            bottom: sheetReference.layout.contentMargin/2
        )
    
        /// Header divider margins. Default to `0` leading, `0` trailing, `5` top, and `5` bottom.
        public var headerDividerMargins: Margins = .init(
            leading: 0,
            trailing: 0,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin/2
        )
        
        /// Content margins. Default to `10` leading, `10` trailing, `5` top, and `5` bottom.
        public var contentMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin
        )
        
        /// Header item spacing. Defaults to `10`.
        public var headerSpacing: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Rounded Corners
        /// Enum that describes rounded corners, such as all, `top`, `bottom`, `custom`, or `none`.
        public typealias RoundedCorners = VSheetModel.Layout.RoundedCorners
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = sheetReference.colors.background
        
        /// Title header color.
        ///
        /// Only applicable when using init with title.
        public var headerTitle: Color = ColorBook.primary
        
        /// Close button background colors.
        public var closeButtonBackground: StateColors = closeButtonReference.colors.background
        
        /// Close button icon colors and opacities.
        public var closeButtonIcon: StateColors = closeButtonReference.colors.icon
        
        /// Header divider color.
        public var headerDivider: Color = .clear
        
        /// Blinding color.
        public var blinding: Color = .init(componentAsset: "Modal.Blinding")
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPD<Color>
        
        /// Sub-model containing colors for component states.
        public typealias StateColors_OLD = StateColors_EPD
        
        // MARK: State Colors and Opacities
        /// Sub-model containing colors and opacities for component states.
        public typealias StateColorsAndOpacities = StateColorsAndOpacities_EPD_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font.
        ///
        /// Only applicable when using init with title.
        public var header: Font = .system(size: 17, weight: .bold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Defaults to `linear` with duration `0.05`.
        public var appear: BasicAnimation? = .init(curve: .linear, duration: 0.05)
        
        /// Disappear animation. Defaults to `easeIn` with duration `0.05`.
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)
        
        /// Scale effect during appear and disappear. Defaults to `1.01`.
        public var scaleEffect: CGFloat = 1.01
        
        /// Opacity level during appear and disappear. Defaults to `0.5`.
        public var opacity: Double = 0.5
        
        /// Blur during appear and disappear. Defaults to `3`.
        public var blur: CGFloat = 3
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Defaults to `default`.
        public var dismissType: Set<DismissType> = .default
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Enum that decribes dismiss type, such as `leadingButton`, `trailingButton`, or `backTap`.
        public enum DismissType: Int, CaseIterable {
            /// Leading.
            case leadingButton
            
            /// Trailing.
            case trailingButton
            
            /// Backtap.
            case backTap
        }
    }

    // MARK: Sub-Models
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundedCorners
        model.layout.cornerRadius = layout.cornerRadius
        
        model.colors.background = colors.background
        
        return model
    }
    
    var closeButtonSubModel: VCloseButtonModel {
        var model: VCloseButtonModel = .init()
        
        model.layout.dimension = layout.closeButtonDimension
        model.layout.iconDimension = layout.closeButtonIconDimension
        model.layout.hitBox.horizontal = 0
        model.layout.hitBox.vertical = 0
        
        model.colors.background = colors.closeButtonBackground
        model.colors.icon = colors.closeButtonIcon
        
        return model
    }
}

// MARK: - Helpers
extension Set where Element == VModalModel.Misc.DismissType {
    /// Default value. Set to `trailingButton`.
    public static let `default`: Self = [.trailingButton]
    
    var hasButton: Bool {
        contains(where: { [.leadingButton, .trailingButton].contains($0) })
    }
}
