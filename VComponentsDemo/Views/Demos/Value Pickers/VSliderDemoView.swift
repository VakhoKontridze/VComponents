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

    @State private var slider1Value: Double = 0.5
    @State private var slider2Value: Double = 0.5
    @State private var slider3Value: Double = 0.5
    @State private var slider4Value: Double = 0.5
    @State private var slider5Value: Double = 0.5
    
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
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Default"), content: {
                    Self.rowView(value: slider1Value, content: {
                        VSlider(state: sliderState, value: $slider1Value)
                    })
                })
                
                DemoRowView(type: .titled("Stepped"), content: {
                    Self.rowView(value: slider2Value, content: {
                        VSlider(step: 0.1, state: sliderState, value: $slider2Value)
                    })
                })
                
                DemoRowView(type: .titled("Thumb Border"), content: {
                    Self.rowView(value: slider3Value, content: {
                        VSlider(model: thumbBorderModel, state: sliderState, value: $slider3Value)
                    })
                })
                
                DemoRowView(type: .titled("Plain"), content: {
                    Self.rowView(value: slider4Value, content: {
                        VSlider(model: plainModel, state: sliderState, value: $slider4Value)
                    })
                })
                
                DemoRowView(type: .titled("Animation"), content: {
                    Self.rowView(value: slider5Value, content: {
                        VSlider(model: animationModel, state: sliderState, value: $slider5Value)
                    })
                })
            })
        })
    }
    
    static func rowView<Content>(
        value: Double,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        VStack(spacing: 10, content: {
            VBaseTitle(
                title: .init(value),
                color: ColorBook.primary,
                font: .footnote,
                type: .oneLine
            )
                .animation(.none)
            
            content()
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
