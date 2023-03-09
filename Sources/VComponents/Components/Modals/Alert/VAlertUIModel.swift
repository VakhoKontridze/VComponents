//
//  VAlertUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert UI Model
/// Model that describes UI.
public struct VAlertUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
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
        
        /// Additional margins applied to title, message, and content as a whole. Defaults to `15` leading, `15` trailing,`20` top, and `10` bottom.
        public var titleMessageContentMargins: Margins = .init(
            leading: GlobalUIModel.Common.containerContentMargin,
            trailing: GlobalUIModel.Common.containerContentMargin,
            top: 20,
            bottom: 10
        )
        
        /// Title text line type. Defaults to `singleLine`.
        public var titleTextLineType: TextLineType = .singleLine
        
        /// Title margins. Defaults to `0` horizontal and `5` vertical.
        public var titleMargins: Margins = .init(
            horizontal: 0,
            vertical: 5
        )
        
        /// Message line type. Defaults to `multiline` with `center` alignment and `1...5` lines.
        public var messageTextLineType: TextLineType = .multiLine(alignment: .center, lineLimit: 1...5)
        
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
            leading: GlobalUIModel.Common.containerContentMargin,
            trailing: GlobalUIModel.Common.containerContentMargin,
            top: 10,
            bottom: 20
        )
        
        /// Spacing between horizontal buttons.  Defaults to `10`.
        public var horizontalButtonSpacing: CGFloat = 10
        
        /// Spacing between vertical buttons.  Defaults to `5`.
        public var verticalButtonSpacing: CGFloat = 5
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeyboardSafeAreaEdges: Edge.Set = []

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that represents modal sizes.
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
        /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Defaults to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Defaults to `zero`.
        public var shadowOffset: CGSize = .zero
        
        /// Dimming view color.
        public var dimmingView: Color = GlobalUIModel.Common.dimmingViewColor
        
        /// Title color.
        public var title: Color = ColorBook.primary
        
        /// Message color.
        public var message: Color = ColorBook.primary
        
        /// Primary button background colors.
        public var primaryButtonBackground: ButtonStateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            pressed: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.controlLayerBlueDisabled
        )
        
        /// Primary button title colors.
        public var primaryButtonTitle: ButtonStateColors = .init(ColorBook.primaryWhite)
        
        /// Secondary button background colors.
        public var secondaryButtonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(module: "Alert.LayerColoredButton.Background.Pressed"),
            disabled: .clear
        )
        
        /// Secondary button title colors.
        public var secondaryButtonTitle: ButtonStateColors = .init(
            enabled: ColorBook.accentBlue,
            pressed: ColorBook.accentBlue, // Looks better
            disabled: ColorBook.accentBluePressedDisabled
        )
        
        /// Destructive button background colors.
        public var destructiveButtonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(module: "Alert.LayerColoredButton.Background.Pressed"),
            disabled: .clear
        )
        
        /// Destructive button title colors.
        public var destructiveButtonTitle: ButtonStateColors = .init(
            enabled: ColorBook.accentRed,
            pressed: ColorBook.accentRed, // Looks better
            disabled: ColorBook.accentRedPressedDisabled
        )

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        /// Model that contains colors for button states.
        public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` and weight `bold`.
        public var title: Font = .system(size: 16, weight: .bold)
        
        /// Message font. Defaults to system font of size `15`.
        public var message: Font = .system(size: 14)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public typealias Animations = VModalUIModel.Animations
    
    // MARK: Sub UI Models
    var sheetSubUIModel: VSheetUIModel {
        var uiModel: VSheetUIModel = .init()
        
        uiModel.layout.roundedCorners = layout.roundedCorners
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.contentMargin = 0
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var primaryButtonSubUIModel: VPrimaryButtonUIModel { 
        var uiModel: VPrimaryButtonUIModel = .init()

        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius

        uiModel.colors.background = .alertButton(colors.primaryButtonBackground)
        uiModel.colors.title = .alertButton(colors.primaryButtonTitle)

        return uiModel
    }
    
    var secondaryButtonSubUIModel: VPrimaryButtonUIModel {
        var uiModel: VPrimaryButtonUIModel = .init()
        
        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius
        
        uiModel.colors.background = .alertButton(colors.secondaryButtonBackground)
        uiModel.colors.title = .alertButton(colors.secondaryButtonTitle)

        return uiModel
    }
    
    var destructiveButtonSubUIModel: VPrimaryButtonUIModel {
        var uiModel: VPrimaryButtonUIModel = .init()
        
        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius
        
        uiModel.colors.background = .alertButton(colors.destructiveButtonBackground)
        uiModel.colors.title = .alertButton(colors.destructiveButtonTitle)

        return uiModel
    }
}

// MARK: - Helpers
extension GenericStateModel_EnabledPressedLoadingDisabled where Value == Color {
    fileprivate static func alertButton(_ model: GenericStateModel_EnabledPressedDisabled<Color>) -> Self {
        self.init(
            enabled: model.enabled,
            pressed: model.pressed,
            loading: .clear, // Doesn't matter
            disabled: model.disabled
        )
    }
}
