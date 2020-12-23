//
//  VChevronButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Chevron Button Type
public enum VChevronButtonType {
    case filled(_ model: VChevronButtonFilledModel = .init())
    case plain(_ model: VChevronButtonPlainModel = .init())
    
    public static let `default`: VChevronButtonType = .filled()
}
