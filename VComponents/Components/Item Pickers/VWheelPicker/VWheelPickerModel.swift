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
        public var titlePaddingHor: CGFloat = segmentedPickerLayout.titlePaddingHor
        
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
        
        public var text: StateColors = segmentedPickerColors.text   // Only applicable during init with title
        
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

// MARK:- ViewModel
extension VWheelPickerModel.Colors {
    func foregroundOpacity(state: VWheelPickerState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return content.disabledOpacity
        }
    }
    
    func textColor(for state: VWheelPickerState) -> Color {
        color(for: state, from: text)
    }
    
    func backgroundColor(for state: VWheelPickerState) -> Color {
        color(for: state, from: background)
    }
    
    func titleColor(for state: VWheelPickerState) -> Color {
        color(for: state, from: title)
    }
    
    func descriptionColor(for state: VWheelPickerState) -> Color {
        color(for: state, from: description)
    }
    
    private func color(for state: VWheelPickerState, from colorSet: StateColors) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .disabled: return colorSet.disabled
        }
    }
}
