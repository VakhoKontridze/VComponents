//
//  VSegmentedPickerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI
import VCore

// MARK: - V Segmented Picker UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VSegmentedPickerUIModel {
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
        /// Picker height.
        /// Set to `31` on `iOS`, similarly to native segmented picker.
        /// Set to `22` on `macOS`, similarly to native segmented picker.
        public var height: CGFloat = {
#if os(iOS)
            return 31
#elseif os(macOS)
            return 22
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Picker corner radius. Set to `7`, similarly to native segmented picker.
        public var cornerRadius: CGFloat = 7
        
        /// Border width.
        /// Set to `0` on `iOS`.
        /// Set to `1` scaled to screen on `macOS`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = {
#if os(iOS)
            return 0
#elseif os(macOS)
            return 1/MultiplatformConstants.screenScale
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Selection indicator corner radius.  Set to `6`, similarly to native segmented picker.
        public var indicatorCornerRadius: CGFloat = 6
        
        /// Selection indicator margin.
        /// Set to `2` on `iOS`.
        /// Set to `1` on `macOS`.
        public var indicatorMargin: CGFloat = {
#if os(iOS)
            return 2
#elseif os(macOS)
            return 1
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Indicator shadow radius. Set to `1`.
        public var indicatorShadowRadius: CGFloat = 1
        
        /// Indicator shadow offset.
        /// Set to `1x1` on `iOS`.
        /// Set to `0x1` on `macOS`.
        public var indicatorShadowOffset: CGSize = {
#if os(iOS)
            return .init(dimension: 1)
#elseif os(macOS)
            return .init(width: 0, height: 1)
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Row content margin. Set to `2`.
        public var contentMargin: CGFloat = 2
        
        /// Header text line type. Set to `singleLine`.
        public var headerTextLineType: TextLineType = GlobalUIModel.Common.headerTextLineType
        
        /// Footer text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
        public var footerTextLineType: TextLineType = GlobalUIModel.Common.footerTextLineType
        
        /// Spacing between header, picker, and footer. Set to `3`.
        public var headerPickerFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentFooterSpacing
        
        /// Header and footer horizontal margin. Set to `10`.
        public var headerFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerFooterMarginHorizontal
        
        /// Title minimum scale factor. Set to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Row divider size.
        /// Set to `1x19` on `iOS`, similarly to native segmented picker.
        /// Set to `1x13` on `macOS`, similarly to native segmented picker.
        public var dividerSize: CGSize = {
#if os(iOS)
            return .init(width: 1, height: 19)
#elseif os(macOS)
            return .init(width: 1, height: 12)
#else
            fatalError() // Not supported
#endif
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.layerGray,
            disabled: ColorBook.layerGrayDisabled
        )
        
        /// Border colors.
        public var border: StateColors = {
#if os(iOS)
            return .clearColors
#elseif os(macOS)
            return .init(
                enabled: ColorBook.borderGray,
                disabled: ColorBook.borderGrayDisabled
            )
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Selection indicator colors.
        public var indicator: StateColors = .init(
            enabled: .init(module: "SegmentedPicker.Indicator"),
            disabled: .init(module: "SegmentedPicker.Indicator.Disabled")
        )
        
        /// Selection indicator shadow colors.
        public var indicatorShadow: StateColors = .init(
            enabled: GlobalUIModel.Common.shadowColorEnabled,
            disabled: GlobalUIModel.Common.shadowColorDisabled
        )
        
        /// Title colors.
        public var title: RowStateColors = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primaryPressedDisabled,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Row divider colors.
        public var divider: StateColors = .init(
            enabled: GlobalUIModel.Common.dividerDashColorEnabled,
            disabled: GlobalUIModel.Common.dividerDashColorDisabled
        )
        
        /// Header colors.
        public var header: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        /// Footer colors.
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
        
        /// Model that contains colors for component states.
        public typealias RowStateColors = GenericStateModel_EnabledPressedDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias RowStateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font. Set to `system` `14`.
        public var header: Font = GlobalUIModel.Common.headerFont
        
        /// Footer font. Set to `system` `13`.
        public var footer: Font = GlobalUIModel.Common.footerFont
        
        /// Row font.
        /// Set to `system` `medium` `14` on `iOS`.
        /// Set to `system`  `system` `13` on `macOS`.
        public var rows: Font = {
#if os(iOS)
            return .system(size: 14, weight: .medium)
#elseif os(macOS)
            return .system(size: 13)
#else
            fatalError() // Not supported
#endif
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Set to `easeInOut` with duration `0.2`.
        public var selection: Animation? = .easeInOut(duration: 0.2)
        
        /// Ratio to which selection indicator scales down on press. Set to `0.95`.
        public var indicatorPressedScale: CGFloat = 0.95
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
