//
//  VPrimaryButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button Type
public enum VPrimaryButtonType {
    case compact(viewModel: VPrimaryButtonCompactViewModel = .init())
    case fixed(viewModel: VPrimaryButtonFixedViewModel = .init())
    case flexible(viewModel: VPrimaryButtonFlexibleViewModel = .init())
}
