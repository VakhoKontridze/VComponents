//
//  VBaseNavigationViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Base Navigation View Type
public enum VBaseNavigationViewType {
    case filled(_ model: VBaseNavigationViewFilledModel = .init())
    case transparent(_ model: VBaseNavigationViewTransparentModel = .init())
    
    public static let `default`: VBaseNavigationViewType = .filled()
}
