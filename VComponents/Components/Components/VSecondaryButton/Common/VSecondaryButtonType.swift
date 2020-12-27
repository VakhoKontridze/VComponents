//
//  VSecondaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Secondary Button Type
public enum VSecondaryButtonType {
    case filled(_ model: VSecondaryButtonModelFilled = .init())
    case bordered(_ model: VSecondaryButtonModelBordered = .init())
    
    public static let `default`: VSecondaryButtonType = .filled()
}
