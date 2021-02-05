//
//  VStepperModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/4/21.
//

import SwiftUI

// MARK:- V Stepper Picker Model
/// Model that describes UI
public struct VStepperModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VStepperModel {
    public struct Layout {
        public var size: CGSize = .init(width: 94, height: 32)
        public var cornerRadius: CGFloat = 7
        
        public var iconDimension: CGFloat = 15
        
        public var divider: CGSize = segmentedPickerReference.layout.dividerSize
        
        public init() {}
    }
}

// MARK:- Layout
extension VStepperModel {
    public struct Colors {
        public var background: StateColors = segmentedPickerReference.colors.background
        
        public var buttonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(componentAsset: "VStepper.Button.Background.pressed"),
            disabled: .clear
        )
        
        public var buttonIcon: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var divider: StateColors = segmentedPickerReference.colors.divider
        
        public init() {}
    }
}

extension VStepperModel.Colors {
    public typealias StateColors = StateColorsED
    
    public typealias ButtonStateColors = StateColorsEPD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- Misc
extension VStepperModel {
    public struct Misc {
        public var intervalToStartLongPressIncrement: TimeInterval = 1
        public var longPressIncrementExponent: Int = 2
        
        public init() {}
    }
}

// MARK:- References
extension VStepperModel {
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
}
