//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button Model
public struct VPlainButtonModel {
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
extension VPlainButtonModel {
    public struct Layout {
        // MARK: Properties
        public let hitAreaOffsetHor: CGFloat
        public let hitAreaOffsetVer: CGFloat
        
        // MARK: Initializers
        public init(
            hitAreaOffsetHor: CGFloat = 15,
            hitAreaOffsetVer: CGFloat = 5
        ) {
            self.hitAreaOffsetHor = hitAreaOffsetHor
            self.hitAreaOffsetVer = hitAreaOffsetVer
        }
    }
}

// MARK:- Colors
extension VPlainButtonModel {
    public struct Colors {
        // MARK: Properties
        public let foreground: ForegroundColors
        
        // MARK: Initializers
        public init(foreground: ForegroundColors = .init()) {
            self.foreground = foreground
        }
    }
}

extension VPlainButtonModel.Colors {
    public struct ForegroundColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        // MARK: Initializers
        public init(enabled: Color, pressed: Color, disabled: Color, pressedOpacity: Double, disabledOpacity: Double) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
        
        public init() {
            self.init(
                enabled: ColorBook.PlainButton.Text.enabled,
                pressed: ColorBook.PlainButton.Text.pressed,
                disabled: ColorBook.PlainButton.Text.disabled,
                pressedOpacity: 0.5,
                disabledOpacity: 0.5
            )
        }
    }
}

// MARK:- Fonts
extension VPlainButtonModel {
    public struct Fonts {
        // MARK: Properties
        public let title: Font
        
        // MARK: Initializers
        public init(title: Font) {
            self.title = title
        }
        
        public init() {
            self.init(
                title: FontBook.buttonLarge
            )
        }
    }
}

// MARK:- Mapping
extension VPlainButtonModel.Colors {
    func foregroundColor(state: VPlainButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }
    
    func foregroundOpacity(state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }
}
