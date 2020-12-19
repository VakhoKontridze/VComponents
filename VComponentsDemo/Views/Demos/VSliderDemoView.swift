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
    
    @State private var roundedSliderValue: Double = 0.5
    @State private var roundedSliderSteppedValue: Double = 0.5
    
    @State private var roundedSliderAnimationsValue: Double = 0.5
    @State private var roundedSliderSteppedAnimationsValue: Double = 0.5
    
    @State private var thinSliderValue: Double = 0.5
    @State private var thinSliderSteppedValue: Double = 0.5
}

// MARK:- Body
extension VSliderDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(viewModel: .init(), content: {
                roundedSliders
                roundedSlidersAnimation
                thinSliders
            })
        })
    }
    
    private var controller: some View {
        RowView(title: nil, content: {
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
    
    private var roundedSliders: some View {
        VStack(content: {
            RowView(
                title: "Rounded",
                content: { VSlider(state: sliderState, value: $roundedSliderValue, type: .rounded, viewModel: .init(), onChange: nil) }
            )
            
            RowView(
                title: "Rounded (Steps)",
                content: { VSlider(state: sliderState, value: $roundedSliderSteppedValue, step: 0.1, type: .rounded, viewModel: .init(), onChange: nil) }
            )
        })
    }
    
    private var roundedSlidersAnimation: some View {
        let viewModel: VSliderViewModel = .init(
            behavior: .init(
                rounded: .init(useAnimation: true)
            ),
            layout: .init(),
            colors: .init()
        )
        
        return VStack(content: {
            RowView(
                title: "Rounded (Animation)",
                content: { VSlider(state: sliderState, value: $roundedSliderAnimationsValue, type: .rounded, viewModel: viewModel, onChange: nil) }
            )
            
            RowView(
                title: "Rounded (Steps, Animation)",
                content: { VSlider(state: sliderState, value: $roundedSliderSteppedAnimationsValue, step: 0.1, type: .rounded, viewModel: viewModel, onChange: nil) }
            )
        })
    }
    
    private var thinSliders: some View {
        VStack(content: {
            RowView(
                title: "Thin",
                content: { VSlider(state: sliderState, value: $thinSliderValue, type: .thin, viewModel: .init(), onChange: nil) }
            )
            
            RowView(
                title: "Thin (Steps)",
                content: { VSlider(state: sliderState, value: $thinSliderSteppedValue, step: 0.1, type: .thin, viewModel: .init(), onChange: nil) }
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
