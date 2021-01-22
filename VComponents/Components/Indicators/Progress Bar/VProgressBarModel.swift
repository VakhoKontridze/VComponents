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
    public static let sliderModel: VSliderModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    var sliderSubModel: VSliderModel {
        var model: VSliderModel = .init()
        
        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.thumbDimension = 0
        
        model.colors.slider.track = .init(
            enabled: colors.track,
            disabled: VProgressBarModel.sliderModel.colors.slider.track.disabled
        )
        
        model.colors.slider.progress = .init(
            enabled: colors.progress,
            disabled: VProgressBarModel.sliderModel.colors.slider.progress.disabled
        )
        
        return model
    }
    
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
        public var track: Color = VProgressBarModel.sliderModel.colors.slider.track.enabled
        public var progress: Color = VProgressBarModel.sliderModel.colors.slider.progress.enabled

        public init() {}
    }
}
