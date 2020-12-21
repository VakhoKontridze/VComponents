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
    public init(layout: Layout = .init(), colors: Colors = .init(), fonts: Fonts = .init()) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
    }
}

// MARK:- Layout
extension VCircularButtonViewModel {
    public struct Layout {
        // MARK: Properties
        public let dimension: CGFloat
        
        // MARK: Initializers
        public init(dimension: CGFloat) {
            self.dimension = dimension
        }
        
        public init() {
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
        public let foreground: ForegroundColors
        public let background: BackgroundColors
        
        // MARK: Initializers
        public init(foreground: ForegroundColors = .init(), background: BackgroundColors = .init()) {
            self.foreground = foreground
            self.background = background
        }
    }
}

extension VCircularButtonViewModel {
    public struct ForegroundColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        public let pressedOpacity: Double
        
        // MARK: Initializers
        public init(enabled: Color, pressed: Color, disabled: Color, pressedOpacity: Double) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.pressedOpacity = pressedOpacity
        }
        
        public init() {
            self.init(
                enabled: ColorBook.CircularButton.Text.enabled,
                pressed: ColorBook.CircularButton.Text.pressed,
                disabled: ColorBook.CircularButton.Text.disabled,
                pressedOpacity: 0.5
            )
        }
    }
    
    public struct BackgroundColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, pressed: Color, disabled: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.CircularButton.Fill.enabled,
                pressed: ColorBook.CircularButton.Fill.pressed,
                disabled: ColorBook.CircularButton.Fill.disabled
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
                title: FontBook.buttonSmall
            )
        }
    }
}

// MARK:- Mapping
extension VCircularButtonViewModel.Colors {
    func foregroundColor(state: VCircularButtonActualState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }

    func backgroundColor(state: VCircularButtonActualState) -> Color {
        switch state {
        case .enabled: return background.enabled
        case .pressed: return background.pressed
        case .disabled: return background.disabled
        }
    }
    
    func foregroundOpacity(state: VCircularButtonActualState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return 1
        }
    }
}
