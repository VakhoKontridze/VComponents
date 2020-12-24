//
//  VPrimaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button Type
public enum VPrimaryButtonType {
    case filled(_ model: VPrimaryButtonFilledModel = .init())
    case bordered(_ model: VPrimaryButtonBorderedModel = .init())
    
    public static let `default`: VPrimaryButtonType = .filled()
}
