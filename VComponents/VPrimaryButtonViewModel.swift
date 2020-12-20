//
//  VPrimaryButtonViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Primary Button ViewModel
public struct VPrimaryButtonViewModel {
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
extension VPrimaryButtonViewModel {
    public struct Layout {
        // MARK: Properties
        public let common: Common
        public let fixed: Fixed
        
        // MARK: Initializers
        public init(common: Common = .init(), fixed: Fixed = .init()) {
            self.common = common
            self.fixed = fixed
        }
    }
    
    public struct Common {
        // MARK: Properties
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let contentInset: CGFloat
        
        let loaderSpacing: CGFloat = 20
        let loaderWidth: CGFloat = 10
        
        // MARK: Initializers
        public init(height: CGFloat, cornerRadius: CGFloat, contentInset: CGFloat) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.contentInset = contentInset
        }
        
        public init() {
            self.init(
                height: 50,
                cornerRadius: 20,
                contentInset: 15
            )
        }
    }
    
    public struct Fixed {
        // MARK: Properties
        public let width: CGFloat
        
        // MARK: Initializers
        public init(width: CGFloat) {
            self.width = width
        }
        
        public init() {
            self.init(
                width: 300
            )
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonViewModel {
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

extension VPrimaryButtonViewModel.Colors {
    public struct ForegroundColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public let pressedOpacity: Double
        
        // MARK: Initializers
        public init(enabled: Color, pressed: Color, disabled: Color, loading: Color, pressedOpacity: Double) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
            self.pressedOpacity = pressedOpacity
        }
        
        public init() {
            self.init(
                enabled: ColorBook.PrimaryButton.Text.enabled,
                pressed: ColorBook.PrimaryButton.Text.pressed,
                disabled: ColorBook.PrimaryButton.Text.disabled,
                loading: ColorBook.PrimaryButton.Text.loading,
                
                pressedOpacity: 0.5
            )
        }
    }
    
    public struct BackgroundColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        // MARK: Initializers
        public init(enabled: Color, pressed: Color, disabled: Color, loading: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
        
        public init() {
            self.init(
                enabled: ColorBook.PrimaryButton.Fill.enabled,
                pressed: ColorBook.PrimaryButton.Fill.pressed,
                disabled: ColorBook.PrimaryButton.Fill.disabled,
                loading: ColorBook.PrimaryButton.Fill.loading
            )
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonViewModel {
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
extension VPrimaryButtonViewModel.Colors {
    static func foreground(state: VPrimaryButtonActualState, vm: VPrimaryButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        case .loading: return vm.colors.foreground.loading
        }
    }

    static func background(state: VPrimaryButtonActualState, vm: VPrimaryButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.background.enabled
        case .pressed: return vm.colors.background.pressed
        case .disabled: return vm.colors.background.disabled
        case .loading: return vm.colors.background.loading
        }
    }
    
    static func foregroundOpacity(state: VPrimaryButtonActualState, vm: VPrimaryButtonViewModel) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return vm.colors.foreground.pressedOpacity
        case .disabled: return 1
        case .loading: return 1
        }
    }
}
