//
//  VPrimaryButtonFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Filled Model
public struct VPrimaryButtonFilledModel {
    public let layout: Layout
    public let colors: Colors
    public let fonts: Fonts
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
    }
}

// MARK:- Layout
extension VPrimaryButtonFilledModel {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let contentInset: CGFloat
        public let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        public let hitBoxExtendX: CGFloat
        public let hitBoxExtendY: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            contentInset: CGFloat = 15,
            loaderSpacing: CGFloat = 20,
            hitBoxExtendX: CGFloat = 0,
            hitBoxExtendY: CGFloat = 0
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.contentInset = contentInset
            self.loaderSpacing = loaderSpacing
            self.loaderWidth = 10
            self.hitBoxExtendX = hitBoxExtendX
            self.hitBoxExtendY = hitBoxExtendY
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonFilledModel {
    public struct Colors {
        public let foreground: ForegroundColors
        public let fill: FillColors
        public let loader: LoaderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            fill: FillColors = .init(),
            loader: LoaderColors = .init()
        ) {
            self.foreground = foreground
            self.fill = fill
            self.loader = loader
        }
    }
}

extension VPrimaryButtonFilledModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.PrimaryButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.PrimaryButtonFilled.Foreground.disabled,
            loading: Color = ColorBook.PrimaryButtonFilled.Foreground.loading,
            pressedOpacity: Double = 0.5,
            disabledOpacity: Double = 0.5
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
    }
    
    public struct FillColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonFilled.Fill.enabled,
            pressed: Color = ColorBook.PrimaryButtonFilled.Fill.pressed,
            disabled: Color = ColorBook.PrimaryButtonFilled.Fill.disabled,
            loading: Color = ColorBook.PrimaryButtonFilled.Fill.loading
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
    }
    
    public struct LoaderColors {
        public let color: Color
        
        public init(
            color: Color = ColorBook.PrimaryButtonFilled.loader
        ) {
            self.color = color
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonFilledModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.buttonLarge
        ) {
            self.title = title
        }
    }
}

// MARK:- Mapping
extension VPrimaryButtonFilledModel.Colors {
    func foregroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        case .loading: return foreground.loading
        }
    }

    func fillColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        case .loading: return fill.loading
        }
    }
    
    func foregroundOpacity(state: VPrimaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        case .loading: return foreground.disabledOpacity
        }
    }
}
