//
//  VBaseViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Base View Model
/// Enum of models that describe UI
public enum VBaseViewModel {
    case centerTitle(_ model: VBaseViewModelCenter = .init())
    case leadingTitle(_ model: VBaseViewModelLeading = .init())
    
    public static let `default`: Self = .leadingTitle()
}
