//
//  VPrimaryButtonModelBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Primary Button Model Bordered
public struct VPrimaryButtonModelBordered {
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
extension VPrimaryButtonModelBordered {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let borderType: BorderType
        public let borderWidth: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            borderType: BorderType = .continous,
            borderWidth: CGFloat = 1,
            contentMarginX: CGFloat = 15,
            contentMarginY: CGFloat = 3,
            loaderSpacing: CGFloat = 20,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.borderType = borderType
            self.borderWidth = borderWidth
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.loaderSpacing = loaderSpacing
            self.loaderWidth = 10
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

extension VPrimaryButtonModelBordered.Layout {
    public enum BorderType {
        case continous
        case dashed(spacing: CGFloat = 3)
    }
}

// MARK:- Colors
extension VPrimaryButtonModelBordered {
    public struct Colors {
        public let foreground: ForegroundColors
        public let background: BackgroundColors
        public let border: BorderColors
        public let loader: LoaderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            background: BackgroundColors = .init(),
            border: BorderColors = .init(),
            loader: LoaderColors = .init()
        ) {
            self.foreground = foreground
            self.background = background
            self.border = border
            self.loader = loader
        }
    }
}

extension VPrimaryButtonModelBordered.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonBordered.Foreground.enabled,
            pressed: Color = ColorBook.PrimaryButtonBordered.Foreground.pressed,
            disabled: Color = ColorBook.PrimaryButtonBordered.Foreground.disabled,
            loading: Color = ColorBook.PrimaryButtonBordered.Foreground.loading,
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
    
    public struct BackgroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonBordered.Background.enabled,
            pressed: Color = ColorBook.PrimaryButtonBordered.Background.pressed,
            disabled: Color = ColorBook.PrimaryButtonBordered.Background.disabled,
            loading: Color = ColorBook.PrimaryButtonBordered.Background.loading
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
    }
    
    public struct BorderColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonBordered.Border.enabled,
            pressed: Color = ColorBook.PrimaryButtonBordered.Border.pressed,
            disabled: Color = ColorBook.PrimaryButtonBordered.Border.disabled,
            loading: Color = ColorBook.PrimaryButtonBordered.Border.loading
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
            color: Color = ColorBook.PrimaryButtonBordered.loader
        ) {
            self.color = color
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonModelBordered {
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
extension VPrimaryButtonModelBordered.Colors {
    func foregroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        case .loading: return foreground.loading
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

    func backgroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return background.enabled
        case .pressed: return background.pressed
        case .disabled: return background.disabled
        case .loading: return background.loading
        }
    }
    
    func borderColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        case .loading: return border.loading
        }
    }
}
