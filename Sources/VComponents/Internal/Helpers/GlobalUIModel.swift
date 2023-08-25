//
//  GlobalUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI

#if os(watchOS)
import WatchKit
#endif

import VCore

// MARK: - Global UI Model
struct GlobalUIModel {
    // MARK: Initializers
    private init() {}
    
    // MARK: Common
    struct Common {
        // MARK: Properties - Container
        static let containerCornerRadius: CGFloat = 15
        static let containerContentMargin: CGFloat = 15
        static let containerHeaderMargins: EdgeInsets_LeadingTrailingTopBottom = .init(horizontal: containerContentMargin, vertical: 10)
        
        // MARK: Properties - Shadow
        static let shadowColorEnabled: Color = .init(module: "Shadow")
        static let shadowColorDisabled: Color = .init(module: "Shadow.Disabled")
        
        // MARK: Properties - Header and Footer
        static let headerTitleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static let headerTitleTextFont: Font = {
#if os(iOS)
            return Font.footnote // 13
#elseif os(macOS)
            return Font.footnote // 10
#else
            fatalError() // Not supported
#endif
        }()
        
        static let footerTitleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...5)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 5)
            }
        }()
        static let footerTitleTextFont: Font = headerTitleTextFont // 13, 10
        
        static let headerComponentAndFooterSpacing: CGFloat = 3
        static let headerAndFooterMarginHorizontal: CGFloat = 10
        
        // MARK: Properties - Divider and Separator
        static let dividerHeightPx: Int = 2
        static let dividerColor: Color = .init(module: "Divider")
        
        static let separatorHeightPx: Int = 1
        static let separatorColor: Color = dividerColor
        
        static let dividerDashColorEnabled: Color = .init(module: "DividerDash")
        static let dividerDashColorDisabled: Color = .init(module: "DividerDash.Disabled")
        
        // MARK: Properties - Circular Button
        static let circularButtonGrayDimension: CGFloat = 30
        static let circularButtonGrayIconDimension: CGFloat = 12
        
        static let circularButtonLayerColorEnabled: Color = .init(module: "CircularButton.Layer")
        static let circularButtonLayerColorPressed: Color = .init(module: "CircularButton.Layer.Pressed")
        static let circularButtonLayerColorDisabled: Color = .init(module: "CircularButton.Layer.Disabled")
        
        static let circularButtonIconPrimaryColorEnabled: Color = ColorBook.primary
        static let circularButtonIconPrimaryColorPressed: Color = ColorBook.primary // Looks better
        static let circularButtonIconPrimaryColorDisabled: Color = ColorBook.primaryPressedDisabled
        
        // MARK: Properties - Bar
        static let barHeight: CGFloat = {
#if os(iOS)
            return 10
#elseif os(macOS)
            return 10
#elseif os(tvOS)
            return 10
#elseif os(watchOS)
            return 5
#endif
        }()
        static let barCornerRadius: CGFloat = barHeight/2
        
        // MARK: Properties - Misc
        static let minimumScaleFactor: CGFloat = 0.75
        
        static let dimmingViewColor: Color = .init(module: "DimmingView")
        
        static let grabberColor: Color = .init(module: "Grabber")
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Buttons
    struct Buttons { // Also used for button-like components
        // MARK: Properties
        static let heightStretchedButton: CGFloat = {
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
        static let heightWrappedButton: CGFloat = {
#if os(iOS)
            return 32
#elseif os(macOS)
            return 32
#elseif os(watchOS)
            return 48
#else
            fatalError() // Not supported
#endif
        }()
        static let sizeRectButton: CGSize = {
#if os(iOS)
            return CGSize(dimension: 56)
#elseif os(macOS)
            return CGSize(dimension: 28)
#elseif os(watchOS)
            return CGSize(width: 64, height: 56)
#else
            fatalError() // Not supported
#endif
        }()
        
        static let cornerRadiusStretchedButton: CGFloat = {
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
        static let cornerRadiusWrappedButton: CGFloat = heightWrappedButton/2
        
        static let labelMargins: EdgeInsets_HorizontalVertical = .init(horizontal: 15, vertical: 3)
        static let labelMarginsRectButton: EdgeInsets_HorizontalVertical = .init(3)
        
        static let transparentLayerLabelEnabled: Color = ColorBook.controlLayerBlue
        static let transparentLayerLabelPressed: Color = ColorBook.controlLayerBluePressed
        static let transparentLayerLabelDisabled: Color = ColorBook.controlLayerBlueDisabled.opacity(0.5) // Looks better
        
        static let iconAndTitleTextSpacing: CGFloat = 8
        
        static let titleTextFontStretchedButton: Font = {
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
        static let titleTextFontWrappedButton: Font = {
#if os(iOS)
            return Font.subheadline.weight(.semibold)
#elseif os(macOS)
            return Font.body.weight(.semibold)
#elseif os(watchOS)
            return Font.body.weight(.semibold)
#else
            fatalError() // Not supported
#endif
        }()

        static let iconSizeStretchedButton: CGSize = {
#if os(iOS)
            return CGSize(dimension: 18)
#elseif os(macOS)
            return CGSize(dimension: 16)
#elseif os(watchOS)
            return CGSize(dimension: 22)
#else
            fatalError() // Not supported
#endif
        }()
        static let iconSizeWrappedButton: CGSize = {
#if os(iOS)
            return CGSize(dimension: 16)
#elseif os(macOS)
            return CGSize(dimension: 16)
#elseif os(watchOS)
            return CGSize(dimension: 18)
#else
            fatalError() // Not supported
#endif
        }()
        static let iconSizeRectButton: CGSize = {
#if os(iOS)
            return CGSize(dimension: 24)
#elseif os(macOS)
            return CGSize(dimension: 14)
#elseif os(watchOS)
            return CGSize(dimension: 26)
#else
            fatalError() // Not supported
#endif
        }()
        
        static let pressedScale: CGFloat = {
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
        static let hapticStretchedButtonIOS: UIImpactFeedbackGenerator.FeedbackStyle? = .medium
#elseif os(watchOS)
        static let hapticStretchedButtonWatchOS: WKHapticType? = .click
#endif
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: State Pickers
    struct StatePickers {
        // MARK: Properties
        static let dimension: CGFloat = 16
        
        static let componentAndLabelSpacing: CGFloat = 5
        
        static let titleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static let font: Font = {
#if os(iOS)
            return Font.subheadline // 15
#elseif os(macOS)
            return Font.body // 13
#else
            fatalError() // Not supported
#endif
        }()
        
        static let titleColor: Color = {
#if os(iOS)
            return ColorBook.primary
#elseif os(macOS)
            return ColorBook.primary.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }()
        
        static let titleColorDisabled: Color = {
#if os(iOS)
            return ColorBook.primaryPressedDisabled
#elseif os(macOS)
            return ColorBook.primaryPressedDisabled.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }()
        
        static let stateChangeAnimation: Animation = .easeIn(duration: 0.1)
        
#if os(iOS)
        static let hapticIOS: UIImpactFeedbackGenerator.FeedbackStyle? = .light
#endif
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Value Pickers
    struct ValuePickers {
        // MARK: Properties
        static let sliderThumbDimension: CGFloat = 20
        static let sliderThumbCornerRadius: CGFloat = 10
        static let sliderThumbShadowRadius: CGFloat = {
#if os(iOS)
            return 2
#elseif os(macOS)
            return 1
#else
            fatalError() // Not supported
#endif
        }()
        static let sliderThumbShadowOffset: CGPoint = {
#if os(iOS)
            return CGPoint(x: 0, y: 2)
#elseif os(macOS)
            return CGPoint(x: 0, y: 1)
#else
            fatalError() // Not supported
#endif
        }()
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Inputs
    struct Inputs {
        // MARK: Properties
        static let height: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        
        static let layerGrayColorFocused: Color = .init(module: "Input.Layer.Gray.Focused")
        
        static let headerTitleTextAndFooterTitleTextGreenColor: Color = .init(module: "Input.HeaderTitleTextAndFooterTitleText.Green")
        static let headerTitleTextAndFooterTitleTextYellowColor: Color = .init(module: "Input.HeaderTitleTextAndFooterTitleText.Yellow")
        static let headerTitleTextAndFooterTitleTextRedColor: Color = .init(module: "Input.HeaderTitleTextAndFooterTitleText.Red")
        
        static let clearButtonLayerEnabled: Color = .init(module: "Input.ClearButton.Layer")
        static let clearButtonLayerPressed: Color = .init(module: "Input.ClearButton.Layer.Pressed")
        static let clearButtonLayerDisabled: Color = .init(module: "Input.ClearButton.Layer.Disabled")
        static let clearButtonIcon: Color = .init(module: "Input.ClearButton.Icon")
        
        static let visibilityButtonEnabled: Color = .init(module: "Input.VisibilityButton.Icon")
        static let visibilityButtonPressedDisabled: Color = ColorBook.primaryPressedDisabled
        
        static let searchIconEnabledFocused: Color = .init(module: "Input.SearchIcon")
        static let searchIconDisabled: Color = ColorBook.primaryPressedDisabled
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Modals
    struct Modals {
        // MARK: Properties        
        static let poppingAppearAnimation: BasicAnimation? = .init(curve: .linear, duration: 0.05)
        static let poppingDisappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)
        static let poppingAnimationScaleEffect: CGFloat = 1.01
        
        static let slidingAppearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        static let slidingDisappearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Notifications
    struct Notifications {
        // MARK: Properties
        static let layerGray: Color = ColorBook.layerGray
        static let layerGreen: Color = .init(module: "Notification.Layer.Green")
        static let layerYellow: Color = .init(module: "Notification.Layer.Yellow")
        static let layerRed: Color = .init(module: "Notification.Layer.Red")
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Indicators (Determinate)
    struct DeterminateIndicators {
        // MARK: Properties
        static let pageIndicatorSpacing: CGFloat = {
#if os(iOS)
            return 5
#elseif os(macOS)
            return 5
#elseif os(tvOS)
            return 10
#elseif os(watchOS)
            return 3
#endif
        }()

        static let pageIndicatorDotDimension: CGFloat = {
#if os(iOS)
            return 10
#elseif os(macOS)
            return 10
#elseif os(tvOS)
            return 20
#elseif os(watchOS)
            return 8
#endif
        }()
        static let pageIndicatorStandardUnselectedDotScale: CGFloat = 0.85
        static let pageIndicatorDotColor: Color = .init(module: "PageIndicator.Dot")
        static let pageIndicatorSelectedDotColor: Color = ColorBook.accentBlue
        
        static let pageIndicatorCompactVisibleDots: Int = 7
        static let pageIndicatorCompactCenterDots: Int = 3
        static let pageIndicatorCompactEdgeDotScale: CGFloat = 0.5

        static let pageIndicatorTransitionAnimation: Animation? = .linear(duration: 0.15)
        
        // MARK: Initializers
        private init() {}
    }
}
