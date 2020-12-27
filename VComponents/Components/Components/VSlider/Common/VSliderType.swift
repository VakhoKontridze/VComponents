//
//  VSliderType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import Foundation

// MARK:- V Slider Type
public enum VSliderType {
    case standard(_ model: VSliderModelStandard = .init())
    case plain(_ model: VSliderModelPlain = .init())
    
    public static let `default`: VSliderType = .standard()
}
