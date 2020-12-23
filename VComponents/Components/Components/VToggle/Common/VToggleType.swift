//
//  VToggleType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import Foundation

// MARK:- V Toggle Type
public enum VToggleType {
    case standard(_ model: VToggleStandardModel = .init())
    case setting(_ model: VToggleSettingModel = .init())
    
    public static let `default`: VToggleType = .standard()
}
