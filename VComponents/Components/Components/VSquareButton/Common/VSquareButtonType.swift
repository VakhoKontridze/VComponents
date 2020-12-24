//
//  VSquareButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Square Button Type
public enum VSquareButtonType {
    case filled(_ model: VSquareButtonFilledModel = .init())
    case bordered(_ model: VSquareButtonBorderedModel = .init())
    
    public static let `default`: VSquareButtonType = .filled()
}
