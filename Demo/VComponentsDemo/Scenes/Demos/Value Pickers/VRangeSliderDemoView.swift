//
//  VRangeSliderDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V RangeSlider Demo View
struct VRangeSliderDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Range Slider" }
    
    @State private var valueLow: Double = 0.3
    @State private var valueHigh: Double = 0.7
    @State private var isEnabled: Bool = true
    @State private var thumbType: RangeSliderThumbType = .standard
    @State private var hasStep: Bool = false
    @State private var stepValue: Double = 0.1
    @State private var diffValue: Double = 0.1
    @State private var progressAnimation: Bool = VRangeSliderModel.Animations().progress != nil
    
    private let minDiffValue: Double = 0.1
    private let maxDiffValue: Double = 0.25
    
    private let minStepValue: Double = 0.1
    private let maxStepValue: Double = 0.25
    
    private var model: VRangeSliderModel {
        let defaultModel: VRangeSliderModel = .init()
        
        var model: VRangeSliderModel = .init()
        
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
        DemoTitledSettingView(
            title: "\(String(format: "%.2f", valueLow)) - \(String(format: "%.2f", valueHigh))",
            content: {
                VRangeSlider(
                    model: model,
                    difference: diffValue,
                    step: hasStep ? stepValue : nil,
                    valueLow: $valueLow,
                    valueHigh: $valueHigh
                )
            }
        )
            .disabled(!isEnabled)
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VRangeSliderState(isEnabled: isEnabled) },
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
                HorizontallyLabeledDemoTitledSettingView(
                    value: stepValue,
                    min: minStepValue,
                    max: maxStepValue,
                    content: { VSlider(range: minStepValue...maxStepValue, step: 0.05, value: $stepValue) }
                )
            }
        })
        
        DemoViewSettingsSection(content: {
            VStack(spacing: 5, content: {
                VText(color: ColorBook.primary,font: .callout,  text: "Difference")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                
                HorizontallyLabeledDemoTitledSettingView(
                    value: diffValue,
                    min: minDiffValue,
                    max: maxDiffValue,
                    content: { VSlider(range: minDiffValue...maxDiffValue, step: 0.05, value: $diffValue) }
                ).disabled(true)
                
                VText(
                    type: .multiLine(alignment: .leading, lineLimit: nil),
                    color: ColorBook.secondary,
                    font: .footnote,
                    text: "Disabled for demo"
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $progressAnimation, title: "Progress Animation")
        })
    }
}

// MARK: - Helpers
private typealias VRangeSliderState =  VSecondaryButtonInternalState

private enum RangeSliderThumbType: Int, PickableTitledEnumeration {
    case standard
    case bordered
    
    var pickerTitle: String {
        switch self {
        case .standard: return "Standard"
        case .bordered: return "Bordered"
        }
    }
}

// MARK: - Preview
struct VRangeSliderDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRangeSliderDemoView()
    }
}
