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
    @State private var progressAnimation: Bool = VSliderUIModel.Animations().progress != nil
    
    private let minStepValue: Double = 0.1
    private let maxStepValue: Double = 0.25
    
    private var uiModel: VSliderUIModel {
        let defaultUIModel: VSliderUIModel = .init()
        
        var uiModel: VSliderUIModel = .init()
        
        switch thumbType {
        case .standard:
            break
        
        case .bordered:
            uiModel.layout.thumbBorderWidth = 1
            uiModel.layout.thumbShadowRadius = 0

            uiModel.colors.thumbBorder = .init(
                enabled: .black,
                disabled: .gray
            )

            uiModel.colors.thumbShadow = .init(
                enabled: .clear,
                disabled: .clear
            )
        
        case .none:
            uiModel.layout.thumbDimension = 0
            uiModel.layout.thumbCornerRadius = 0
            uiModel.layout.thumbBorderWidth = 0
            uiModel.layout.thumbShadowRadius = 0

            uiModel.colors.thumb = .init(
                enabled: .clear,
                disabled: .clear
            )

            uiModel.colors.thumbBorder = .init(
                enabled: .clear,
                disabled: .clear
            )

            uiModel.colors.thumbShadow = .init(
                enabled: .clear,
                disabled: .clear
            )
        }
        
        uiModel.animations.progress = progressAnimation ? (defaultUIModel.animations.progress == nil ? .default : defaultUIModel.animations.progress) : nil
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        DemoTitledSettingView(
            value: value,
            content: {
                VSlider(
                    uiModel: uiModel,
                    step: hasStep ? stepValue : nil,
                    value: $value
                )
            }
        )
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
                HorizontallyLabeledDemoTitledSettingView(
                    value: stepValue,
                    min: minStepValue,
                    max: maxStepValue,
                    content: { VSlider(range: minStepValue...maxStepValue, step: 0.05, value: $stepValue) }
                )
            }
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $progressAnimation, title: "Progress Animation")
        })
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
