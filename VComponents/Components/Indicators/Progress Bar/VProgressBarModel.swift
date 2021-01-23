//
//  VProgressBarModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK:- V Progress Bar Model
/// Model that describes UI
public struct VProgressBarModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VProgressBarModel {
    public struct Layout {
        public var height: CGFloat = 10
        public var cornerRadius: CGFloat = 5
        
        public init() {}
    }
}

// MARK:- Colors
extension VProgressBarModel {
    public struct Colors {
        public var track: Color = sliderReference.colors.slider.track.enabled
        public var progress: Color = sliderReference.colors.slider.progress.enabled

        public init() {}
    }
}

// MARK:- References
extension VProgressBarModel {
    public static let sliderReference: VSliderModel = .init()
}

// MARK:- Sub-Models
extension VProgressBarModel {
    var sliderSubModel: VSliderModel {
        var model: VSliderModel = .init()
        
        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.thumbDimension = 0
        
        model.colors.slider.track = .init(
            enabled: colors.track,
            disabled: VProgressBarModel.sliderReference.colors.slider.track.disabled
        )
        
        model.colors.slider.progress = .init(
            enabled: colors.progress,
            disabled: VProgressBarModel.sliderReference.colors.slider.progress.disabled
        )
        
        return model
    }
}
