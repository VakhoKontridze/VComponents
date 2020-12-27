//
//  VAlertType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Alert Type
public enum VAlertType {
    case standard(_ model: VAlertModelStandard = .init())
    
    public static let `default`: VAlertType = .standard()
}
