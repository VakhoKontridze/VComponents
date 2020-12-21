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
    @State private var thumbSliderValue: Double = 0.5
    @State private var solidThumbSliderValue: Double = 0.5
    
    @State private var steppedPlainSliderValue: Double = 0.5
    @State private var steppedThumbSliderValue: Double = 0.5
    @State private var steppedSolidThumbSliderValue: Double = 0.5
    
    @State private var animatedSliderValue: Double = 0.5
    @State private var animatedSteppedSliderValue: Double = 0.5
}

// MARK:- Body
extension VSliderDemoView {
    var body: some View {
        VStack(content: {
            controller

            VLazyList(content: {
                sliders
                steppedSliders
                animatedSliders
            })
        })
            .navigationTitle(Self.sceneTitle)
    }

    private var controller: some View {
        RowView(type: .controller, content: {
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
            RowView(type: .titled("Plain"), content: {
                VSlider(.plain(), state: sliderState, value: $plainSliderValue)
            })
            
            RowView(type: .titled("Thumb"), content: {
                VSlider(.thumb(), state: sliderState, value: $thumbSliderValue)
            })
            
            RowView(type: .titled("Solid Thumb"), content: {
                VSlider(.solidThumb(), state: sliderState, value: $solidThumbSliderValue)
            })
        })
    }
    
    private var steppedSliders: some View {
        VStack(content: {
            RowView(type: .titled("Plain (Stepped)"), content: {
                VSlider(.plain(), step: 0.1, state: sliderState, value: $steppedPlainSliderValue)
            })
            
            RowView(type: .titled("Thumb (Stepped)"), content: {
                VSlider(.thumb(), step: 0.1, state: sliderState, value: $steppedThumbSliderValue)
            })
            
            RowView(type: .titled("Solid Thumb (Stepped)"), content: {
                VSlider(.solidThumb(), step: 0.1, state: sliderState, value: $steppedSolidThumbSliderValue)
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
            RowView(type: .titled("Animation"), content: {
                VSlider(.plain(model), state: sliderState, value: $animatedSliderValue)
            })
            
            RowView(type: .titled("Animation (Steped)"), content: {
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
