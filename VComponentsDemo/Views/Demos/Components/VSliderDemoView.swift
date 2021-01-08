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
    
    private let thumbBorderModel: VSliderModel = .init(
        layout: .init(
            thumbBorderWidth: 1,
            thumbShadowRadius: 0
        ),
        colors: .init(
            thumb: .init(
                border: .init(
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
    
    private let plainModel: VSliderModel = .init(
        layout: .init(
            thumbDimension: 0,
            thumbCornerRadius: 0,
            thumbBorderWidth: 0,
            thumbShadowRadius: 0
        ),
        colors: .init(
            thumb: .init(
                fill: .init(
                    enabled: .clear,
                    disabled: .clear
                ),
                border: .init(
                    enabled: .clear,
                    disabled: .clear
                ),
                shadow: .init(
                    enabled: .clear,
                    disabled: .clear
                )
            )
        )
    )
    
    private let animationModel: VSliderModel = .init(
        behavior: .init(
            animation: .default
        )
    )

    @State private var sliderState: VSliderState = .enabled

    @State private var standard1Value: Double = 0.5
    @State private var standard2Value: Double = 0.5
    @State private var standard3Value: Double = 0.5
    @State private var standard4Value: Double = 0.5
    @State private var standard5Value: Double = 0.5
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
                isOn: .init(
                    get: { sliderState == .disabled },
                    set: { sliderState = $0 ? .disabled : .enabled }
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
