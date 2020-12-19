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
    public struct Colors {
        // MARK: Properties
        public let foreground: StateColors
        public let background: StateColors
        
        // MARK: Initializers
        public init(foreground: StateColors, background: StateColors) {
            self.foreground = foreground
            self.background = background
        }
        
        public init() {
            self.init(
                foreground: .init(
                    enabled: ColorBook.White.Text.enabled,
                    pressed: ColorBook.White.Text.pressed,
                    disabled: ColorBook.White.Text.disabled
                ),
                background: .init(
                    enabled: ColorBook.Primary.Fill.enabled,
                    pressed: ColorBook.Primary.Fill.pressed,
                    disabled: ColorBook.Primary.Fill.disabledDark
                )
            )
        }
    }
    
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
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
                title: FontBook.buttonSmall
            )
        }
    }
}
