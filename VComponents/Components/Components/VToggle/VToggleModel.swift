//
//  VToggleRightContentModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Model
public struct VToggleModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = .system(size: 15, weight: .regular, design: .default)    // Only used in init with string
    public var behavior: Behavior = .init()
    
    public init() {}
}

// MARK:- Layout
extension VToggleModel {
    public struct Layout {
        public var size: CGSize = .init(width: 51, height: 31)
        public var thumbDimension: CGFloat = 27
        
        public var contentSpacing: CGFloat = 7
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumnStartPoint - spacing
            return offset
        }
    }
}

// MARK:- Colors
extension VToggleModel {
    public struct Colors {
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var fill: StateColors = .init(
            off: .init(componentAsset: "Toggle.Fill.off"),
            on: primaryButtonColors.background.enabled,
            disabled: .init(componentAsset: "Toggle.Fill.disabled")
        )
        
        public var thumb: StateColors = .init(
            off: .init(componentAsset: "Toggle.Thumb"),
            on: .init(componentAsset: "Toggle.Thumb"),
            disabled: .init(componentAsset: "Toggle.Thumb")
        )
        
        public var content: StateOpacityColors = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only used in init with string
            off: ColorBook.primary,
            on: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public init() {}
    }
}

extension VToggleModel.Colors {
    public struct StateColors {
        public var off: Color
        public var on: Color
        public var disabled: Color
        
        public init(off: Color, on: Color, disabled: Color) {
            self.off = off
            self.on = on
            self.disabled = disabled
        }
    }

    public typealias StateOpacityColors = VPrimaryButtonModel.Colors.StateOpacityColors
}

// MARK:- Behavior
extension VToggleModel {
    public struct Behavior {
        public var contentIsClickable: Bool = true
        public var animation: Animation = .easeIn(duration: 0.1)
        
        public init() {}
    }
}

// MARK:- ViewModel
extension VToggleModel.Colors {
    func fillColor(state: VToggleInternalState) -> Color {
        color(state: state, from: fill)
    }
    
    func thumbColor(state: VToggleInternalState) -> Color {
        color(state: state, from: thumb)
    }
    
    func contentOpacity(state: VToggleInternalState) -> Double {
        switch state {
        case .off: return 1
        case .on: return 1
        case .pressedOff, .pressedOn: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }
    
    func textColor(state: VToggleInternalState) -> Color {
        color(state: state, from: text)
    }
    
    private func color(state: VToggleInternalState, from colorSet: StateColors) -> Color {
        switch state {
        case .off: return colorSet.off
        case .on: return colorSet.on
        case .pressedOff: return colorSet.off
        case .pressedOn: return colorSet.on
        case .disabled: return colorSet.disabled
        }
    }
}
