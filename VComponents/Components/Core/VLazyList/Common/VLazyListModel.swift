//
//  VLazyListModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Lazy List Model
/// Enum of models that describe UI
public enum VLazyListModel {
    case vertical(_ model: VLazyListModelVertical = .init())
    case horizontal(_ model: VLazyListModelHorizontal = .init())
    
    public static let `default`: Self = .vertical()
}
