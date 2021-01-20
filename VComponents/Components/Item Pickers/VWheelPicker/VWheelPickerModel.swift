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
        public static let segmentedPickerLayout: VSegmentedPickerModel.Layout = .init()
        
        public var cornerRadius: CGFloat = 15
        
        public var titleSpacing: CGFloat = segmentedPickerLayout.titleSpacing
        public var titleMarginHor: CGFloat = segmentedPickerLayout.titleMarginHor
        
        public init() {}
    }
}

// MARK:- Colors
extension VWheelPickerModel {
    public struct Colors {
        public static let segmentedPickerColors: VSegmentedPickerModel.Colors = .init()
        
        public var content: StateOpacity = .init(
            disabledOpacity: segmentedPickerColors.content.disabledOpacity
        )
        
        public var textContent: StateColors = segmentedPickerColors.textContent   // Only applicable during init with title
        
        public var background: StateColors = .init(
            enabled: ColorBook.layer,
            disabled: ColorBook.layer
        )

        public var title: StateColors = segmentedPickerColors.title
        
        public var description: StateColors = segmentedPickerColors.description
        
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
        public static let segmentedPickerFonts: VSegmentedPickerModel.Fonts = .init()
        
        public var title: Font = segmentedPickerFonts.title
        public var description: Font = segmentedPickerFonts.description
        
        public var rows: Font = segmentedPickerFonts.rows    // Only applicable during init with title
        
        public init() {}
    }
}
