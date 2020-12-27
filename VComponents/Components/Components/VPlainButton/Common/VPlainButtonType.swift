//
//  VPlainButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK:- V Plain Button Type
public enum VPlainButtonType {
    case standard(_ model: VPlainButtonModelStandard = .init())
    
    public static let `default`: VPlainButtonType = .standard()
}
