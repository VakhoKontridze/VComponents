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
extension VPrimaryButtonViewModel {
    public struct Layout {
        // MARK: Properties
        public let height: CGFloat
        public let widthFixed: CGFloat
        public let cornerRadius: CGFloat
        public let contentInset: CGFloat
        
        // MARK: Initializers
        public init(height: CGFloat, widthFixed: CGFloat, cornerRadius: CGFloat, contentInset: CGFloat) {
            self.height = height
            self.widthFixed = widthFixed
            self.cornerRadius = cornerRadius
            self.contentInset = contentInset
        }
        
        public init() {
            self.init(
                height: 50,
                widthFixed: 300,
                cornerRadius: 20,
                contentInset: 15
            )
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonViewModel {
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
                    enabled: ColorBook.White.Text.enabled,
                    pressed: ColorBook.White.Text.pressed,
                    disabled: ColorBook.White.Text.disabled,
                    loading: ColorBook.White.Text.disabled
                ),
                background: .init(
                    enabled: ColorBook.Primary.Fill.enabled,
                    pressed: ColorBook.Primary.Fill.pressed,
                    disabled: ColorBook.Primary.Fill.disabledDark,
                    loading: ColorBook.Primary.Fill.disabledDark
                )
            )
        }
    }
    
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
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

// MARK:- Static View Model
extension VPrimaryButtonViewModel {
    struct Static {
        // MARK: Properties
        static let progressViewWidth: CGFloat = 10

        // MARK: Initializers
        private init() {}
    }
}
