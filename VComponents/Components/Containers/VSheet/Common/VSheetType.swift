//
//  VSheetType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Sheet Type
public enum VSheetType {
    case roundAll(_ model: VSheetModelRoundAll = .init())
    case roundTop(_ model: VSheetModelRoundTop = .init())
    case roundBottom(_ model: VSheetModelRoundBottom = .init())
    case roundCustom(_ model: VSheetModelRoundCustom = .init())
    
    public static let `default`: VSheetType = .roundAll()
}
