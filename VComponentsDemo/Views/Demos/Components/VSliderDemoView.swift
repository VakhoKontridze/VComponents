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

    @State private var standardSliderValue: Double = 0.5
    @State private var plainSliderValue: Double = 0.5
    
    @State private var steppedStandardSliderValue: Double = 0.5
    @State private var steppedPlainSliderValue: Double = 0.5
    
    @State private var strokeSliderValue: Double = 0.5
    
    @State private var animatedSliderValue: Double = 0.5
    @State private var animatedSteppedSliderValue: Double = 0.5
}

// MARK:- Body
extension VSliderDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            sliders
            steppedSliders
            strokeSlider
            animatedSliders
        })
    }

    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
                    get: { sliderState == .disabled },
                    set: { sliderState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }

    private var sliders: some View {
        VStack(content: {
            DemoRowView(type: .titled("Standard"), content: {
                VSlider(.standard(), state: sliderState, value: $standardSliderValue)
            })
            
            DemoRowView(type: .titled("Plain"), content: {
                VSlider(.plain(), state: sliderState, value: $plainSliderValue)
            })
        })
    }
    
    private var steppedSliders: some View {
        VStack(content: {
            DemoRowView(type: .titled("Standard (Stepped)"), content: {
                VSlider(.standard(), step: 0.1, state: sliderState, value: $steppedStandardSliderValue)
            })
            
            DemoRowView(type: .titled("Plain (Stepped)"), content: {
                VSlider(.plain(), step: 0.1, state: sliderState, value: $steppedPlainSliderValue)
            })
        })
    }
    
    private var strokeSlider: some View {
        let model: VSliderStandardModel = .init(
            layout: .init(
                thumbStroke: 1,
                thumbShadowRadius: 0
            ),
            colors: .init(
                thumb: .init(
                    stroke: .init(
                        enabled: .black,
                        disabled: .gray
                    ),
                    shadow: .init(
                        enabled: .clear,
                        disabled: .clear
                    )
                )
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Thumb Stroke"), content: {
                VSlider(.standard(model), state: sliderState, value: $strokeSliderValue)
            })
        })
    }
    
    private var animatedSliders: some View {
        let model: VSliderPlainModel = .init(
            behavior: .init(
                animation: .default
            )
        )
        
        return VStack(content: {
            DemoRowView(type: .titled("Animation"), content: {
                VSlider(.plain(model), state: sliderState, value: $animatedSliderValue)
            })
            
            DemoRowView(type: .titled("Animation (Steped)"), content: {
                VSlider(.plain(model), step: 0.1, state: sliderState, value: $animatedSteppedSliderValue)
            })
        })
    }
}

// MARK:- Preview
struct VSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSliderDemoView()
    }
}
