//
//  VSquareButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Square Button Model
/// Model that describes UI
public struct VSquareButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = .system(size: 14, weight: .semibold, design: .default)  // Only used in init with string
    
    public init() {}
}

// MARK:- Layout
extension VSquareButtonModel {
    public struct Layout {
        public var dimension: CGFloat = 56
        public var cornerRadius: CGFloat = 16
        
        public var borderWidth: CGFloat = 1
        var hasBorder: Bool { borderWidth > 0 }
        
        public var contentMarginHor: CGFloat = 3
        public var contentMarginVer: CGFloat = 3
        
        public var hitBoxHor: CGFloat = 0
        public var hitBoxVer: CGFloat = 0
        
        public init() {}
    }
}

// MARK:- Colors
extension VSquareButtonModel {
    public struct Colors {
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var content: StateOpacity = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only used in init with string
            enabled: primaryButtonColors.text.enabled,
            pressed: primaryButtonColors.text.pressed,
            disabled: primaryButtonColors.text.disabled
        )
        
        public var background: StateColors = .init(
            enabled: primaryButtonColors.background.enabled,
            pressed: primaryButtonColors.background.pressed,
            disabled: primaryButtonColors.background.disabled
        )
        
        public var border: StateColors = .init(
            enabled: primaryButtonColors.border.enabled,
            pressed: primaryButtonColors.border.pressed,
            disabled: primaryButtonColors.border.disabled
        )
        
        public init() {}
    }
}

extension VSquareButtonModel.Colors {
    public typealias StateColors = VSecondaryButtonModel.Colors.StateColors
    
    public typealias StateOpacity = VSecondaryButtonModel.Colors.StateOpacity
}

// MARK:- ViewModel
extension VSquareButtonModel.Colors {
    func contentOpacity(state: VSquareButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }
    
    func textColor(state: VSquareButtonInternalState) -> Color {
        color(for: state, from: text)
    }

    func backgroundColor(state: VSquareButtonInternalState) -> Color {
        color(for: state, from: background)
    }
    
    func borderColor(state: VSquareButtonInternalState) -> Color {
        color(for: state, from: border)
    }
    
    private func color(for state: VSquareButtonInternalState, from colorSet: StateColors) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .pressed: return colorSet.pressed
        case .disabled: return colorSet.disabled
        }
    }
}
