//
//  VSpinnerModelDashed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model Dashed
public struct VSpinnerModelDashed {
    public let colors: Colors
    
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VSpinnerModelDashed {
    public struct Colors {
        public let spinner: Color
        
        public init(
            spinner: Color = ColorBook.Spinner.background
        ) {
            self.spinner = spinner
        }
    }
}
