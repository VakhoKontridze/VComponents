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
@NonInitializable
struct GlobalUIModel {
    // MARK: Common
    @NonInitializable
    struct Common {
        // MARK: Properties - Container
        static let containerCornerRadius: CGFloat = 15
        static let containerContentMargin: CGFloat = 15
        static let containerHeaderMargins: EdgeInsets_LeadingTrailingTopBottom = .init(horizontal: containerContentMargin, vertical: 10)
        
        // MARK: Properties - Shadow
        static let shadowColorEnabled: Color = ColorBook._shadow
        static let shadowColorDisabled: Color = ColorBook._shadowDisabled

        // MARK: Properties - Header and Footer
        static let headerTitleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static let headerTitleTextFont: Font = {
#if os(iOS)
            Font.footnote // 13
#elseif os(macOS)
            Font.footnote // 10
#else
            fatalError() // Not supported
#endif
        }()
        
        static let footerTitleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                .multiLine(alignment: .leading, lineLimit: 1...5)
            } else {
                .multiLine(alignment: .leading, lineLimit: 5)
            }
        }()
        static let footerTitleTextFont: Font = headerTitleTextFont // 13, 10
        
        static let headerComponentAndFooterSpacing: CGFloat = 3
        static let headerAndFooterMarginHorizontal: CGFloat = 10
        
        // MARK: Properties - Divider and Separator
        static let dividerHeightPx: Int = 2
        static let dividerColor: Color = ColorBook._divider
        
        static let dividerDashColorEnabled: Color = ColorBook._dividerDash
        static let dividerDashColorDisabled: Color = ColorBook._dividerDashDisabled

        // MARK: Properties - Circular Button
        static let circularButtonGrayDimension: CGFloat = 30
        static let circularButtonGrayIconDimension: CGFloat = 12
        
        static let circularButtonLayerColorEnabled: Color = ColorBook._circularButtonLayer
        static let circularButtonLayerColorPressed: Color = ColorBook._circularButtonLayerPressed
        static let circularButtonLayerColorDisabled: Color = ColorBook._circularButtonLayerDisabled

        static let circularButtonIconPrimaryColorEnabled: Color = ColorBook.primary
        static let circularButtonIconPrimaryColorPressed: Color = ColorBook.primary
        static let circularButtonIconPrimaryColorDisabled: Color = ColorBook.primaryPressedDisabled
        
        // MARK: Properties - Bar
        static let barHeight: CGFloat = {
#if os(iOS)
            10
#elseif os(macOS)
            10
#elseif os(tvOS)
            10
#elseif os(watchOS)
            5
#elseif os(visionOS)
            fatalError() // FIXME: Implement
#endif
        }()
        static let barCornerRadius: CGFloat = barHeight/2
        
        // MARK: Properties - Misc
        static let minimumScaleFactor: CGFloat = 0.75
        
        static let dimmingViewColor: Color = ColorBook._dimmingView

        static let dragIndicatorColor: Color = ColorBook._dragIndicator
    }
    
    // MARK: Buttons
    @NonInitializable
    struct Buttons { // Also used for button-like components
        // MARK: Properties - Sizes
        static let heightStretchedButton: CGFloat = {
#if os(iOS)
            48
#elseif os(macOS)
            40
#elseif os(watchOS)
            64
#else
            fatalError() // Not supported
#endif
        }()

        static let heightWrappedButton: CGFloat = {
#if os(iOS)
            32
#elseif os(macOS)
            32
#elseif os(watchOS)
            48
#else
            fatalError() // Not supported
#endif
        }()

        static let sizeRectButton: CGSize = {
#if os(iOS)
            CGSize(dimension: 56)
#elseif os(macOS)
            CGSize(dimension: 28)
#elseif os(watchOS)
            CGSize(width: 64, height: 56)
#else
            fatalError() // Not supported
#endif
        }()

        // MARK: Properties - Corner Radius
        static let cornerRadiusStretchedButton: CGFloat = {
#if os(iOS)
            14
#elseif os(macOS)
            12
#elseif os(watchOS)
            32
#else
            fatalError() // Not supported
#endif
        }()

        static let cornerRadiusWrappedButton: CGFloat = heightWrappedButton/2

        static let cornerRadiusRectangularButton: CGFloat = {
#if os(iOS)
            16
#elseif os(macOS)
            6
#elseif os(watchOS)
            16
#else
            fatalError() // Not supported
#endif
        }()

        // MARK: Properties - Margins
        static let labelMargins: EdgeInsets_HorizontalVertical = .init(horizontal: 15, vertical: 3)
        static let labelMarginsRectButton: EdgeInsets_HorizontalVertical = .init(3)

        // MARK: Properties - Colors
        static let transparentLayerLabelEnabled: Color = ColorBook.controlLayerBlue
        static let transparentLayerLabelPressed: Color = ColorBook.controlLayerBluePressed
        static let transparentLayerLabelDisabled: Color = ColorBook.controlLayerBlueDisabled.opacity(0.5)

        // MARK: Properties - Label
        static let titleTextAndIconSpacing: CGFloat = 8

        // MARK: Properties - Label - Text - Fonts
        static let titleTextFontStretchedButton: Font = {
#if os(iOS)
            Font.callout.weight(.semibold) // 16
#elseif os(macOS)
            Font.system(size: 16, weight: .semibold) // No dynamic type on `macOS` anyway
#elseif os(watchOS)
            Font.title3.weight(.semibold) // 20
#else
            fatalError() // Not supported
#endif
        }()

        static let titleTextFontWrappedButton: Font = {
#if os(iOS)
            Font.subheadline.weight(.semibold)
#elseif os(macOS)
            Font.body.weight(.semibold)
#elseif os(watchOS)
            Font.body.weight(.semibold)
#else
            fatalError() // Not supported
#endif
        }()

        static let titleTextRectangularButton: Font = {
#if os(iOS)
            Font.subheadline.weight(.semibold)
#elseif os(macOS)
            Font.body
#elseif os(watchOS)
            Font.body.weight(.semibold)
#else
            fatalError() // Not supported
#endif
        }()

        // MARK: Properties - Label - Icon
        static let iconSizeStretchedButton: CGSize = {
#if os(iOS)
            CGSize(dimension: 18)
#elseif os(macOS)
            CGSize(dimension: 16)
#elseif os(watchOS)
            CGSize(dimension: 22)
#else
            fatalError() // Not supported
#endif
        }()

        static let iconSizeWrappedButton: CGSize = {
#if os(iOS)
            CGSize(dimension: 16)
#elseif os(macOS)
            CGSize(dimension: 16)
#elseif os(watchOS)
            CGSize(dimension: 18)
#else
            fatalError() // Not supported
#endif
        }()

        static let iconSizeRectButton: CGSize = {
#if os(iOS)
            CGSize(dimension: 24)
#elseif os(macOS)
            CGSize(dimension: 14)
#elseif os(watchOS)
            CGSize(dimension: 26)
#else
            fatalError() // Not supported
#endif
        }()
        
        static let pressedScale: CGFloat = {
#if os(iOS)
            1
#elseif os(macOS)
            1
#elseif os(watchOS)
            0.98
#else
            fatalError() // Not supported
#endif
        }()

        // MARK: Properties - Haptics
#if os(iOS)
        static let hapticStretchedButtonIOS: UIImpactFeedbackGenerator.FeedbackStyle? = .medium
#elseif os(watchOS)
        static let hapticStretchedButtonWatchOS: WKHapticType? = .click
#endif
    }
    
    // MARK: State Pickers
    @NonInitializable
    struct StatePickers {
        // MARK: Properties
        static let dimension: CGFloat = 16
        
        static let componentAndLabelSpacing: CGFloat = 5
        
        static let titleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static let font: Font = {
#if os(iOS)
            Font.subheadline // 15
#elseif os(macOS)
            Font.body // 13
#else
            fatalError() // Not supported
#endif
        }()
        
        static let titleColor: Color = {
#if os(iOS)
            ColorBook.primary
#elseif os(macOS)
            ColorBook.primary.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }()
        
        static let titleColorDisabled: Color = {
#if os(iOS)
            ColorBook.primaryPressedDisabled
#elseif os(macOS)
            ColorBook.primaryPressedDisabled.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }()
        
        static let stateChangeAnimation: Animation = .easeIn(duration: 0.1)
        
#if os(iOS)
        static let hapticIOS: UIImpactFeedbackGenerator.FeedbackStyle? = .light
#endif
    }
    
    // MARK: Value Pickers
    @NonInitializable
    struct ValuePickers {
        static let sliderThumbDimension: CGFloat = 20
        static let sliderThumbCornerRadius: CGFloat = 10
        static let sliderThumbShadowRadius: CGFloat = {
#if os(iOS)
            2
#elseif os(macOS)
            1
#else
            fatalError() // Not supported
#endif
        }()
        static let sliderThumbShadowOffset: CGPoint = {
#if os(iOS)
            CGPoint(x: 0, y: 2)
#elseif os(macOS)
            CGPoint(x: 0, y: 1)
#else
            fatalError() // Not supported
#endif
        }()
    }
    
    // MARK: Inputs
    @NonInitializable
    struct Inputs {
        static let height: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        
        static let layerGrayColorFocused: Color = ColorBook._inputLayerGrayFocused

        static let headerTitleTextAndFooterTitleTextGreenColor: Color = ColorBook._inputHeaderTitleTextAndFooterTitleTextGreen
        static let headerTitleTextAndFooterTitleTextYellowColor: Color = ColorBook._inputHeaderTitleTextAndFooterTitleTextYellow
        static let headerTitleTextAndFooterTitleTextRedColor: Color = ColorBook._inputHeaderTitleTextAndFooterTitleTextRed
        
        static let clearButtonLayerEnabled: Color = ColorBook._inputClearButtonLayer
        static let clearButtonLayerPressed: Color = ColorBook._inputClearButtonLayerPressed
        static let clearButtonLayerDisabled: Color = ColorBook._inputClearButtonLayerDisabled
        static let clearButtonIcon: Color = ColorBook._inputClearButtonIcon
        
        static let visibilityButtonEnabled: Color = ColorBook._inputVisibilityButtonIcon
        static let visibilityButtonPressedDisabled: Color = ColorBook.primaryPressedDisabled
        
        static let searchIconEnabledFocused: Color = ColorBook._inputSearchIcon
        static let searchIconDisabled: Color = ColorBook.primaryPressedDisabled
    }

    // MARK: Containers
    @NonInitializable
    struct Containers {
        // MARK: Properties - Pager Tab View
        static let pagerTabViewTabBarAndTabViewSpacing: CGFloat = 0

        static let pagerTabViewTabBarAlignment: VerticalAlignment = .top

        static let pagerTabViewTabItemMargin: CGFloat = 10

        static let pagerTabViewTabItemTextColorDeselected: Color = ColorBook.primary
        static let pagerTabViewTabItemTextColorDeSelected: Color = ColorBook.accentBlue
        static let pagerTabViewTabItemTextColorPressedDeselected: Color = ColorBook.primaryPressedDisabled
        static let pagerTabViewTabItemTextColorPressedSelected: Color = ColorBook.controlLayerBluePressed
        static let pagerTabViewTabItemTextColorDisabled: Color = ColorBook.primaryPressedDisabled
        
        static let pagerTabViewTabItemTextFont: Font = .body

        static let pagerTabViewTabIndicatorStripAlignment: VerticalAlignment = .bottom

        static let pagerTabViewTabIndicatorTrackHeight: CGFloat = 2
        static let pagerTabViewTabIndicatorTrackColor: Color = .clear

        static let pagerTabViewSelectedTabIndicatorHeight: CGFloat = 2
        static let pagerTabViewSelectedTabIndicatorCornerRadius: CGFloat = 0
        static let pagerTabViewSelectedTabIndicatorColor: Color = ColorBook.accentBlue
        static let pagerTabViewSelectedTabIndicatorAnimation: Animation? = .default

        static let pagerTabViewBackgroundColor: Color = ColorBook.background
    }
    
    // MARK: Modals
    @NonInitializable
    struct Modals {
        // MARK: Properties - Popping
        static let poppingAppearAnimation: BasicAnimation? = .init(curve: .linear, duration: 0.05)
        static let poppingDisappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)
        static let poppingAnimationScaleEffect: CGFloat = 1.01

        // MARK: Properties - Sliding
        static let slidingAppearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        static let slidingDisappearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
    }
    
    // MARK: Notifications
    @NonInitializable
    struct Notifications {
        static let layerGray: Color = ColorBook.layerGray
        static let layerGreen: Color = ColorBook._notificationLayerGreen
        static let layerYellow: Color = ColorBook._notificationLayerYellow
        static let layerRed: Color = ColorBook._notificationLayerRed
    }
    
    // MARK: Indicators (Definite)
    @NonInitializable
    struct DefiniteIndicators {
        // MARK: Properties - Page Indicator
        static let pageIndicatorSpacing: CGFloat = {
#if os(iOS)
            8
#elseif os(macOS)
            8
#elseif os(tvOS)
            10
#elseif os(watchOS)
            4
#elseif os(visionOS)
        fatalError() // FIXME: Implement
#endif
        }()

        static let pageIndicatorDotDimension: CGFloat = {
#if os(iOS)
            8
#elseif os(macOS)
            8
#elseif os(tvOS)
            10
#elseif os(watchOS)
            4
#elseif os(visionOS)
        fatalError() // FIXME: Implement
#endif
        }()

        static let pageIndicatorDotCornerRadius: CGFloat = pageIndicatorDotDimension/2

        static let pageIndicatorDeselectedDotColor: Color = ColorBook._pageIndicatorDeselectedDot
        static let pageIndicatorSelectedDotColor: Color = ColorBook.accentBlue
        
        static let pageIndicatorCompactVisibleDots: Int = 7
        static let pageIndicatorCompactCenterDots: Int = 3
        static let pageIndicatorCompactEdgeDotScale: CGFloat = 0.5

        static let pageIndicatorTransitionAnimation: Animation? = .linear(duration: 0.15)
    }
}
