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
    public init(behavior: Behavior = .init(), layout: Layout = .init(), colors: Colors = .init()) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
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
        public let thumb: Thumb
        public let solidThumb: SolidThumb
        
        // MARK: Initializers
        public init(slider: Slider = .init(), thumb: Thumb = .init(), solidThumb: SolidThumb = .init()) {
            self.slider = slider
            self.thumb = thumb
            self.solidThumb = solidThumb
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
    public struct Thumb {
        // MARK: Properties
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        let shadowRadius: CGFloat = 2
        
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
    public struct SolidThumb {
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
        public let thumb: Thumb
        public let solidThumb: SolidThumb
        
        // MARK: Initializers
        public init(common: Common = .init(), thumb: Thumb = .init(), solidThumb: SolidThumb = .init()) {
            self.common = common
            self.thumb = thumb
            self.solidThumb = solidThumb
        }
    }
}

extension VSliderViewModel.Colors {
    public struct Common {
        // MARK: Properties
        public let progress: ProgressColors
        public let track: TrackColors
        
        // MARK: Initializers
        public init(progress: ProgressColors = .init(), track: TrackColors = .init()) {
            self.progress = progress
            self.track = track
        }
    }
}

extension VSliderViewModel.Colors.Common {
    public struct ProgressColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Progress.enabled,
                disabled: ColorBook.Slider.Progress.disabled
            )
        }
    }
    
    public struct TrackColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Track.enabled,
                disabled: ColorBook.Slider.Track.disabled
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct Thumb {
        // MARK: Properties
        public let fill: FillColors
        public let shadow: ShadowColors
        
        // MARK: Initializers
        public init(fill: FillColors = .init(), shadow: ShadowColors = .init()) {
            self.fill = fill
            self.shadow = shadow
        }
    }
}

extension VSliderViewModel.Colors.Thumb {
    public struct FillColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Thumb.enabled,
                disabled: ColorBook.Slider.Thumb.disabled
            )
        }
    }
    
    public struct ShadowColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Shadow.enabled,
                disabled: ColorBook.Slider.Shadow.disabled
            )
        }
    }
}

extension VSliderViewModel.Colors {
    public struct SolidThumb {
        // MARK: Properties
        public let fill: FillColors
        public let stroke: StrokeColors
        
        // MARK: Initializers
        public init(fill: FillColors = .init(), stroke: StrokeColors = .init()) {
            self.fill = fill
            self.stroke = stroke
        }
    }
}

extension VSliderViewModel.Colors.SolidThumb {
    public struct FillColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Thumb.enabled,
                disabled: ColorBook.Slider.Thumb.disabled
            )
        }
    }
    
    public struct StrokeColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.ThumbStroke.enabled,
                disabled: ColorBook.Slider.ThumbStroke.disabled
            )
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
    
    static func thumbFill(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.thumb.fill.enabled
        case .disabled: return vm.colors.thumb.fill.disabled
        }
    }
    
    static func thumbShadow(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.thumb.shadow.enabled
        case .disabled: return vm.colors.thumb.shadow.disabled
        }
    }
    
    static func solidThumbFill(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.solidThumb.fill.enabled
        case .disabled: return vm.colors.solidThumb.fill.disabled
        }
    }
    
    static func solidThumbStroke(state: VSliderState, vm: VSliderViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.solidThumb.stroke.enabled
        case .disabled: return vm.colors.solidThumb.stroke.disabled
        }
    }
}
