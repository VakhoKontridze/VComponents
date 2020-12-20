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
    static let sceneTitle: String = "Slider"

    @State private var sliderState: VSliderState = .enabled

    @State private var plainSliderValue: Double = 0.5
    @State private var knobSliderValue: Double = 0.5
    @State private var solidKnobSliderValue: Double = 0.5
    
    @State private var steppedPlainSliderValue: Double = 0.5
    @State private var steppedKnobSliderValue: Double = 0.5
    @State private var steppedSolidKnobSliderValue: Double = 0.5
    
    @State private var animatedSliderValue: Double = 0.5
    @State private var animatedSteppedSliderValue: Double = 0.5
}

// MARK:- Body
extension VSliderDemoView {
    var body: some View {
        VStack(content: {
            controller

            VLazyListView(viewModel: .init(), content: {
                sliders
                steppedSliders
                animatedSliders
            })
        })
    }

    private var controller: some View {
        RowView(type: .controller, content: {
            HStack(content: {
                ToggleSettingView(
                    isOn: .init(
                        get: { sliderState == .disabled },
                        set: { sliderState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
            })
        })
    }

    private var sliders: some View {
        VStack(content: {
            RowView(type: .titled("Plain"), content: {
                VSlider(.plain, state: sliderState, value: $plainSliderValue, onChange: nil)
            })
            
            RowView(type: .titled("Knob"), content: {
                VSlider(.knob, state: sliderState, value: $knobSliderValue, onChange: nil)
            })
            
            RowView(type: .titled("Solid Knob"), content: {
                VSlider(.solidKnob, state: sliderState, value: $solidKnobSliderValue, onChange: nil)
            })
        })
    }
    
    private var steppedSliders: some View {
        VStack(content: {
            RowView(type: .titled("Plain (Stepped)"), content: {
                VSlider(.plain, step: 0.1, state: sliderState, value: $steppedPlainSliderValue, onChange: nil)
            })
            
            RowView(type: .titled("Knob (Stepped)"), content: {
                VSlider(.knob, step: 0.1, state: sliderState, value: $steppedKnobSliderValue, onChange: nil)
            })
            
            RowView(type: .titled("Solid Knob (Stepped)"), content: {
                VSlider(.solidKnob, step: 0.1, state: sliderState, value: $steppedSolidKnobSliderValue, onChange: nil)
            })
        })
    }
    
    private var animatedSliders: some View {
        let viewModel: VSliderViewModel = .init(
            behavior: .init(
                useAnimation: true
            ),
            layout: .init(),
            colors: .init()
        )
        
        return VStack(content: {
            RowView(type: .titled("Animation"), content: {
                VSlider(.plain, viewModel: viewModel, state: sliderState, value: $animatedSliderValue, onChange: nil)
            })
            
            RowView(type: .titled("Animation (Steped)"), content: {
                VSlider(.plain, viewModel: viewModel, step: 0.1, state: sliderState, value: $animatedSteppedSliderValue, onChange: nil)
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
