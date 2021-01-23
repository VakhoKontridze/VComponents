//
//  VSpinnerModelDashed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model Dashed
/// Model that describes UI
public struct VSpinnerModelDashed {
    public static let spinnerModelContinous: VSpinnerModelContinous = .init()
    
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Colors
extension VSpinnerModelDashed {
    public struct Colors {
        public var spinner: Color = VSpinnerModelDashed.spinnerModelContinous.colors.spinner
        
        public init() {}
    }
}

