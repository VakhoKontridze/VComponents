//
//  GlobalUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI
import VCore

// MARK: - Global UI Model
struct GlobalUIModel {
    // MARK: Initializers
    private init() {}
    
    // MARK: Common
    struct Common {
        // MARK: Properties - Container
        static var containerCornerRadius: CGFloat { 15 }
        static var containerContentMargin: CGFloat { 15 }
        static var containerHeaderMargins: EdgeInsets_LeadingTrailingTopBottom { .init(horizontal: containerContentMargin, vertical: 10) }
                
        // MARK: Properties - Shadow
        static let shadowColorEnabled: Color = .init(module: "Shadow")
        static let shadowColorDisabled: Color = .init(module: "Shadow.Disabled")
        
        // MARK: Properties - Header and Footer
        static var headerTextLineType: TextLineType { .singleLine }
        static var headerFont: Font {
#if os(iOS)
            return Font.footnote // 13
#elseif os(macOS)
            return Font.footnote // 10
#else
            fatalError() // Not supported
#endif
        }
        
        static var footerTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...5)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 5)
            }
        }()
        static var footerFont: Font { headerFont } // 13, 10
        
        static var headerComponentFooterSpacing: CGFloat { 3 }
        static var headerFooterMarginHorizontal: CGFloat { 10 }
        
        // MARK: Properties - Divider and Separator
        static let dividerHeight: CGFloat = 2 / MultiplatformConstants.screenScale
        static let dividerColor: Color = .init(module: "Divider")
        
        static let separatorHeight: CGFloat = 1 / MultiplatformConstants.screenScale
        static var separatorColor: Color { dividerColor }
        
        static var dividerDashColorEnabled: Color { .init(module: "DividerDash") }
        static var dividerDashColorDisabled: Color { .init(module: "DividerDash.Disabled") }
        
        // MARK: Properties - Circular Button
        static var circularButtonGrayDimension: CGFloat { 30 }
        static var circularButtonGrayIconDimension: CGFloat { 12 }
        
        static var circularButtonLayerColorEnabled: Color { .init(module: "CircularButton.Layer") }
        static var circularButtonLayerColorPressed: Color { .init(module: "CircularButton.Layer.Pressed") }
        static var circularButtonLayerColorDisabled: Color { .init(module: "CircularButton.Layer.Disabled") }
        
        static var circularButtonIconGrayColor: Color { .init(module: "CircularButton.Icon.Gray") }
        
        static var circularButtonIconPrimaryColorEnabled: Color { ColorBook.primary }
        static var circularButtonIconPrimaryColorPressed: Color { ColorBook.primary } // Looks better
        static var circularButtonIconPrimaryColorDisabled: Color { ColorBook.primaryPressedDisabled }
        
        // MARK: Properties - Bar
        static var barHeight: CGFloat {
#if os(iOS)
            return 10
#elseif os(macOS)
            return 10
#elseif os(tvOS)
            return 10
#elseif os(watchOS)
            return 5
#endif
        }
        static var barCornerRadius: CGFloat { barHeight/2 }
        
        // MARK: Properties - Misc
        static var minimumScaleFactor: CGFloat { 0.75 }
        
        static let dimmingViewColor: Color = .init(module: "DimmingView")
        
        static var grabberColor: Color { .init(module: "Grabber") }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Buttons
    struct Buttons {
        // MARK: Properties
        static var heightStretchedButton: CGFloat = {
#if os(iOS)
            return 48
#elseif os(macOS)
            return 40
#elseif os(watchOS)
            return 64
#else
            fatalError() // Not supported
#endif
        }()
        static var sizeRoundedButton: CGSize {
#if os(iOS)
            return CGSize(dimension: 56)
#elseif os(macOS)
            return CGSize(dimension: 28)
#elseif os(watchOS)
            return CGSize(width: 64, height: 56)
#else
            fatalError() // Not supported
#endif
        }
        
        static var cornerRadiusStretchedButton: CGFloat = {
#if os(iOS)
            return 14
#elseif os(macOS)
            return 12
#elseif os(watchOS)
            return 32
#else
            fatalError() // Not supported
#endif
        }()
        
        static var labelMargins: EdgeInsets_HorizontalVertical { .init(horizontal: 15, vertical: 3) }
        static var labelMarginsRoundedButton: EdgeInsets_HorizontalVertical { .init(3) }
        
        static var transparentLayerLabelEnabled: Color { ColorBook.controlLayerBlue }
        static var transparentLayerLabelPressed: Color { ColorBook.controlLayerBluePressed }
        static var transparentLayerLabelDisabled: Color { ColorBook.controlLayerBlueDisabled.opacity(0.5) } // Looks better
        
        static var iconTitleSpacing: CGFloat { 8 }
        
        static var titleFontStretchedButton: Font = {
#if os(iOS)
            return Font.callout.weight(.semibold) // 16
#elseif os(macOS)
            return Font.system(size: 16).weight(.semibold) // No dynamic type on `macOS` anyway
#elseif os(watchOS)
            if #available(watchOS 7.0, *) {
                return Font.title3.weight(.semibold) // 20
            } else {
                return Font.system(size: 20)
            }
#else
            fatalError() // Not supported
#endif
        }()
        
        static var pressedScale: CGFloat = {
#if os(iOS)
            return 1
#elseif os(macOS)
            return 1
#elseif os(watchOS)
            return 0.98
#else
            fatalError() // Not supported
#endif
        }()
        
