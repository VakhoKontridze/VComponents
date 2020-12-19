//
//  VButtonViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Button ViewModel
public struct VButtonViewModel {
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
extension VButtonViewModel {
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
extension VButtonViewModel {
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
                    enabled: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1),
                    pressed: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1),
                    disabled: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5),
                    loading: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5)
                ),
                background: .init(
                    enabled: Color(red: 50/255, green: 130/255, blue: 230/255, opacity: 1),
                    pressed: Color(red: 30/255, green: 90/255, blue: 160/255, opacity: 1),
                    disabled: Color(red: 130/255, green: 180/255, blue: 240/255, opacity: 1),
                    loading: Color(red: 130/255, green: 180/255, blue: 240/255, opacity: 1)
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
extension VButtonViewModel {
    public struct Fonts {
        // MARK: Properties
        public let title: Font
        
        // MARK: Initializers
        public init(title: Font) {
            self.title = title
        }
        
        public init() {
            self.init(
                title: .system(size: 14, weight: .semibold, design: .default)
            )
        }
    }
}

// MARK:- Static View Model
extension VButtonViewModel {
    struct Static {
        // MARK: Properties
        static let progressViewWidth: CGFloat = 10

        // MARK: Initializers
        private init() {}
    }
}
