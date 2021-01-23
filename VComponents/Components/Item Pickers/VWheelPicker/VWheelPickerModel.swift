//
//  VWheelPickerModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Wheel Picker Model
/// Model that describes UI
public struct VWheelPickerModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    public init() {}
}

// MARK:- Layout
extension VWheelPickerModel {
    public struct Layout {
        public var cornerRadius: CGFloat = 15
        
        public var titleSpacing: CGFloat = segmentedPickerReference.layout.titleSpacing
        public var titleMarginHor: CGFloat = segmentedPickerReference.layout.titleMarginHor
        
        public init() {}
    }
}

// MARK:- Colors
extension VWheelPickerModel {
    public struct Colors {
        public var content: StateOpacity = .init(
            disabledOpacity: segmentedPickerReference.colors.content.disabledOpacity
        )
        
        public var textContent: StateColors = segmentedPickerReference.colors.textContent   // Only applicable during init with title
        
        public var background: StateColors = .init(
            enabled: ColorBook.layer,
            disabled: ColorBook.layer
        )

        public var title: StateColors = segmentedPickerReference.colors.title
        
        public var description: StateColors = segmentedPickerReference.colors.description
        
        public init() {}
    }
}

extension VWheelPickerModel.Colors {
    public typealias StateColors = VSegmentedPickerModel.Colors.StateColors
    
    public struct StateOpacity {
        public var disabledOpacity: Double
        
        public init(disabledOpacity: Double) {
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VWheelPickerState) -> Double {
            switch state {
            case .enabled: return 1
            case .disabled: return disabledOpacity
            }
        }
    }
}

extension VWheelPickerModel.Colors.StateColors {
    func `for`(_ state: VWheelPickerState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}

// MARK:- Fonts
extension VWheelPickerModel {
    public struct Fonts {
        public var title: Font = segmentedPickerReference.fonts.title
        public var description: Font = segmentedPickerReference.fonts.description
        
        public var rows: Font = segmentedPickerReference.fonts.rows    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- References
extension VWheelPickerModel {
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
}
