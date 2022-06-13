//
//  VAlertModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert Model
/// Model that describes UI.
public struct VAlertModel {
    // MARK: Properties
    fileprivate static let primaryButtonReference: VPrimaryButtonModel = .init()
    fileprivate static let modalReference: VModalModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()

    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Alert sizes.
        /// Set to `0.75` ratio of screen width in portrait.
        /// Set to `0.5` ratio of screen width in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(.init(width: 0.75)),
            landscape: .fraction(.init(width: 0.5))
        )
        
        /// Rounded corners. Defaults to to `allCorners`.
        public var roundedCorners: UIRectCorner = .allCorners
        
        /// Corner radius. Defaults to `20`.
        public var cornerRadius: CGFloat = 20
        
        /// Additional margisn applied to title, message, and content as a whole. Defaults to `15` leading, `15` trailing,`20` top, and `10` bottom.
        public var titleMessageContentMargins: Margins = .init(
            leading: modalReference.layout.contentMargins.horizontal / 2,
            trailing: modalReference.layout.contentMargins.horizontal / 2,
            top: 20,
            bottom: 10
        )
        
        /// Title line limit. Defaults to `1`.
        public var titleLineLimit: Int? = 1
        
        /// Title margins. Defaults to `0` horizontal and `5` vertical.
        public var titleMargins: Margins = .init(
            horizontal: 0,
            vertical: 5
        )
        
        /// Message line limit. Defaults to `5`.
        public var messageLineLimit: Int? = 5
        
        /// Title margins. Defaults to `0` horizontal and `5` vertical.
        public var messageMargins: Margins = .init(
            horizontal: 0,
            vertical: 5
        )
        
        /// Content margins  Defaults to `0` leading, `0` trailing, `10` top, and `0` bottom.
        public var contentMargins: Margins = .init(
            leading: 0,
            trailing: 0,
            top: 10,
            bottom: 0
        )
        
        /// Button height. Defaults to  `40`.
        public var buttonHeight: CGFloat = 40
        
        /// Button corner radius. Defaults to `10`.
        public var buttonCornerRadius: CGFloat = 10
        
        /// Button margins. Defaults to `15` leading, `15` trailing, `15` top, and `20` bottom.
        public var buttonMargins: Margins = .init(
            leading: modalReference.layout.contentMargins.leading,
            trailing: modalReference.layout.contentMargins.trailing,
            top: 10,
            bottom: 20
        )
        
        /// Spacing between horizontal buttons.  Defaults to `10`.
        public var horizontalButtonSpacing: CGFloat = 10
        
        /// Spacing between vertical buttons.  Defaults to `5`.
        public var verticallButtonSpacing: CGFloat = 5
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that describes modal sizes.
        public typealias Sizes = ModalSizes<AlertSize>
        
        // MARK: Alert Size
        /// Alert size.
        public struct AlertSize: Equatable {
            // MARK: Properties
            /// Width.
            public var width: CGFloat
            
            // MARK: Initializers
            /// Initializes `BottomSheetSize`.
            public init(
                width: CGFloat
            ) {
                self.width = width
            }
        }
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Backgrond color.
        public var background: Color = modalReference.colors.background
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Defaults to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Defaults to `zero`.
        public var shadowOffset: CGSize = .zero
        
        /// Dimming view color.
        public var dimmingView: Color = modalReference.colors.dimmingView
        
        /// Title color.
        public var title: Color = ColorBook.primary
        
        /// Message color.
        public var message: Color = ColorBook.primary
        
        /// Primary button background colors.
        public var primaryButtonBackground: ButtonStateColors = .init(primaryButtonReference.colors.background)
        
        /// Primary button title colors.
        public var primaryButtonTitle: ButtonStateColors = .init(primaryButtonReference.colors.title)
        
        /// Secondary button background colors.
        public var secondaryButtonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(componentAsset: "Alert.SecondaryButton.Background.pressed"),
            disabled: .clear
        )
        
        /// Secondary button title colors.
        public var secondaryButtonTitle: ButtonStateColors = .init(
            enabled: primaryButtonReference.colors.background.enabled,
            pressed: primaryButtonReference.colors.background.enabled,
            disabled: primaryButtonReference.colors.background.disabled
        )
        
        /// Destructive button background colors.
        public var destructiveButtonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(componentAsset: "Alert.SecondaryButton.Background.pressed"),
            disabled: .clear
        )
        
        /// Destructive button title colors.
        public var destructiveButtonTitle: ButtonStateColors = .init(
            enabled: .init(componentAsset: "Alert.DesctructiveButton.Title.enabled"),
            pressed: .init(componentAsset: "Alert.DesctructiveButton.Title.enabled"),
            disabled: .init(componentAsset: "Alert.DesctructiveButton.Title.disabled")
        )

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        /// Sub-model containing colors for button states.
        public typealias ButtonStateColors = GenericStateModel_EPD<Color>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` and weight `bold`.
        public var title: Font = .system(size: 16, weight: .bold)
        
        /// Message font. Defaults to system font of size `15`.
        public var message: Font = .system(size: 14)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public typealias Animations = VModalModel.Animations
    
    // MARK: Sub-Models
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundedCorners
        model.layout.cornerRadius = layout.cornerRadius
        
        model.colors.background = colors.background
        
        return model
    }
    
    var primaryButtonSubModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()
        
        model.layout.height = layout.buttonHeight
        model.layout.cornerRadius = layout.buttonCornerRadius
        
        model.colors.background = .alertButton(colors.primaryButtonBackground)
        model.colors.title = .alertButton(colors.primaryButtonTitle)

        return model
    }
    
    var secondaryButtonSubModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()
        
        model.layout.height = layout.buttonHeight
        model.layout.cornerRadius = layout.buttonCornerRadius
        
        model.colors.background = .alertButton(colors.secondaryButtonBackground)
        model.colors.title = .alertButton(colors.secondaryButtonTitle)

        return model
    }
    
    var destructiveButtonSubModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()
        
        model.layout.height = layout.buttonHeight
        model.layout.cornerRadius = layout.buttonCornerRadius
        
        model.colors.background = .alertButton(colors.destructiveButtonBackground)
        model.colors.title = .alertButton(colors.destructiveButtonTitle)

        return model
    }
}

// MARK: - Helpers
extension GenericStateModel_EPDL where Value == Color {
    fileprivate static func alertButton(_ model: GenericStateModel_EPD<Color>) -> Self {
        self.init(
            enabled: model.enabled,
            pressed: model.pressed,
            disabled: model.disabled,
            loading: .clear // Doesn't matter
        )
    }
}
