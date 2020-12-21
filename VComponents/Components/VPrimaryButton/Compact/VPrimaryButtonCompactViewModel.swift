//
//  VPrimaryButtonCompactViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Compact ViewModel
public struct VPrimaryButtonCompactViewModel {
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
public extension VPrimaryButtonCompactViewModel {
    struct Layout {
        // MARK: Properties
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let borderWidth: CGFloat
        public let contentInset: CGFloat
        let loaderSpacing: CGFloat = 20
        let loaderWidth: CGFloat = 10
        
        // MARK: Initializers
        public init(height: CGFloat, cornerRadius: CGFloat, borderWidth: CGFloat, contentInset: CGFloat) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.contentInset = contentInset
        }
        
        public init() {
            self.init(
                height: 50,
                cornerRadius: 20,
                borderWidth: 0,
                contentInset: 15
            )
        }
    }
}

// MARK:- Colors
public extension VPrimaryButtonCompactViewModel {
    struct Colors {
        // MARK: Properties
        public let foreground: ForegroundColors
        public let fill: FillColors
        public let border: BorderColors
        
        // MARK: Initializers
        public init(foreground: ForegroundColors = .init(), fill: FillColors = .init(), border: BorderColors = .init()) {
            self.foreground = foreground
            self.fill = fill
            self.border = border
        }
    }
}

extension VPrimaryButtonCompactViewModel.Colors {
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
    
    public struct FillColors {
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
    
    public struct BorderColors {
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
                enabled: ColorBook.PrimaryButton.Border.enabled,
                pressed: ColorBook.PrimaryButton.Border.pressed,
                disabled: ColorBook.PrimaryButton.Border.disabled,
                loading: ColorBook.PrimaryButton.Border.loading
            )
        }
    }
}

// MARK:- Fonts
public extension VPrimaryButtonCompactViewModel {
    struct Fonts {
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
extension VPrimaryButtonCompactViewModel.Colors {
    func foregroundColor(state: VPrimaryButtonActualState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        case .loading: return foreground.loading
        }
    }

    func fillColor(state: VPrimaryButtonActualState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        case .loading: return fill.loading
        }
    }
    
    func borderColor(state: VPrimaryButtonActualState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        case .loading: return border.loading
        }
    }
    
    func foregroundOpacity(state: VPrimaryButtonActualState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return 1
        case .loading: return 1
        }
    }
}
