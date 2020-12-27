//
//  VPrimaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button Type
public enum VPrimaryButtonType {
    case filled(_ model: VPrimaryButtonModelFilled = .init())
    case bordered(_ model: VPrimaryButtonModelBordered = .init())
    
    public static let `default`: VPrimaryButtonType = .filled()
}
