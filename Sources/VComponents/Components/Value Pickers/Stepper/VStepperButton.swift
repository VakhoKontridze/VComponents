//
//  VStepperButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/4/21.
//

import SwiftUI

// MARK: - V Stepper Button
enum VStepperButton {
    // MARK: Cases
    case minus
    case plus
    
    // MARK: Properties
    var icon: Image {
        switch self {
        case .minus: return ImageBook.stepperDecrement
        case .plus: return ImageBook.stepperIncrement
        }
    }
}
