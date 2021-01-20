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
                    Self.rowView(title: .init(slider1Value), content: {
                        VSlider(state: sliderState, value: $slider1Value)
                    })
                })
                
                DemoRowView(type: .titled("Stepped"), content: {
                    Self.rowView(title: .init(slider2Value), content: {
                        VSlider(step: 0.15, state: sliderState, value: $slider2Value)
                    })
                })
                
                DemoRowView(type: .titled("Thumb Border"), content: {
                    Self.rowView(title: .init(slider3Value), content: {
                        VSlider(model: thumbBorderModel, state: sliderState, value: $slider3Value)
                    })
                })
                
                DemoRowView(type: .titled("Plain"), content: {
                    Self.rowView(title: .init(slider4Value), content: {
                        VSlider(model: plainModel, state: sliderState, value: $slider4Value)
                    })
                })
                
                DemoRowView(type: .titled("Animation"), content: {
                    Self.rowView(title: .init(slider5Value), content: {
                        VSlider(model: animationModel, state: sliderState, value: $slider5Value)
                    })
                })
            })
        })
    }
    
    static func rowView<Content>(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        VStack(spacing: 10, content: {
            VText(
                title: title,
                color: ColorBook.primary,
                font: .system(size: 14, weight: .regular, design: .monospaced),
                type: .oneLine
            )
                .animation(.none)
            
            content()
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
struct VSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSliderDemoView()
    }
}
