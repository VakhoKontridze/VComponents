//
//  VTabNavigationViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Tab Navigation View Type
public enum VTabNavigationViewType {
    case standard(_ model: VTabNavigationViewStandardModel = .init())
    
    public static let `default`: VTabNavigationViewType = standard()
}
