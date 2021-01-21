//
//  VCheckBoxModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V CheckBox Model
/// Model that describes UI
public struct VCheckBoxModel {
    public static let toggleModel: VToggleModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = toggleModel.font    // Only applicable during init with title
    public var animation: Animation = toggleModel.animation
    public var contentIsClickable: Bool = toggleModel.contentIsClickable

    public init() {}
}

// MARK:- Layout
extension VCheckBoxModel {
    public struct Layout {
        public var dimension: CGFloat = 16
        public var cornerRadius: CGFloat = 4
        
        public var borderWith: CGFloat = 1
        
        public var iconDimension: CGFloat = 10
        
        public var hitBox: CGFloat = VCheckBoxModel.toggleModel.layout.contentMarginLeading
        
        public var contentMarginLeading: CGFloat = 0
    }
}

// MARK:- Colors
extension VCheckBoxModel {
    public struct Colors {
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: VCheckBoxModel.toggleModel.colors.fill.on,
            intermediate: VCheckBoxModel.toggleModel.colors.fill.on,
            disabled: ColorBook.primaryInverted
        )
        
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: .clear,
            intermediate: .clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        public var icon: StateColors = .init(
            off: .clear,
            on: VCheckBoxModel.toggleModel.colors.thumb.off,
            intermediate: VCheckBoxModel.toggleModel.colors.thumb.on,
            disabled: .clear
        )

        public var content: StateOpacity = .init(
            pressedOpacity: VCheckBoxModel.toggleModel.colors.content.pressedOpacity,
            disabledOpacity: VCheckBoxModel.toggleModel.colors.content.disabledOpacity
        )

        public var textContent: StateColors = .init(   // Only applicable during init with title
            off: VCheckBoxModel.toggleModel.colors.textContent.off,
            on: VCheckBoxModel.toggleModel.colors.textContent.on,
            intermediate: VCheckBoxModel.toggleModel.colors.textContent.on,
            disabled: VCheckBoxModel.toggleModel.colors.textContent.disabled
        )

        public init() {}
    }
}

extension VCheckBoxModel.Colors {
    public struct StateColors {
        public var off: Color
        public var on: Color
        public var intermediate: Color
        public var disabled: Color

        public init(off: Color, on: Color, intermediate: Color, disabled: Color) {
            self.off = off
            self.on = on
            self.intermediate = intermediate
            self.disabled = disabled
        }
        
        func `for`(_ state: VCheckBoxInternalState) -> Color {
            switch state {
            case .off: return off
            case .pressedOff: return off
            case .on: return on
            case .pressedOn: return on
            case .intermediate: return intermediate
            case .pressedIntermediate: return intermediate
            case .disabled: return disabled
            }
        }
    }

    public typealias StateOpacity = VPrimaryButtonModel.Colors.StateOpacity
}

extension VCheckBoxModel.Colors.StateOpacity {
    func `for`(_ state: VCheckBoxInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return pressedOpacity
        case .on: return 1
        case .pressedOn: return pressedOpacity
        case .intermediate: return 1
        case .pressedIntermediate: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
