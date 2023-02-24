//
//  VTextViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI
import VComponents
import VCore

// MARK: V Text Field Demo View
struct VTextViewDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "TextView" }

    @State private var text: String = ""
    @State private var isEnabled: Bool = true
    @FocusState private var isFocused: Bool
    @State private var textLineLimitType: TextLineLimitTypeHelper = .default
    @State private var textViewHighlight: VTextViewHighlight = .none
    @State private var hasPlaceholder: Bool = true
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true
    @State private var numericalKeyboard: Bool = false
    @State private var textAlignment: TextAlignment = VTextViewUIModel.Layout().textAlignment
    @State private var autocapitalization: Bool = false
    @State private var autocorrection: Bool = false
    @State private var hasClearButton: Bool = VTextViewUIModel.Misc().hasClearButton
    
    private var uiModel: VTextViewUIModel {
        var uiModel: VTextViewUIModel = .init()
        
        uiModel.layout.textAlignment = textAlignment
        
        uiModel.colors = {
            switch textViewHighlight {
            case .none: return .init()
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }()
        
        uiModel.misc.keyboardType = numericalKeyboard ? .numberPad : .default
        
        uiModel.misc.autocorrection = autocorrection
        uiModel.misc.autocapitalization = autocapitalization ? .words : nil
        
        uiModel.misc.hasClearButton = hasClearButton
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settingsSections: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        ZStack(content: {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture(perform: { isFocused = false })
            
            VTextView(
                uiModel: uiModel,
                type: textLineLimitType.textLineLimitType,
                headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                placeholder: hasPlaceholder ? "Lorem ipsum" : nil,
                text: $text
            )
                .disabled(!isEnabled)
                .focused($isFocused)
        })
    }

    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VTextViewInternalState(isEnabled: isEnabled, isFocused: isFocused) },
                    set: { state in
                        isEnabled = state != .disabled
                        isFocused = state == .focused
                    }
                ),
                headerTitle: "State"
            )
        })

        DemoViewSettingsSection(content: {
            VWheelPicker(selection: $textLineLimitType, headerTitle: "Line Limit Type")

            VSegmentedPicker(selection: $textViewHighlight, headerTitle: "Highlight")
        })

        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasPlaceholder, title: "Placeholder")

            ToggleSettingView(isOn: $hasHeader, title: "Header")

            ToggleSettingView(isOn: $hasFooter, title: "Footer")
        })

        DemoViewSettingsSection(content: {
            ToggleSettingView(
                isOn: .constant(true),
                title: "Submit Button",
                description: "Default set to \"return\". Other types are not shown in the demo, as there are many."
            )

            ToggleSettingView(
                isOn: $hasClearButton,
                title: "Clear Button",
                description: "Not supported for secure type"
            )
        })

        DemoViewSettingsSection(content: {
            VStack(spacing: 20, content: {
                ToggleSettingView(
                    isOn: $numericalKeyboard,
                    title: "Numerical Keyboard",
                    description: "Many keyboard types are supported. ASCII and numerical are shown for demo."
                )

                ToggleSettingView(
                    isOn: .constant(false),
                    title: "Content Type",
                    description: "Default set to \"nil\". Other types are not shown in the demo, as there are many."
                )

                ToggleSettingView(
                    isOn: $autocorrection,
                    title: "Autocorrection"
                )
                
                ToggleSettingView(
                    isOn: $autocapitalization,
                    title: "Autocapitalization",
                    description: "Other types are not shown in the demo, as there are many."
                )

                VSegmentedPicker(selection: $textAlignment, headerTitle: "Alignment")
            })
        })
    }
}

// MARK: - Helpers
private enum TextLineLimitTypeHelper: StringRepresentableHashableEnumeration {
    case none
    case fixed
    case spaceReserved
    case partialRangeFrom
    case partialRangeThrough
    case closedRange
    
    var stringRepresentation: String {
        switch self {
        case .none: return "None"
        case .fixed: return "Fixed"
        case .spaceReserved: return "Space-Reserved"
        case .partialRangeFrom: return "Partial Range (From)"
        case .partialRangeThrough: return "Partial Range (To)"
        case .closedRange: return "Closed Range"
        }
    }
    
    var textLineLimitType: TextLineLimitType {
        switch self {
        case .none: return .none
        case .fixed: return .fixed(lineLimit: 10)
        case .spaceReserved: return .spaceReserved(lineLimit: 20, reservesSpace: true)
        case .partialRangeFrom: return .partialRangeFrom(lineLimit: 10...)
        case .partialRangeThrough: return .partialRangeThrough(lineLimit: ...20)
        case .closedRange: return .closedRange(lineLimit: 10...20)
        }
    }
    
    static var `default`: Self { .none }
}

private typealias VTextViewInternalState = VTextFieldInternalState

private typealias VTextViewHighlight = VTextFieldHighlight

// MARK: - Preview
struct VTextViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextViewDemoView()
    }
}
