//
//  VSpinnerDashedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model
public struct VSpinnerDashedModel {
    // MARK: Proeprties
    public let colors: Colors
    
    // MARK: Initializers
    public init(
        colors: Colors = .init()
    ) {
        self.colors = colors
    }
}

// MARK:- Colors
extension VSpinnerDashedModel {
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
