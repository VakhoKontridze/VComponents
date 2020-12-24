//
//  VSecondaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Secondary Button Type
public enum VSecondaryButtonType {
    case filled(_ model: VSecondaryButtonFilledModel = .init())
    case bordered(_ model: VSecondaryButtonBorderedModel = .init())
    
    public static let `default`: VSecondaryButtonType = .filled()
}
