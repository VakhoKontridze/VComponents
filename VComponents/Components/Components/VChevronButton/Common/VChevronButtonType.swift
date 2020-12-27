//
//  VChevronButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Chevron Button Type
public enum VChevronButtonType {
    case filled(_ model: VChevronButtonModelFilled = .init())
    case plain(_ model: VChevronButtonModelPlain = .init())
    
    public static let `default`: VChevronButtonType = .filled()
}
