//
//  VLazyListType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Lazy List Type
/// Enum of types, such as vertical or horizontal
public enum VLazyListType {
    case vertical(_ model: VLazyListModelVertical = .init())
    case horizontal(_ model: VLazyListModelHorizontal = .init())
    
    public static let `default`: Self = .vertical()
}
