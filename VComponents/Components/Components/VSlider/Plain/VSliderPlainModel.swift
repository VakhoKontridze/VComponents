//
//  VSliderPlainModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Slider Plain Model
public struct VSliderPlainModel {
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
extension VSliderPlainModel {
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
extension VSliderPlainModel {
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
extension VSliderPlainModel {
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

extension VSliderPlainModel.Colors {
    public struct ProgressColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Progress.enabled,
            disabled: Color = ColorBook.Slider.Progress.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct TrackColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Track.enabled,
            disabled: Color = ColorBook.Slider.Track.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderPlainModel.Colors {
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
