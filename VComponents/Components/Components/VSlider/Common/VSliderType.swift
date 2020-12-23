//
//  VSliderType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import Foundation

// MARK:- V Slider Type
public enum VSliderType {
    case plain(_ model: VSliderPlainModel = .init())
    case thumb(_ model: VSliderThumbModel = .init())
    case solidThumb(_ model: VSliderSolidThumbModel = .init())
}
