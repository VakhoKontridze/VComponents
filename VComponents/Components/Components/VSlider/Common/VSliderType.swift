//
//  VSliderType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import Foundation

// MARK:- V Slider Type
public enum VSliderType {
    case standard(_ model: VSliderStandardModel = .init())
    case plain(_ model: VSliderPlainModel = .init())
    
    public static let `default`: VSliderType = .standard()
}
