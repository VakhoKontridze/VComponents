//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Color Book
public struct ColorBook {
    private init() {}
}

// MARK:- General
extension ColorBook {
    public static let canvas: Color = .init("Canvas")
    public static let layer: Color = .init("Layer")
    
    public static let primary: Color = .init("Primary")
    public static let accent: Color = .init("Accent")
    
    public static let primaryInverted: Color = .init("PrimaryInverted")
}

// MARK:- Primary Button
extension ColorBook {
    public struct PrimaryButton {
        public struct Text {
            public static let enabled: Color = ColorBook.primaryInverted
            public static let pressed: Color = enabled
            public static let disabled: Color = enabled // Opacity is applied
            public static let loading: Color = enabled // Opacity is applied
            
            private init() {}
        }
        
        public struct Fill {
            public static let enabled: Color = .init("PrimaryButton.Fill.enabled")
            public static let pressed: Color = .init("PrimaryButton.Fill.pressed")
            public static let disabled: Color = .init("PrimaryButton.Fill.disabled")
            public static let loading: Color = disabled
            
            private init() {}
        }
        
        public struct Border {
            public static let enabled: Color = Fill.disabled
            public static let pressed: Color = Fill.disabled
            public static let disabled: Color = Fill.disabled
            public static let loading: Color = Fill.disabled
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Plain Button
extension ColorBook {
    public struct PlainButton {
        public struct Text {
            public static let enabled: Color = ColorBook.accent
            public static let pressed: Color = enabled  // Opacity is applied
            public static let disabled: Color = enabled  // Opacity is applied
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Circular Button
extension ColorBook {
    public struct CircularButton {
        public struct Fill {
            public static let enabled: Color = PrimaryButton.Fill.enabled
            public static let pressed: Color = PrimaryButton.Fill.pressed
            public static let disabled: Color = PrimaryButton.Fill.disabled
            
            private init() {}
        }
        
        public struct Text {
            public static let enabled: Color = PrimaryButton.Text.enabled
            public static let pressed: Color = enabled   // Opacity is applied
            public static let disabled: Color = enabled     // Opacity is applied
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Toggle
extension ColorBook {
    public struct Toggle {
        public struct Fill {
            public static let enabledOn: Color = PrimaryButton.Fill.enabled
            public static let enabledOff: Color = .init("Toggle.Fill.enabledOff")
            public static let disabledOn: Color = PrimaryButton.Fill.disabled
            public static let disabledOff: Color = .init("Toggle.Fill.disabledOff")
            
            private init() {}
        }
        
        public struct Thumb {
            public static let enabledOn: Color = .init("Toggle.Thumb.enabledOn")
            public static let enabledOff: Color = enabledOn
            public static let disabledOn: Color = enabledOn
            public static let disabledOff: Color = enabledOn
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Slider
extension ColorBook {
    public struct Slider {
        public struct Track {
            public static let enabled: Color = Toggle.Fill.enabledOff
            public static let disabled: Color = Toggle.Fill.disabledOff
            
            private init() {}
        }
        
        public struct Shadow {
            public static let enabled: Color = .init("Slider.Shadow.enabled")
            public static let disabled: Color = .init("Slider.Shadow.disabled")
            
            private init() {}
        }
        
        public struct Progress {
            public static let enabled: Color = Toggle.Fill.enabledOn
            public static let disabled: Color = Toggle.Fill.disabledOn
            
            private init() {}
        }
        
        public struct Thumb {
            public static let enabled: Color = Toggle.Thumb.enabledOn
            public static let disabled: Color = enabled
            
            private init() {}
        }
        
        public struct ThumbStroke {
            public static let enabled: Color = .init("Slider.ThumbStroke.enabled")
            public static let disabled: Color = .init("Slider.ThumbStroke.disabled")
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Spinner
extension ColorBook {
    public struct Spinner {
        public static let fill: Color = ColorBook.accent
        
        private init() {}
    }
}

// MARK:- Helper
private extension Color {
    init(_ name: String) {
        guard
            let bundle = Bundle(identifier: "com.vakhtang-kontridze.VComponents"),
            let uiColor = UIColor(named: name, in: bundle, compatibleWith: nil)
        else {
            preconditionFailure()
        }
        
        self.init(uiColor)
    }
}
