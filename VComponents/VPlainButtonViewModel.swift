//
//  VPlainButtonViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button ViewModel
public struct VPlainButtonViewModel {
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
extension VPlainButtonViewModel {
    public struct Layout {
        // MARK: Properties
        public let hitAreaOffsetHor: CGFloat
        public let hitAreaOffsetVer: CGFloat
        
        // MARK: Initializers
        public init(hitAreaOffsetHor: CGFloat, hitAreaOffsetVer: CGFloat) {
            self.hitAreaOffsetHor = hitAreaOffsetHor
            self.hitAreaOffsetVer = hitAreaOffsetVer
        }
        
        public init() {
            self.init(
                hitAreaOffsetHor: 15,
                hitAreaOffsetVer: 5
            )
        }
    }
}

// MARK:- Colors
extension VPlainButtonViewModel {
    public struct Colors {
        // MARK: Properties
        public let foreground: StateColors
        
        // MARK: Initializers
        public init(foreground: StateColors) {
            self.foreground = foreground
        }
        
        public init() {
            self.init(
                foreground: .init(
                    enabled: Color(red: 10/255, green: 120/255, blue: 255/255, opacity: 1),
                    pressed: Color(red: 110/255, green: 160/255, blue: 250/255, opacity: 1),
                    disabled: Color(red: 130/255, green: 180/255, blue: 240/255, opacity: 1)
                )
            )
        }
    }
    
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
    }
}

// MARK:- Fonts
extension VPlainButtonViewModel {
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
