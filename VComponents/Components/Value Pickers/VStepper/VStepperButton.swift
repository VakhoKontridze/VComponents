//
//  VStepperButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/4/21.
//

import SwiftUI

// MARK: V Stepper Button
enum VStepperButton {
    case minus
    case plus
    
    var icon: Image {
        switch self {
        case .minus: return ImageBook.minus
        case .plus: return ImageBook.plus
        }
    }
}
