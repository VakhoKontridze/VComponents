//
//  VRangeSliderDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK:- V Range Slider Demo View
struct VRangeSliderDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Range Slider"

    @State private var sliderState: VRangeSliderState = .enabled
    private let difference: Double = 0.1

    @State private var slider1ValueLow: Double = 0.3
    @State private var slider1ValueHigh: Double = 0.7
    
    @State private var slider2ValueLow: Double = 0.3
    @State private var slider2ValueHigh: Double = 0.7
    
    @State private var slider3ValueLow: Double = 0.3
    @State private var slider3ValueHigh: Double = 0.7
    
    @State private var slider4ValueLow: Double = 0.3
    @State private var slider4ValueHigh: Double = 0.7
    
    private let thumbBorderModel: VRangeSliderModel = {
        var model: VRangeSliderModel = .init()
        
        model.layout.thumbBorderWidth = 1
        model.layout.thumbShadowRadius = 0
        
        model.colors.thumb.border.enabled = .black
        model.colors.thumb.border.disabled = .gray
        
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
extension VRangeSliderDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Default"), content: {
                    VSliderDemoView.rowView(title: "\(slider1ValueLow) - \(slider1ValueHigh)", content: {
                        VRangeSlider(
                            difference: difference,
                            valueLow: $slider1ValueLow,
                            valueHigh: $slider1ValueHigh
                        )
                    })
                })
                
                DemoRowView(type: .titled("Stepped"), content: {
                    VSliderDemoView.rowView(title: "\(slider2ValueLow) - \(slider2ValueHigh)", content: {
                        VRangeSlider(
                            difference: difference,
                            step: 0.15,
                            valueLow: $slider2ValueLow,
                            valueHigh: $slider2ValueHigh
                        )
                    })
                })
                
                DemoRowView(type: .titled("Thumb Border"), content: {
                    VSliderDemoView.rowView(title: "\(slider3ValueLow) - \(slider3ValueHigh)", content: {
                        VRangeSlider(
                            model: thumbBorderModel,
                            difference: difference,
                            state: sliderState,
                            valueLow: $slider3ValueLow,
                            valueHigh: $slider3ValueHigh
                        )
                    })
                })

                DemoRowView(type: .titled("Animation"), content: {
                    VSliderDemoView.rowView(title: "\(slider4ValueLow) - \(slider4ValueHigh)", content: {
                        VRangeSlider(
                            model: animationModel,
                            difference: difference,
                            state: sliderState,
                            valueLow: $slider4ValueLow,
                            valueHigh: $slider4ValueHigh
                        )
                    })
                })
            })
        })
    }

    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ControllerToggleView(
                state: .init(
                    get: { sliderState == .disabled },
                    set: { sliderState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Preview
struct VRangeSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRangeSliderDemoView()
    }
}

