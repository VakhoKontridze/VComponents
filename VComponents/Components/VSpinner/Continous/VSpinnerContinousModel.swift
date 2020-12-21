//
//  VSpinnerContinousModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model
public struct VSpinnerContinousModel {
    // MARK: Proeprties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(
        behavior: Behavior = .init(),
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
}

// MARK:- Behavior
extension VSpinnerContinousModel {
    public struct Behavior {
        // MARK: Proeprties
        public let animation: Animation
        
        // MARK: Initializers
        public init(
            animation: Animation = .linear(duration: 0.75)
        ) {
            self.animation = animation
        }
    }
}

// MARK:- Layout
extension VSpinnerContinousModel {
    public struct Layout {
        // MARK: Proeprties
        public let dimension: CGFloat
        public let legth: CGFloat
        public let thickness: CGFloat
        
        // MARK: Initializers
        public init(
            dimension: CGFloat = 15,
            legth: CGFloat = 0.75,
            thickness: CGFloat = 2
        ) {
            self.dimension = dimension
            self.legth = legth
            self.thickness = thickness
        }
    }
}

// MARK:- Colors
extension VSpinnerContinousModel {
    public struct Colors {
        // MARK: Proeprties
        public let spinner: Color
        
        // MARK: Initializers
        public init(
            spinner: Color
        ) {
            self.spinner = spinner
        }
        
        public init() {
            self.init(
                spinner: ColorBook.Spinner.fill
            )
        }
    }
}
