//
//  VCircularButtonViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button ViewModel
public struct VCircularButtonViewModel {
    // MARK: Properties
    public let layout: Layout
    public let colors: Colors
    public let fonts: Fonts
    
    // MARK: Initializers
    public init(layout: Layout, colors: Colors, fonts: Fonts) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
    }
    
    public init() {
        self.init(
            layout: .init(),
            colors: .init(),
            fonts: .init()
        )
    }
}

// MARK:- Layout
extension VCircularButtonViewModel {
    public struct Layout {
        // MARK: Properties
        public let dimension: CGFloat
        
        // MARK: Initializers
        init(dimension: CGFloat) {
            self.dimension = dimension
        }
        
        init() {
            self.init(
                dimension: 44
            )
        }
    }
}

// MARK:- Colors
extension VCircularButtonViewModel {
    // MARK: Properties
    public struct Colors {
        // MARK: Properties
        public let foreground: StateColors
        public let background: StateColors
        
        public struct StateColors {
            public let enabled: Color
            public let pressed: Color
            public let disabled: Color
            public let loading: Color
        }
        
        // MARK: Initializers
        public init(foreground: StateColors, background: StateColors) {
            self.foreground = foreground
            self.background = background
        }
        
        public init() {
            self.init(
                foreground: .init(
                    enabled: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1),
                    pressed: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1),
                    disabled: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5),
                    loading: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5)
                ),
                background: .init(
                    enabled: Color(red: 50/255, green: 130/255, blue: 230/255, opacity: 1),
                    pressed: Color(red: 30/255, green: 90/255, blue: 160/255, opacity: 1),
                    disabled: Color(red: 130/255, green: 180/255, blue: 240/255, opacity: 1),
                    loading: Color(red: 130/255, green: 180/255, blue: 240/255, opacity: 1)
                )
            )
        }
    }
}

// MARK:- Fonts
extension VCircularButtonViewModel {
    public struct Fonts {
        // MARK: Properties
        public let title: Font
        
        // MARK: Initializers
        public init(title: Font) {
            self.title = title
        }
        
        public init() {
            self.init(
                title: .system(size: 11, weight: .semibold, design: .default)
            )
        }
    }
}
