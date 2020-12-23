//
//  VSheetType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Sheet Type
public enum VSheetType {
    case roundAll(_ model: VSheetRoundAllModel = .init())
    case roundTop(_ model: VSheetRoundTopModel = .init())
    case roundBottom(_ model: VSheetRoundBottomModel = .init())
    case roundCustom(_ model: VSheetRoundCustomModel = .init())
}
