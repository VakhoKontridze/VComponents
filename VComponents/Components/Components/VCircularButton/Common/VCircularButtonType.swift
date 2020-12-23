//
//  VCircularButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Circular Button Type
public enum VCircularButtonType {
    case standard(_ model: VCircularButtonStandardModel = .init())
    
    public static let `default`: VCircularButtonType = .standard()
}
