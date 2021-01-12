//
//  VSpinnerModelContinous.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model Continous
public struct VSpinnerModelContinous {
    public var animation: Animation = .linear(duration: 0.75)
    public var layout: Layout = .init()
    public var color: Color = ColorBook.accent
    
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
