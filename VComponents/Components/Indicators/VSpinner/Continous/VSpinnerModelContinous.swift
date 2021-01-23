//
//  VSpinnerModelContinous.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model Continous
/// Model that describes UI
public struct VSpinnerModelContinous {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSpinnerModelContinous {
    public struct Layout {
        public var dimension: CGFloat = 15
        public var legth: CGFloat = 0.75
        public var thickness: CGFloat = 2
        
        public init() {}
    }
}

// MARK:- Colors
extension VSpinnerModelContinous {
    public struct Colors {
        public var spinner: Color = ColorBook.accent
        
        public init() {}
    }
}

// MARK:- Animations
extension VSpinnerModelContinous {
    public struct Animations {
        public var spinning: Animation = .linear(duration: 0.75)
        
        public init() {}
    }
}
