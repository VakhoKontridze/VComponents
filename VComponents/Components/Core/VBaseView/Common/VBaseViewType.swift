//
//  VBaseViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Base View Type
public enum VBaseViewType {
    case centerTitle(_ model: VBaseViewCenterModel = .init())
    case leadingTitle(_ model: VBaseViewLeadingModel = .init())
    
    public static let `default`: VBaseViewType = .leadingTitle()
}
