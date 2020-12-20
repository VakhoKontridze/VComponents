//
//  VSpinnerViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Spinner ViewModel
public struct VSpinnerViewModel {
    // MARK: Proeprties
    let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(layout: Layout, colors: Colors) {
        self.behavior = .init()
        self.layout = layout
        self.colors = colors
    }
    
    public init() {
        self.init(
            layout: .init(),
            colors: .init()
        )
    }
}

// MARK:- Behavior
extension VSpinnerViewModel {
    public struct Behavior {
        // MARK: Proeprties
        public let animation: Animation
        
        // MARK: Initializers
        public init(animation: Animation) {
            self.animation = animation
        }
        
        public init() {
            self.init(
                animation: Animation.linear(duration: 0.75)
            )
        }
    }
}

// MARK:- Layout
extension VSpinnerViewModel {
    public struct Layout {
        // MARK: Proeprties
        public let dimension: CGFloat
        public let legth: CGFloat
        public let thickness: CGFloat
        
        // MARK: Initializers
        public init(dimension: CGFloat, legth: CGFloat, thickness: CGFloat) {
            self.dimension = dimension
            self.legth = legth
            self.thickness = thickness
        }
        
        public init() {
            self.init(
                dimension: 15,
                legth: 0.75,
                thickness: 2
            )
        }
    }
}

// MARK:- Colors
extension VSpinnerViewModel {
    public struct Colors {
        // MARK: Proeprties
        public let spinner: Color
        
        // MARK: Initializers
        public init(spinner: Color) {
            self.spinner = spinner
        }
        
        public init() {
            self.init(
                spinner: ColorBook.Spinner.fill
            )
        }
    }
}
