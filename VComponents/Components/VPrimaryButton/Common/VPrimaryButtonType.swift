//
//  VPrimaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button Type
public enum VPrimaryButtonType {
    case compact(_ model: VPrimaryButtonCompactModel = .init())
    case fixed(_ model: VPrimaryButtonFixedModel = .init())
    case flexible(_ model: VPrimaryButtonFlexibleModel = .init())
}
