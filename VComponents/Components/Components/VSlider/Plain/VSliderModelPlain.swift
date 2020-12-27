//
//  VSliderModelPlain.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Slider Model Plain
public struct VSliderModelPlain {
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    public init(
        behavior: Behavior = .init(),
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
}

// MARK:- Behavior
extension VSliderModelPlain {
    public struct Behavior {
        public let animation: Animation?
        
        public init(
            animation: Animation? = nil
        ) {
            self.animation = animation
        }
    }
}

// MARK:- Layout
extension VSliderModelPlain {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        public init(
            height: CGFloat = 10,
            cornerRadius: CGFloat = 5
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
        }
    }
}

// MARK:- Colors
extension VSliderModelPlain {
    public struct Colors {
        public let progress: ProgressColors
        public let track: TrackColors
        
        public init(
            progress: ProgressColors = .init(),
            track: TrackColors = .init()
        ) {
            self.progress = progress
            self.track = track
        }
    }
}

extension VSliderModelPlain.Colors {
    public struct ProgressColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderPlain.Progress.enabled,
            disabled: Color = .clear//ColorBook.SliderPlain.Progress.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct TrackColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderPlain.Track.enabled,
            disabled: Color = .clear//ColorBook.SliderPlain.Track.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderModelPlain.Colors {
    func progressColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return progress.enabled
        case .disabled: return progress.disabled
        }
    }

    func trackColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return track.enabled
        case .disabled: return track.disabled
        }
    }
}
