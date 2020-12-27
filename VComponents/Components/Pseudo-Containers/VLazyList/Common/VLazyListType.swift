//
//  VLazyListType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Lazy List Type
public enum VLazyListType {
    case vertical(_ model: VLazyListModelVertical = .init())
    case horizontal(_ model: VLazyListModelHorizontal = .init())
    
    public static let `default`: VLazyListType = .vertical()
}
