//
//  VToggleType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import Foundation

// MARK:- V Toggle Type
public enum VToggleType {
    case rightContent(viewModel: VToggleRightContentViewModel = .init())
    case spacedLeftContent(viewModel: VToggleLeftFlexibleContentViewModel = .init())
}