#if os(iOS)
        static var hapticIOS: UIImpactFeedbackGenerator.FeedbackStyle? { .light }
#elseif os(watchOS)
        static var hapticWatchOS: WKHapticType? { nil }
#endif
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: State Pickers
    struct StatePickers {
        // MARK: Properties
        static var dimension: CGFloat { 16 }
        
        static var statePickerLabelSpacing: CGFloat { 5 }
        
        static var titleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static var font: Font {
#if os(iOS)
            return Font.subheadline // 15
#elseif os(macOS)
            return Font.body // 13
#else
            fatalError() // Not supported
#endif
        }
        
        static var titleColor: Color {
#if os(iOS)
            return ColorBook.primary
#elseif os(macOS)
            return ColorBook.primary.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }
        
        static var titleColorDisabled: Color {
#if os(iOS)
            return ColorBook.primaryPressedDisabled
#elseif os(macOS)
            return ColorBook.primaryPressedDisabled.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }
        
        static var stateChangeAnimation: Animation { .easeIn(duration: 0.1) }
        
#if os(iOS)
        static var hapticIOS: UIImpactFeedbackGenerator.FeedbackStyle? { .light }
#endif
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Value Pickers
    struct ValuePickers {
        // MARK: Properties
        static var sliderThumbDimension: CGFloat { 20 }
        static var sliderThumbCornerRadius: CGFloat { 10 }
        static var sliderThumbShadowRadius: CGFloat {
#if os(iOS)
            return 2
#elseif os(macOS)
            return 1
#else
            fatalError() // Not supported
#endif
        }
        static var sliderThumbShadowOffset: CGPoint {
#if os(iOS)
            return CGPoint(x: 0, y: 2)
#elseif os(macOS)
            return CGPoint(x: 0, y: 1)
#else
            fatalError() // Not supported
#endif
 }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Inputs
    struct Inputs {
        // MARK: Properties
        static var height: CGFloat { 50 }
        static var cornerRadius: CGFloat { 12 }
        
        static var layerGrayColorFocused: Color { .init(module: "Input.Layer.Gray.Focused") }
        
        static var headerFooterGreenColor: Color { .init(module: "Input.HeaderFooter.Green") }
        static var headerFooterYellowColor: Color { .init(module: "Input.HeaderFooter.Yellow") }
        static var headerFooterRedColor: Color { .init(module: "Input.HeaderFooter.Red") }
        
        static var clearButtonLayerEnabled: Color { .init(module: "Input.ClearButton.Layer") }
        static var clearButtonLayerPressed: Color { .init(module: "Input.ClearButton.Layer.Pressed") }
        static var clearButtonLayerDisabled: Color { .init(module: "Input.ClearButton.Layer.Disabled") }
        static var clearButtonIcon: Color { .init(module: "Input.ClearButton.Icon") }
        
        static var visibilityButtonEnabled: Color { .init(module: "Input.VisibilityButton.Icon") }
        static var visibilityButtonPressedDisabled: Color { ColorBook.primaryPressedDisabled }
        
        static var searchIconEnabledFocused: Color { .init(module: "Input.SearchIcon") }
        static var searchIconDisabled: Color { ColorBook.primaryPressedDisabled }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Modals
    struct Modals {
        // MARK: Properties
        static var labelCloseButtonSpacing: CGFloat { 10 }
        
        static var headerFont: Font { .headline.weight(.bold) } // 17 (iOS Only)
        
        static var poppingAppearAnimation: BasicAnimation? { .init(curve: .linear, duration: 0.05) }
        static var poppingDisappearAnimation: BasicAnimation? { .init(curve: .easeIn, duration: 0.05) }
        static var poppingAnimationScaleEffect: CGFloat { 1.01 }
        static var poppingAnimationOpacity: CGFloat { 0.5 }
        static var poppingAnimationBlur: CGFloat { 3 }
        
        static var slidingAppearAnimation: BasicAnimation? { .init(curve: .easeInOut, duration: 0.3) }
        static var slidingDisappearAnimation: BasicAnimation? { .init(curve: .easeInOut, duration: 0.3) }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Messages
    struct Messages {
        // MARK: Properties
        static var layerGray: Color { ColorBook.layerGray }
        static var layerGreen: Color { .init(module: "Message.Layer.Green") }
        static var layerYellow: Color { .init(module: "Message.Layer.Yellow") }
        static var layerRed: Color { .init(module: "Message.Layer.Red") }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Indicators
    struct Indicators {
        // MARK: Properties
        static var pageIndicatorDotDimension: CGFloat {
#if os(iOS)
            return 10
#elseif os(macOS)
            return 10
#elseif os(tvOS)
            return 20
#elseif os(watchOS)
            return 8
#endif
        }
        static var pageIndicatorSpacing: CGFloat {
#if os(iOS)
            return 5
#elseif os(macOS)
            return 5
#elseif os(tvOS)
            return 10
#elseif os(watchOS)
            return 3
#endif
        }
        
        static var pageIndicatorStandardUnselectedDotScale: CGFloat { 0.85 }
        
        static var pageIndicatorCompactVisibleDots: Int { 7 }
        static var pageIndicatorCompactCenterDots: Int { 3 }
        static var pageIndicatorCompactEdgeDotScale: CGFloat { 0.5 }
        
        // MARK: Initializers
        private init() {}
    }
}
