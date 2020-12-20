//
//  VSliderViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Slider View Model
public struct VSliderViewModel {
    // MARK: Properties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(behavior: Behavior, layout: Layout, colors: Colors) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
    
    public init() {
        self.init(
            behavior: .init(),
            layout: .init(),
            colors: .init()
        )
    }
}

// MARK:- Behavior
extension VSliderViewModel {
    public struct Behavior {
        // MARK: Properties
        public let useAnimation: Bool
        
        // MARK: Initializers
        public init(useAnimation: Bool) {
            self.useAnimation = useAnimation
        }
        
        public init() {
            self.init(
                useAnimation: false
            )
        }
    }
}

// MARK:- Layout
extension VSliderViewModel {
    public struct Layout {
        // MARK: Properties
        public let slider: Slider
        public let knob: Knob
        public let solidKnob: SolidKnob
        
        // MARK: Initializers
        public init(slider: Slider, knob: Knob, solidKnob: SolidKnob) {
            self.slider = slider
            self.knob = knob
            self.solidKnob = solidKnob
        }
        
        public init() {
            self.init(
                slider: .init(),
                knob: .init(),
                solidKnob: .init()
            )
        }
    }
}

extension VSliderViewModel.Layout {
    public struct Slider {
        // MARK: Properties
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        // MARK: Initializers
        public init(height: CGFloat, cornerRadius: CGFloat) {
            self.height = height
            self.cornerRadius = cornerRadius
        }
        
        public init() {
            self.init(
                height: 10,
                cornerRadius: 5
            )
        }
    }
}

extension VSliderViewModel.Layout {
    public struct Knob {
        // MARK: Properties
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        
        // MARK: Initializers
        public init(dimension: CGFloat, cornerRadius: CGFloat) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
        }
        
        public init() {
            self.init(
                dimension: 20,
                cornerRadius: 10
            )
        }
    }
}

extension VSliderViewModel.Layout {
    public struct SolidKnob {
        // MARK: Properties
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        
        public let stroke: CGFloat
        
        // MARK: Initializers
        public init(dimension: CGFloat, cornerRadius: CGFloat, stroke: CGFloat) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
            self.stroke = stroke
        }
        
        public init() {
            self.init(
                dimension: 20,
                cornerRadius: 10,
                stroke: 1
            )
        }
    }
}

// MARK:- Colors
extension VSliderViewModel {
    // MARK: Properties
    public struct Colors {
        // MARK: Properties
        public let common: Common
        public let knob: Knob
        public let solidKnob: SolidKnob
        
        // MARK: Initializers
        public init(common: Common, knob: Knob, solidKnob: SolidKnob) {
            self.common = common
            self.knob = knob
            self.solidKnob = solidKnob
        }
        
        public init() {
            self.init(
                common: .init(),
                knob: .init(),
                solidKnob: .init()
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct Common {
        // MARK: Properties
        public let progress: StateColors
        public let track: StateColors
        
        // MARK: Initializers
        public init(progress: StateColors, track: StateColors) {
            self.progress = progress
            self.track = track
        }
        
        public init() {
            self.init(
                progress: .init(
                    enabled: ColorBook.Slider.Progress.enabled,
                    disabled: ColorBook.Slider.Progress.disabled
                ),
                track: .init(
                    enabled: ColorBook.Slider.Track.enabled,
                    disabled: ColorBook.Slider.Track.disabled
                )
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct Knob {
        // MARK: Properties
        public let fill: StateColors
        public let shadow: StateColors
        
        // MARK: Initializers
        public init(fill: StateColors, shadow: StateColors) {
            self.fill = fill
            self.shadow = shadow
        }
        
        public init() {
            self.init(
                fill: .init(
                    enabled: ColorBook.Slider.Knob.enabled,
                    disabled: ColorBook.Slider.Knob.disabled
                ),
                shadow: .init(
                    enabled: ColorBook.Slider.Shadow.enabled,
                    disabled: ColorBook.Slider.Shadow.disabled
                )
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct SolidKnob {
        // MARK: Properties
        public let fill: StateColors
        public let stroke: StateColors
        
        // MARK: Initializers
        public init(fill: StateColors, stroke: StateColors) {
            self.fill = fill
            self.stroke = stroke
        }
        
        public init() {
            self.init(
                fill: .init(
                    enabled: ColorBook.Slider.Knob.enabled,
                    disabled: ColorBook.Slider.Knob.disabled
                ),
                stroke: .init(
                    enabled: ColorBook.Slider.KnobStroke.enabled,
                    disabled: ColorBook.Slider.KnobStroke.disabled
                )
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderViewModel.Colors {
    static func progress(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.common.progress.enabled
        case .disabled: return vm.colors.common.progress.disabled
        }
    }

    static func track(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.common.track.enabled
        case .disabled: return vm.colors.common.track.disabled
        }
    }
    
    static func knobFill(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.knob.fill.enabled
        case .disabled: return vm.colors.knob.fill.disabled
        }
    }
    
    static func knobShadow(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.knob.shadow.enabled
        case .disabled: return vm.colors.knob.shadow.disabled
        }
    }
    
    static func solidKnobFill(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.solidKnob.fill.enabled
        case .disabled: return vm.colors.solidKnob.fill.disabled
        }
    }
    
    static func solidKnobStroke(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.solidKnob.stroke.enabled
        case .disabled: return vm.colors.solidKnob.stroke.disabled
        }
    }
}
