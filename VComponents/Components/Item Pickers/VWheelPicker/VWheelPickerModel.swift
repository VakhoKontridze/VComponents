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
        
        public var headerFooterSpacing: CGFloat = segmentedPickerReference.layout.headerFooterSpacing
        public var headerMarginHor: CGFloat = segmentedPickerReference.layout.headerFooterMarginHor
        
        public init() {}
    }
}

// MARK:- Colors
extension VWheelPickerModel {
    public struct Colors {
        public var content: StateOpacities = .init(
            disabledOpacity: segmentedPickerReference.colors.content.disabledOpacity
        )
        
        public var textContent: StateColors = segmentedPickerReference.colors.textContent   // Only applicable during init with title
        
        public var background: StateColors = .init(
            enabled: ColorBook.layer,
            disabled: ColorBook.layer
        )

        public var header: StateColors = segmentedPickerReference.colors.header
        
        public var footer: StateColors = segmentedPickerReference.colors.footer
        
        public init() {}
    }
}

extension VWheelPickerModel.Colors {
    public typealias StateColors = StateColorsED
    
    public typealias StateOpacities = StateOpacitiesD
}

// MARK:- Fonts
extension VWheelPickerModel {
    public struct Fonts {
        public var header: Font = segmentedPickerReference.fonts.header
        public var footer: Font = segmentedPickerReference.fonts.footer
        
        public var rows: Font = segmentedPickerReference.fonts.rows    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- References
extension VWheelPickerModel {
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
}
