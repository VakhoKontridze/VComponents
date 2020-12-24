//
//  VPrimaryButtonBorderedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Primary Button Bordered Model
public struct VPrimaryButtonBorderedModel {
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
extension VPrimaryButtonBorderedModel {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let borderType: BorderType
        public let borderWidth: CGFloat
        public let contentInset: CGFloat
        public let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        public let hitBoxExtendX: CGFloat
        public let hitBoxExtendY: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            borderType: BorderType = .continous,
            borderWidth: CGFloat = 1,
            contentInset: CGFloat = 15,
            loaderSpacing: CGFloat = 20,
            hitBoxExtendX: CGFloat = 0,
            hitBoxExtendY: CGFloat = 0
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.borderType = borderType
            self.borderWidth = borderWidth
            self.contentInset = contentInset
            self.loaderSpacing = loaderSpacing
            self.loaderWidth = 10
            self.hitBoxExtendX = hitBoxExtendX
            self.hitBoxExtendY = hitBoxExtendY
        }
    }
}

extension VPrimaryButtonBorderedModel.Layout {
    public enum BorderType {
        case continous
        case dashed(spacing: CGFloat = 3)
    }
}

// MARK:- Colors
extension VPrimaryButtonBorderedModel {
    public struct Colors {
        public let foreground: ForegroundColors
        public let fill: FillColors
        public let border: BorderColors
        public let loader: LoaderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            fill: FillColors = .init(),
            border: BorderColors = .init(),
            loader: LoaderColors = .init()
        ) {
            self.foreground = foreground
            self.fill = fill
            self.border = border
            self.loader = loader
        }
    }
}

extension VPrimaryButtonBorderedModel.Colors {
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
    
    public struct FillColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonBordered.Fill.enabled,
            pressed: Color = ColorBook.PrimaryButtonBordered.Fill.pressed,
            disabled: Color = ColorBook.PrimaryButtonBordered.Fill.disabled,
            loading: Color = ColorBook.PrimaryButtonBordered.Fill.loading
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
extension VPrimaryButtonBorderedModel {
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
extension VPrimaryButtonBorderedModel.Colors {
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
    
    func borderColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        case .loading: return border.loading
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
