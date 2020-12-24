//
//  VCircularButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Circular Button Type
public enum VCircularButtonType {
    case filled(_ model: VCircularButtonFilledModel = .init())
    case bordered(_ model: VCircularButtonBorderedModel = .init())
    
    public static let `default`: VCircularButtonType = .filled()
}
