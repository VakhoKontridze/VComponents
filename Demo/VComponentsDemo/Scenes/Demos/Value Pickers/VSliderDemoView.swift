//
//  VSliderDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Slider Demo View
struct VSliderDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Slider" }
    
    @State private var value: Double = 0.5
    @State private var isEnabled: Bool = true
    @State private var thumbType: SliderThumbType = .standard
    @State private var hasStep: Bool = false
    @State private var stepValue: Double = 0.1
    @State private var progressAnimation: Bool = VSliderModel.Animations().progress != nil
    
    private let minStepValue: Double = 0.1
    private let maxStepValue: Double = 0.25
    
    private var model: VSliderModel {
        let defaultModel: VSliderModel = .init()
        
        var model: VSliderModel = .init()
        
        switch thumbType {
        case .standard:
            break
        
        case .bordered:
            model.layout.thumbBorderWidth = 1
            model.layout.thumbShadowRadius = 0

            model.colors.thumbBorder = .init(
                enabled: .black,
                disabled: .gray
            )

            model.colors.thumbShadow = .init(
                enabled: .clear,
                disabled: .clear
            )
        
        case .none:
            model.layout.thumbDimension = 0
            model.layout.thumbCornerRadius = 0
            model.layout.thumbBorderWidth = 0
            model.layout.thumbShadowRadius = 0

            model.colors.thumb = .init(
                enabled: .clear,
                disabled: .clear
            )

            model.colors.thumbBorder = .init(
                enabled: .clear,
                disabled: .clear
            )

            model.colors.thumbShadow = .init(
                enabled: .clear,
                disabled: .clear
            )
        }
        
        model.animations.progress = progressAnimation ? (defaultModel.animations.progress == nil ? .default : defaultModel.animations.progress) : nil
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Self.sliderRowView(title: .init(value), content: {
            VSlider(
                model: model,
                step: hasStep ? stepValue : nil,
                value: $value
            )
        })
            .disabled(!isEnabled)
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VSliderState(isEnabled: isEnabled) },
                    set: { isEnabled = $0 == .enabled }
                ),
                headerTitle: "State"
            )
        })
        
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $thumbType, headerTitle: "Thumb")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasStep, title: "Step")
            
            if hasStep {
                Self.labeledSliderRowView(title: .init(stepValue), min: minStepValue, max: maxStepValue, content: {
                    VSlider(range: minStepValue...maxStepValue, step: 0.05, value: $stepValue)
                })
            }
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $progressAnimation, title: "Progress Animation")
        })
    }

    static func sliderRowView<Content>(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        VStack(spacing: 10, content: {
            content()
            sliderText(title)
        })
    }
    
    static func labeledSliderRowView<Content>(
        title: String,
        min: Double, max: Double,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        sliderRowView(title: title, content: {
            HStack(spacing: 10, content: {
                sliderText(String(min))
                content()
                sliderText(String(max))
            })
        })
    }
    
    private static func sliderText(_ title: String) -> some View {
        VText(
            color: ColorBook.primary,
            font: .system(size: 14, weight: .regular, design: .monospaced),
            text: title
        )
            .animation(nil)
    }
}

// MARK: - Helpers
private typealias VSliderState = VSecondaryButtonInternalState

private enum SliderThumbType: Int, PickableTitledEnumeration {
    case standard
    case bordered
    case none
    
    var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .bordered: return "Bordered"
        case .none: return "None"
        }
    }
}

// MARK: - Preview
struct VSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSliderDemoView()
    }
}
