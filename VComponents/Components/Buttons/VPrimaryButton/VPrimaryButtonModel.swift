//
//  VPrimaryButtonModelBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Primary Button Model
/// Model that describes UI
public struct VPrimaryButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    var spinnerSubModel: VSpinnerModelContinous {
        var model: VSpinnerModelContinous = .init()
        model.colors.spinner = colors.loader
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VPrimaryButtonModel {
    public struct Layout {
        public var height: CGFloat = 50
        public var cornerRadius: CGFloat = 20
        
        public var borderWidth: CGFloat = 0
        var hasBorder: Bool { borderWidth > 0 }
        
        public var contentMarginHor: CGFloat = 15
        public var contentMarginVer: CGFloat = 3
        
        public var loaderSpacing: CGFloat = 20
        let loaderWidth: CGFloat = 10
        
        public init() {}
    }
}

// MARK:- Colors
extension VPrimaryButtonModel {
    public struct Colors {
        public var content: StateOpacity = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(    // Only applicable during init with title
            enabled: ColorBook.primaryInverted,
            pressed: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted,
            loading: ColorBook.primaryInverted
        )
        
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "PrimaryButton.Background.enabled"),
            pressed: .init(componentAsset: "PrimaryButton.Background.pressed"),
            disabled: .init(componentAsset: "PrimaryButton.Background.disabled"),
            loading: .init(componentAsset: "PrimaryButton.Background.disabled")
        )
        
        public var border: StateColors = .init(
            enabled: .clear,
            pressed: .clear,
            disabled: .clear,
            loading: .clear
        )
        
        public var loader: Color = ColorBook.primaryInverted
        
        public init() {}
    }
}

extension VPrimaryButtonModel.Colors {
    public struct StateColors {
        public var enabled: Color
        public var pressed: Color
        public var disabled: Color
        public var loading: Color
        
        public init(enabled: Color, pressed: Color, disabled: Color, loading: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
        
        func `for`(_ state: VPrimaryButtonInternalState) -> Color {
            switch state {
            case .enabled: return enabled
            case .pressed: return pressed
            case .disabled: return disabled
            case .loading: return loading
            }
        }
    }
    
    public struct StateOpacity {
        public var pressedOpacity: Double
        public var disabledOpacity: Double
        
        public init(pressedOpacity: Double, disabledOpacity: Double) {
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VPrimaryButtonInternalState) -> Double {
            switch state {
            case .enabled: return 1
            case .pressed: return pressedOpacity
            case .disabled: return disabledOpacity
            case .loading: return disabledOpacity
            }
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonModel {
    public struct Fonts {
        public var title: Font = .system(size: 16, weight: .semibold, design: .default)  // Only applicable during init with title
        
        public init() {}
    }
}
