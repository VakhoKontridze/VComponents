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
                    enabled: ColorBook.CircularButton.Text.enabled,
                    pressed: ColorBook.CircularButton.Text.pressed,
                    disabled: ColorBook.CircularButton.Text.disabled
                ),
                background: .init(
                    enabled: ColorBook.CircularButton.Fill.enabled,
                    pressed: ColorBook.CircularButton.Fill.pressed,
                    disabled: ColorBook.CircularButton.Fill.disabled
                )
            )
        }
    }
}

extension VCircularButtonViewModel {
    public struct StateColors {
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
    static func foreground(state: VRoundedButtonActualState, vm: VCircularButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        }
    }

    static func background(state: VRoundedButtonActualState, vm: VCircularButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.background.enabled
        case .pressed: return vm.colors.background.pressed
        case .disabled: return vm.colors.background.disabled
        }
    }
}
