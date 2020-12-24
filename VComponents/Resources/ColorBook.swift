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
    public struct PrimaryButtonFilled {
        public struct Foreground {
            public static let enabled: Color = ColorBook.primaryInverted
            public static let pressed: Color = enabled
            public static let disabled: Color = enabled     // Opacity is applied
            public static let loading: Color = enabled      // Opacity is applied
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = .init("PrimaryButtonFilled.Background.enabled")
            public static let pressed: Color = .init("PrimaryButtonFilled.Background.pressed")
            public static let disabled: Color = .init("PrimaryButtonFilled.Background.disabled")
            public static let loading: Color = disabled
            
            private init() {}
        }
        
        public static let loader: Color = Foreground.enabled
        
        private init() {}
    }
    
    public struct PrimaryButtonBordered {
        public struct Foreground {
            public static let enabled: Color = PrimaryButtonFilled.Background.enabled
            public static let pressed: Color = enabled
            public static let disabled: Color = enabled     // Opacity is applied
            public static let loading: Color = enabled      // Opacity is applied
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = .init("PrimaryButtonBordered.Background.enabled")
            public static let pressed: Color = .init("PrimaryButtonBordered.Background.pressed")
            public static let disabled: Color = .init("PrimaryButtonBordered.Background.disabled")
            public static let loading: Color = disabled
            
            private init() {}
        }
        
        public struct Border {
            public static let enabled: Color = PrimaryButtonFilled.Background.enabled
            public static let pressed: Color = PrimaryButtonFilled.Background.disabled    // It's better this way
            public static let disabled: Color = PrimaryButtonFilled.Background.disabled
            public static let loading: Color = PrimaryButtonFilled.Background.loading
            
            private init() {}
        }
        
        public static let loader: Color = Foreground.enabled
        
        private init() {}
    }
}

// MARK:- Secondary Button
extension ColorBook {
    public struct SecondaryButtonFilled {
        public struct Foreground {
            public static let enabled: Color = PrimaryButtonFilled.Foreground.enabled
            public static let pressed: Color = PrimaryButtonFilled.Foreground.pressed
            public static let disabled: Color = PrimaryButtonFilled.Foreground.disabled
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = PrimaryButtonFilled.Background.enabled
            public static let pressed: Color = PrimaryButtonFilled.Background.pressed
            public static let disabled: Color = PrimaryButtonFilled.Background.disabled
            
            private init() {}
        }
        
        private init() {}
    }
    
    public struct SecondaryButtonBordered {
        public struct Foreground {
            public static let enabled: Color = PrimaryButtonBordered.Foreground.enabled
            public static let pressed: Color = PrimaryButtonBordered.Foreground.pressed
            public static let disabled: Color = PrimaryButtonBordered.Foreground.disabled
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = PrimaryButtonBordered.Background.enabled
            public static let pressed: Color = PrimaryButtonBordered.Background.pressed
            public static let disabled: Color = PrimaryButtonBordered.Background.disabled
            
            private init() {}
        }
        
        public struct Border {
            public static let enabled: Color = PrimaryButtonBordered.Border.enabled
            public static let pressed: Color = PrimaryButtonBordered.Border.pressed
            public static let disabled: Color = PrimaryButtonBordered.Border.disabled
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Square Button
extension ColorBook {
    public struct SquareButtonFilled {
        public struct Foreground {
            public static let enabled: Color = PrimaryButtonFilled.Foreground.enabled
            public static let pressed: Color = PrimaryButtonFilled.Foreground.enabled
            public static let disabled: Color = PrimaryButtonFilled.Foreground.enabled
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = PrimaryButtonFilled.Background.enabled
            public static let pressed: Color = PrimaryButtonFilled.Background.pressed
            public static let disabled: Color = PrimaryButtonFilled.Background.disabled
            
            private init() {}
        }
        
        private init() {}
    }
    
    public struct SquareButtonBordered {
        public struct Foreground {
            public static let enabled: Color = PrimaryButtonBordered.Foreground.enabled
            public static let pressed: Color = PrimaryButtonBordered.Foreground.pressed
            public static let disabled: Color = PrimaryButtonBordered.Foreground.disabled
            
            private init() {}
        }
        
        public struct Background {
            public static let enabled: Color = PrimaryButtonBordered.Background.enabled
            public static let pressed: Color = PrimaryButtonBordered.Background.pressed
            public static let disabled: Color = PrimaryButtonBordered.Background.disabled
            
            private init() {}
        }
        
        public struct Border {
            public static let enabled: Color = PrimaryButtonBordered.Border.enabled
            public static let pressed: Color = PrimaryButtonBordered.Border.pressed
            public static let disabled: Color = PrimaryButtonBordered.Border.disabled
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Plain Button
extension ColorBook {
    public struct PlainButtonStandard {
        public struct Foreground {
            public static let enabled: Color = ColorBook.accent
            public static let pressed: Color = enabled      // Opacity is applied
            public static let disabled: Color = enabled     // Opacity is applied
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Chevron Button
extension ColorBook {
    public struct ChevronButtonFilled {
        public struct Background {
            public static let enabled: Color = .init("ChevronButtonFilled.Background.enabled")
            public static let pressed: Color = .init("ChevronButtonFilled.Background.pressed")
            public static let disabled: Color = .init("ChevronButtonFilled.Background.disabled")
            
            private init() {}
        }
        
        public struct Foreground {
            public static let enabled: Color = ColorBook.primary
            public static let pressed: Color = enabled      // Opacity is applied
            public static let disabled: Color = enabled     // Opacity is applied
            
            private init() {}
        }
        
        private init() {}
    }
    
    public struct ChevronButtonPlain {
        public struct Foreground {
            public static let enabled: Color = .init("ChevronButtonPlain.Foreground.enabled")
            public static let pressed: Color = enabled      // Opacity is applied
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
            public static let enabledOn: Color = PrimaryButtonFilled.Background.enabled
            public static let enabledOff: Color = .init("Toggle.Fill.enabledOff")
            public static let disabledOn: Color = PrimaryButtonFilled.Background.disabled
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
        
        public struct Progress {
            public static let enabled: Color = Toggle.Fill.enabledOn
            public static let disabled: Color = Toggle.Fill.disabledOn
            
            private init() {}
        }
        
        public struct ThumbFill {
            public static let enabled: Color = Toggle.Thumb.enabledOn
            public static let disabled: Color = enabled
            
            private init() {}
        }
        
        public struct ThumbBorder {
            public static let enabled: Color = .init("Slider.ThumbBorderWidth.enabled")
            public static let disabled: Color = .init("Slider.ThumbBorderWidth.disabled")
            
            private init() {}
        }
        
        public struct ThumbShadow {
            public static let enabled: Color = .init("Slider.ThumbShadow.enabled")
            public static let disabled: Color = .init("Slider.ThumbShadow.disabled")
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Spinner
extension ColorBook {
    public struct Spinner {
        public static let background: Color = ColorBook.accent
        
        private init() {}
    }
}

// MARK:- Sheet
extension ColorBook {
    public struct Sheet {
        public static let background: Color = ColorBook.layer
        
        private init() {}
    }
    
    public struct SheetCustom {
        public static let background: Color = Sheet.background
        
        private init() {}
    }
}

// MARK:- Side Bar
extension ColorBook {
    public struct SideBarStandard {
        public static let background: Color = ColorBook.Sheet.background
        public static let blinding: Color = .init("SideBarStandard.Blinding")
        
        private init() {}
    }
}

// MARK:- Navigation View
extension ColorBook {
    public struct NavigationView {
        public static let background: Color = ColorBook.canvas
        
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
