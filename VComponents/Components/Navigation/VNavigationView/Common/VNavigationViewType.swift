//
//  VNavigationViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Navigation View Type
public enum VNavigationViewType {
    case filled(_ model: VNavigationViewModelFilled = .init())
    case transparent(_ model: VNavigationViewTransparentModel = .init())
    
    public static let `default`: VNavigationViewType = .filled()
}
