//
//  VSliderViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Slider View Model
public struct VSliderViewModel {
    // MARK: Properties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(behavior: Behavior, layout: Layout, colors: Colors) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
    
    public init() {
        self.init(
            behavior: .init(),
            layout: .init(),
            colors: .init()
        )
    }
}

// MARK:- Behavior
extension VSliderViewModel {
    public struct Behavior {
        // MARK: Properties
        public let rounded: RoundedSliderBehavior
        
        // MARK: Initializers
        public init(rounded: RoundedSliderBehavior) {
            self.rounded = rounded
        }
        
        public init() {
            self.init(
                rounded: .init()
            )
        }
    }
    
    public struct RoundedSliderBehavior {
        // MARK: Properties
        public let useAnimation: Bool
        
        // MARK: Initializers
        public init(useAnimation: Bool) {
            self.useAnimation = useAnimation
        }
        
        public init() {
            self.init(
                useAnimation: false
            )
        }
    }
}

// MARK:- Layout
extension VSliderViewModel {
    public struct Layout {
        // MARK: Properties
        public let rounded: RoundedSliderLayout
        
        // MARK: Initializers
        public init(rounded: RoundedSliderLayout) {
            self.rounded = rounded
        }
        
        public init() {
            self.init(
                rounded: .init()
            )
        }
    }
    
    public struct RoundedSliderLayout {
        // MARK: Properties
        public let height: CGFloat
        
        // MARK: Initializers
        public init(height: CGFloat) {
            self.height = height
        }
        
        public init() {
            self.init(
                height: 10
            )
        }
    }
}

// MARK:- Colors
extension VSliderViewModel {
    // MARK: Properties
    public struct Colors {
        // MARK: Properties
        public let rounded: RoundedSliderColors
        public let thin: ThinSliderColors
        
        // MARK: Initializers
        public init(rounded: RoundedSliderColors, thin: ThinSliderColors) {
            self.rounded = rounded
            self.thin = thin
        }
        
        public init() {
            self.init(
                rounded: .init(),
                thin: .init()
            )
        }
    }
    
    public struct RoundedSliderColors {
        // MARK: Properties
        public let slider: StateColors
        public let track: StateColors
        
        // MARK: Initializers
        public init(slider: StateColors, track: StateColors) {
            self.track = track
            self.slider = slider
        }
        
        public init() {
            self.init(
                slider: .init(
                    enabled: Color(red: 50/255, green: 130/255, blue: 230/255, opacity: 1),
                    disabled: Color(red: 150/255, green: 190/255, blue: 240/255, opacity: 1)
                ),
                track: .init(
                    enabled: Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 1),
                    disabled: Color(red: 240/255, green: 240/255, blue: 240/255, opacity: 1)
                )
            )
        }
    }
    
    public struct ThinSliderColors {
        // MARK: Properties
        public let slider: Color
        
        // MARK: Initializers
        public init(slider: Color) {
            self.slider = slider
        }
        
        public init() {
            self.init(
                slider: Color(red: 50/255, green: 130/255, blue: 230/255, opacity: 1)
            )
        }
    }
    
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
    }
}
