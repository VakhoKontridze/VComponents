//
//  VProgressBarModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK:- V Progress Bar Model
public struct VProgressBarModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    var sliderModel: VSliderModel {
        var model: VSliderModel = .init()
        
        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.thumbDimension = 0
        
        model.colors.slider.track.enabled = colors.track
        model.colors.slider.progress.enabled = colors.progress
        
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
        public static let sliderColors = VSliderModel.Colors.SliderColors()
        
        public var track: Color = sliderColors.track.enabled
        public var progress: Color = sliderColors.progress.enabled

        public init() {}
    }
}
