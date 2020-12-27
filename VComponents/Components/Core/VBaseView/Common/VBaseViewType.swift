//
//  VBaseViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Base View Type
public enum VBaseViewType {
    case centerTitle(_ model: VBaseViewModelCenter = .init())
    case leadingTitle(_ model: VBaseViewModelLeading = .init())
    
    public static let `default`: VBaseViewType = .leadingTitle()
}
