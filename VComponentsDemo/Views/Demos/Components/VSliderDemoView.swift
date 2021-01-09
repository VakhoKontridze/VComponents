//
//  VSliderDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Slider Demo View
struct VSliderDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Slider"

    @State private var sliderState: VSliderState = .enabled

    @State private var standard1Value: Double = 0.5
    @State private var standard2Value: Double = 0.5
    @State private var standard3Value: Double = 0.5
    @State private var standard4Value: Double = 0.5
    @State private var standard5Value: Double = 0.5
    
    private let thumbBorderModel: VSliderModel = {
        var model: VSliderModel = .init()
        
        model.layout.thumbBorderWidth = 1
        model.layout.thumbShadowRadius = 0
        
        model.colors.thumb.border.enabled = .black
        model.colors.thumb.border.disabled = .gray
        
        model.colors.thumb.shadow.enabled = .clear
        model.colors.thumb.shadow.disabled = .clear
        
        return model
    }()

    private let plainModel: VSliderModel = {
        var model: VSliderModel = .init()
        
        model.layout.thumbDimension = 0
        model.layout.thumbCornerRadius = 0
        model.layout.thumbBorderWidth = 0
        model.layout.thumbShadowRadius = 0
        
        model.colors.thumb.fill.enabled = .clear
        model.colors.thumb.fill.disabled = .clear
        
        model.colors.thumb.border.enabled = .clear
        model.colors.thumb.border.disabled = .clear
        
        model.colors.thumb.shadow.enabled = .clear
        model.colors.thumb.shadow.disabled = .clear
        
        return model
    }()
    
    private let animationModel: VSliderModel = {
        var model: VSliderModel = .init()
        
        model.animation = .default
        
        return model
    }()
}

// MARK:- Body
extension VSliderDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            DemoRowView(type: .titled("Default"), content: {
                VSlider(state: sliderState, value: $standard1Value)
            })
            
            DemoRowView(type: .titled("Stepped"), content: {
                VSlider(step: 0.1, state: sliderState, value: $standard2Value)
            })
            
            DemoRowView(type: .titled("Thumb Border"), content: {
                VSlider(model: thumbBorderModel, state: sliderState, value: $standard3Value)
            })
            
            DemoRowView(type: .titled("Plain"), content: {
                VSlider(model: plainModel, state: sliderState, value: $standard4Value)
            })
            
            DemoRowView(type: .titled("Animation"), content: {
                VSlider(model: animationModel, state: sliderState, value: $standard5Value)
            })
        })
    }

    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                state: .init(
                    get: { sliderState == .disabled ? .on : .off },
                    set: { sliderState = $0.isOn ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Preview
struct VSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSliderDemoView()
    }
}
