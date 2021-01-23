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
    public static let primaryButtonModel: VPrimaryButtonModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSquareButtonModel {
    public struct Layout {
        public var dimension: CGFloat = 56
        public var cornerRadius: CGFloat = 16
        
        public var borderWidth: CGFloat = 0
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
        public var content: StateOpacity = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
            enabled: VSquareButtonModel.primaryButtonModel.colors.textContent.enabled,
            pressed: VSquareButtonModel.primaryButtonModel.colors.textContent.pressed,
            disabled: VSquareButtonModel.primaryButtonModel.colors.textContent.disabled
        )
        
        public var background: StateColors = .init(
            enabled: VSquareButtonModel.primaryButtonModel.colors.background.enabled,
            pressed: VSquareButtonModel.primaryButtonModel.colors.background.pressed,
            disabled: VSquareButtonModel.primaryButtonModel.colors.background.disabled
        )
        
        public var border: StateColors = .init(
            enabled: VSquareButtonModel.primaryButtonModel.colors.border.enabled,
            pressed: VSquareButtonModel.primaryButtonModel.colors.border.pressed,
            disabled: VSquareButtonModel.primaryButtonModel.colors.border.disabled
        )
        
        public init() {}
    }
}

extension VSquareButtonModel.Colors {
    public typealias StateColors = VSecondaryButtonModel.Colors.StateColors
    
    public typealias StateOpacity = VSecondaryButtonModel.Colors.StateOpacity
}

extension VSquareButtonModel.Colors.StateColors {
    func `for`(_ state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}

extension VSquareButtonModel.Colors.StateOpacity {
    func `for`(_ state: VSquareButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}

// MARK:- Fonts
extension VSquareButtonModel {
    public struct Fonts {
        public var title: Font = .system(size: 14, weight: .semibold, design: .default)  // Only applicable during init with title
        
        public init() {}
    }
}
